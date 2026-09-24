import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';
import '../models/otp_verification.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'inbox_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otp = Get.find<OtpController>();
  bool _isSending = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));

    _otp.sendOtp(_emailController.text.trim(), OtpPurpose.register);

    setState(() => _isSending = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código enviado. Revísalo en tu bandeja 📩')),
    );

    Get.toNamed(AppRoutes.otp, arguments: _emailController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person_add_alt_1, size: 72, color: Colors.indigo),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _emailController,
                label: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Correo inválido' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Contraseña',
                obscureText: true,
                validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Registrarme y enviar OTP',
                isLoading: _isSending,
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}