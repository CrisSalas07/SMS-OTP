import 'dart:async';
import 'package:get/get.dart';
import '../models/otp_verification.dart';
import '../services/otp_service.dart';

/// Represents the possible results when validating an OTP.
enum OtpValidationResult {valid,invalid,expired,alreadyUsed,notSent,}

/// Controller responsible for managing OTP operations.
///
/// This controller handles OTP generation, expiration timers, validation,
/// resending, and the temporary storage of generated OTPs.
///
/// It uses [OtpService] to generate OTP codes and [OtpVerification] to
/// store information about each generated OTP.
class OtpController extends GetxController {
/// Service used to generate OTP codes.
final _service = OtpService();

/// The amount of time, in seconds, that an OTP remains valid.
static const int validitySeconds = 60;

/// Stores the currently active OTP verification.
///
/// This value is `null` when there is no active OTP.
OtpVerification? _current;

/// Timer used to keep track of the OTP expiration countdown.
Timer? _timer;

/// Stores the destination where the OTP was sent.
///
/// This can be an email address or a phone number.
final destination = ''.obs;

/// Stores the number of seconds remaining before the OTP expires.
final remainingSeconds = 0.obs;

/// Indicates whether the current OTP has expired.
final isExpired = false.obs;

/// Stores the error message generated during OTP validation.
final errorMessage = ''.obs;

/// Stores the most recently generated OTP code.
///
/// This can be useful for testing or simulated OTP delivery.
final latestCode = ''.obs;

/// Stores the history of generated OTP verifications.
///
/// The newest OTP is inserted at the beginning of the list.
final inbox = <OtpVerification>[].obs;

/// Generates and sends a new OTP.
///
/// Creates an [OtpVerification] object with a generated code,
/// creation time, expiration time, destination, and purpose.
///
/// The new OTP becomes the currently active OTP and the expiration
/// countdown is started.
void sendOtp(String to, OtpPurpose purpose) {
final code = _service.generateCode();
final now = DateTime.now();
final expiry = now.add(
const Duration(seconds: validitySeconds),
);

_current = OtpVerification(
  destination: to,
  code: code,
  purpose: purpose,
  createdAt: now,
  expiresAt: expiry,
);

destination.value = to;
errorMessage.value = '';
latestCode.value = code;
inbox.insert(0, _current!);

_startTimer();

}

/// Starts the countdown timer for the current OTP.
///
/// Cancels any previously running timer before starting a new one.
/// The timer decreases [remainingSeconds] every second until it
/// reaches zero, at which point the OTP is marked as expired.
void _startTimer() {
_timer?.cancel();
remainingSeconds.value = validitySeconds;
isExpired.value = false;

_timer = Timer.periodic(
  const Duration(seconds: 1),
  (t) {
    if (remainingSeconds.value > 0) {
      remainingSeconds.value--;
    } else {
      isExpired.value = true;
      t.cancel();
    }
  },
);

}

/// Validates the OTP entered by the user.
///
/// Returns an [OtpValidationResult] indicating whether the OTP is valid,
/// invalid, expired, already used, or has not been sent.
///
/// If the entered code is incorrect, the number of attempts for the
/// current OTP is increased and an error message is displayed.
///
/// If the code is correct, the OTP is marked as used and the expiration
/// timer is stopped.
OtpValidationResult verifyOtp(String code) {
final otp = _current;

if (otp == null) {
  return OtpValidationResult.notSent;
}

if (otp.used) {
  return OtpValidationResult.alreadyUsed;
}

if (otp.isExpired || isExpired.value) {
  return OtpValidationResult.expired;
}

if (code.trim() != otp.code) {
  otp.attempts++;
  errorMessage.value = 'Código incorrecto. Intenta de nuevo.';
  return OtpValidationResult.invalid;
}

otp.used = true;
_timer?.cancel();
errorMessage.value = '';

return OtpValidationResult.valid;

}

/// Generates and sends a new OTP for the current destination and purpose.
///
/// The previous OTP is marked as used before generating the new one.
/// If there is no active OTP, the method does nothing.
void resendOtp() {
final old = _current;

if (old == null) return;

old.used = true;
sendOtp(old.destination, old.purpose);

}

/// Cleans up resources when the controller is removed.
///
/// Cancels the active timer to prevent it from continuing to run
/// after the controller has been disposed.
@override
void onClose() {
_timer?.cancel();
super.onClose();
}
}
