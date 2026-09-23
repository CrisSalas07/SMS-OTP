import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _auth = Get.find<AuthController>();
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _auth.startRecovery(_emailController.text.trim());
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.key_outlined, size: 72, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text('Te enviaremos un código para recuperar tu acceso.'),
            const SizedBox(height: 24),
            CustomTextField(controller: _emailController, label: 'Correo electrónico'),
            Obx(() => _auth.errorMessage.value.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_auth.errorMessage.value, style: const TextStyle(color: Colors.red)),
                  )),
            const SizedBox(height: 24),
            CustomButton(label: 'Continuar', isLoading: _isLoading, onPressed: _handleContinue),
          ],
        ),
      ),
    );
  }
}