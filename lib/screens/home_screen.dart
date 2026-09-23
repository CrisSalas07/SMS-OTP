import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: auth.logout),
        ],
      ),
      body: Obx(() {
        final user = auth.currentUser.value;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, size: 72, color: Colors.green),
                const SizedBox(height: 16),
                Text('¡Bienvenido, ${user?.name ?? ''}!',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                const Chip(
                  avatar: Icon(Icons.check, size: 18, color: Colors.green),
                  label: Text('Contraseña verificada'),
                ),
                const SizedBox(height: 8),
                const Chip(
                  avatar: Icon(Icons.check, size: 18, color: Colors.green),
                  label: Text('Código OTP verificado'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}