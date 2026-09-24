import 'package:flutter/material.dart';
 
/// El autocompletado ahora lo resuelve por completo el banner de
/// "mensaje entrante" en otp_screen.dart (tocarlo llena el campo).
/// Este widget vuelve a ser solo el campo de 6 dígitos, sin chip.
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
 
  const OtpInput({super.key, required this.controller});
 
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24, letterSpacing: 8),
      // Deja lista la conexión con el autocompletado NATIVO del
      // sistema operativo, por si en el futuro conectas un SMS real.
      autofillHints: const [AutofillHints.oneTimeCode],
      decoration: const InputDecoration(counterText: '', hintText: '------'),
    );
  }
}