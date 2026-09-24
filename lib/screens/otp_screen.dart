import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/otp_controller.dart';
import '../models/otp_verification.dart';
import '../widgets/custom_button.dart';
import '../widgets/otp_input.dart';
import 'inbox_screen.dart';

/// Screen used to display and verify an OTP code.
///
/// This screen allows the user to:
/// - View the destination where the OTP was sent.
/// - Enter the OTP code.
/// - Verify the entered code.
/// - View the remaining time before the OTP expires.
/// - Resend the OTP after it expires.
/// - Open the simulated inbox to view received OTP messages.
///
/// The screen is a [StatefulWidget] because it uses a GetX [Worker]
/// to listen for changes to the generated OTP code.
class OtpScreen extends StatefulWidget {
/// Creates an [OtpScreen].
const OtpScreen({super.key});

@override
State<OtpScreen> createState() => _OtpScreenState();
}

/// State class for [OtpScreen].
///
/// Manages the OTP input controller, the authentication controller,
/// the OTP purpose, and the GetX worker used to listen for new OTP codes.
class _OtpScreenState extends State<OtpScreen> {
/// Controller responsible for managing OTP operations.
final _otp = Get.find<OtpController>();

/// Controller responsible for managing authentication operations.
final _auth = Get.find<AuthController>();

/// Controller used to read and modify the OTP input field.
final _codeController = TextEditingController();

/// Purpose of the current OTP verification.
late final OtpPurpose _purpose;

/// GetX worker that listens for changes to the latest generated OTP.
late final Worker _codeWorker;

/// Initializes the screen and registers the OTP listener.
///
/// Retrieves the OTP purpose from the navigation arguments and creates
/// a GetX [Worker] using [ever] to listen for changes to [latestCode].
///
/// The initial OTP is also displayed after the first frame because it
/// may have been generated before this screen was created.
@override
void initState() {
super.initState();

_purpose = Get.arguments as OtpPurpose;

// Listen for changes to the latest OTP code.
_codeWorker = ever<String>(_otp.latestCode, (code) {
  if (code.isNotEmpty) {
    _showIncomingMessage(code);
  }
});

// Show the OTP generated before entering this screen.
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (_otp.latestCode.value.isNotEmpty) {
    _showIncomingMessage(_otp.latestCode.value);
  }
});

}

/// Displays a simulated incoming SMS notification containing the OTP.
///
/// When the notification is tapped, the OTP code is automatically
/// inserted into the input field.
void _showIncomingMessage(String code) {
Get.snackbar(
'Mensaje nuevo',
'Tu código de verificación es $code',
snackPosition: SnackPosition.TOP,
backgroundColor: Colors.white,
colorText: Colors.black87,
borderRadius: 16,
margin: const EdgeInsets.all(12),
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 14,
),
icon: const Icon(
Icons.sms_rounded,
color: Colors.indigo,
size: 28,
),
duration: const Duration(seconds: 5),
isDismissible: true,
forwardAnimationCurve: Curves.easeOutBack,

  // Automatically fill the OTP input when the notification is tapped.
  onTap: (_) => _codeController.text = code,
);

}

/// Verifies the OTP entered by the user.
///
/// A short delay is used before validating the code.
/// If the OTP is valid, the authentication controller is notified
/// so it can continue the appropriate authentication flow.
Future<void> _handleVerify() async {
await Future.delayed(
const Duration(milliseconds: 400),
);

final result = _otp.verifyOtp(_codeController.text);

if (result == OtpValidationResult.valid) {
  _auth.onOtpVerified(_purpose);
}

}

/// Releases resources used by the screen.
///
/// The GetX worker and the text controller are disposed of when
/// the screen is removed from the widget tree.
@override
void dispose() {
_codeWorker.dispose();
_codeController.dispose();
super.dispose();
}

/// Builds the OTP verification interface.
///
/// The interface displays the OTP destination, input field,
/// validation errors, expiration countdown, verification button,
/// and resend button.
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Verificación OTP'),
actions: [
/// Opens the simulated inbox.
IconButton(
tooltip: 'Bandeja de entrada',
icon: const Icon(Icons.inbox_outlined),
onPressed: () => Get.to(
() => const InboxScreen(),
),
),
],
),
body: Padding(
padding: const EdgeInsets.all(24),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
/// Displays an icon representing message verification.
const Icon(
Icons.mark_email_read_outlined,
size: 72,
color: Colors.indigo,
),

        const SizedBox(height: 16),

        /// Displays the destination where the OTP was sent.
        Obx(
          () => Text(
            'Enviamos un código de 6 dígitos a\n${_otp.destination.value}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),

        const SizedBox(height: 24),

        /// Input field used to enter the OTP.
        OtpInput(controller: _codeController),

        /// Displays OTP validation errors.
        Obx(
          () => Text(
            _otp.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          ),
        ),

        const SizedBox(height: 8),

        /// Displays the remaining OTP validity time.
        Obx(
          () => Text(
            _otp.isExpired.value
                ? 'El código ha expirado'
                : 'Expira en ${_otp.remainingSeconds.value} s',
            style: TextStyle(
              color: _otp.isExpired.value
                  ? Colors.red
                  : Colors.grey[700],
            ),
          ),
        ),

        const SizedBox(height: 24),

        /// Button used to verify the entered OTP.
        CustomButton(
          label: 'Verificar código',
          onPressed: _handleVerify,
        ),

        const SizedBox(height: 12),

        /// Allows the user to request a new OTP after expiration.
        Obx(
          () => TextButton(
            onPressed:
                _otp.isExpired.value ? _otp.resendOtp : null,
            child: Text(
              _otp.isExpired.value
                  ? 'Reenviar código'
                  : 'Reenviar disponible en ${_otp.remainingSeconds.value} s',
            ),
          ),
        ),
      ],
    ),
  ),
);

}
}
