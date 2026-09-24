import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _auth = Get.find<AuthController>();
  String? _error;

  void _handleChange() {
    if (_passwordController.text.length < 6) {
      setState(() => _error = 'Mínimo 6 caracteres');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }
    setState(() => _error = null);
    _auth.changePassword(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(controller: _passwordController, label: 'Nueva contraseña', obscureText: true),
            const SizedBox(height: 16),
            CustomTextField(controller: _confirmController, label: 'Confirmar contraseña', obscureText: true),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            CustomButton(label: 'Cambiar contraseña', onPressed: _handleChange),
          ],
        ),
      ),
    );
  }
}