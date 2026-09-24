import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;

  const OtpInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final otp = Get.find<OtpController>();

    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8),
          autofillHints: const [AutofillHints.oneTimeCode],
          decoration: const InputDecoration(counterText: '', hintText: '------'),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final code = otp.latestCode.value;
          final alreadyFilled = controller.text == code;
          if (code.isEmpty || alreadyFilled) return const SizedBox.shrink();

          return ActionChip(
            avatar: const Icon(Icons.sms_outlined, size: 18),
            label: Text('Usar código recibido: $code'),
            onPressed: () => controller.text = code,
          );
        }),
      ],
    );
  }
}