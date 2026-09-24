import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/otp_controller.dart';
import '../models/otp_verification.dart';
import '../widgets/custom_button.dart';
import '../widgets/otp_input.dart';
import 'inbox_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otp = Get.find<OtpController>();
    final auth = Get.find<AuthController>();
    final purpose = Get.arguments as OtpPurpose;
    final codeController = TextEditingController();

    Future<void> handleVerify() async {
      await Future.delayed(const Duration(milliseconds: 400));
      final result = otp.verifyOtp(codeController.text);
      if (result == OtpValidationResult.valid) {
        auth.onOtpVerified(purpose);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación OTP'),
        actions: [
          IconButton(
            tooltip: 'Bandeja de entrada',
            icon: const Icon(Icons.inbox_outlined),
            onPressed: () => Get.to(() => const InboxScreen()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.mark_email_read_outlined, size: 72, color: Colors.indigo),
            const SizedBox(height: 16),
            Obx(() => Text(
                  'Enviamos un código de 6 dígitos a\n${otp.destination.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(height: 24),
            OtpInput(controller: codeController),
            Obx(() => Text(otp.errorMessage.value, style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 8),
            Obx(() => Text(
                  otp.isExpired.value ? 'El código ha expirado' : 'Expira en ${otp.remainingSeconds.value} s',
                  style: TextStyle(color: otp.isExpired.value ? Colors.red : Colors.grey[700]),
                )),
            const SizedBox(height: 24),
            CustomButton(label: 'Verificar código', onPressed: handleVerify),
            const SizedBox(height: 12),
            Obx(() => TextButton(
                  onPressed: otp.isExpired.value ? otp.resendOtp : null,
                  child: Text(otp.isExpired.value ? 'Reenviar código' : 'Reenviar disponible en ${otp.remainingSeconds.value} s'),
                )),
          ],
        ),
      ),
    );
  }
}