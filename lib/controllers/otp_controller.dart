import 'dart:async';
import 'package:get/get.dart';
import '../models/otp_verification.dart';
import '../services/otp_service.dart';

enum OtpValidationResult { valid, invalid, expired, alreadyUsed, notSent }

class OtpController extends GetxController {
  final _service = OtpService();
  static const int validitySeconds = 60;

  OtpVerification? _current;
  Timer? _timer;

  final destination = ''.obs;
  final remainingSeconds = 0.obs;
  final isExpired = false.obs;
  final errorMessage = ''.obs;
  final latestCode = ''.obs;
  final inbox = <OtpVerification>[].obs;

  void sendOtp(String to, OtpPurpose purpose) {
    final code = _service.generateCode();
    final now = DateTime.now();
    final expiry = now.add(const Duration(seconds: validitySeconds));

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

  void _startTimer() {
    _timer?.cancel();
    remainingSeconds.value = validitySeconds;
    isExpired.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        isExpired.value = true;
        t.cancel();
      }
    });
  }

  OtpValidationResult verifyOtp(String code) {
    final otp = _current;
    if (otp == null) return OtpValidationResult.notSent;
    if (otp.used) return OtpValidationResult.alreadyUsed;
    if (otp.isExpired || isExpired.value) return OtpValidationResult.expired;

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

  void resendOtp() {
    final old = _current;
    if (old == null) return;
    old.used = true;
    sendOtp(old.destination, old.purpose);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}