import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = Get.find<AuthController>();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _auth.login(_emailController.text.trim(), _passwordController.text);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 72, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('SecureLogin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
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
                validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
              ),
              Obx(() => _auth.errorMessage.value.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_auth.errorMessage.value, style: const TextStyle(color: Colors.red)),
                    )),
              const SizedBox(height: 24),
              CustomButton(label: 'Iniciar sesión', isLoading: _isLoading, onPressed: _handleLogin),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.register),
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}