import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';

/// ANTES: recibía el OtpService por constructor y leía su historial
/// directo, con setState() manual y un RefreshIndicator falso.
/// AHORA: obtiene el controlador con Get.find() (el mismo que ya está
/// vivo desde main.dart) y usa Obx() sobre la lista `inbox`. Cuando
/// llega un código nuevo, esta pantalla se actualiza sola, sin pedirlo.
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otp = Get.find<OtpController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Bandeja de entrada (simulada)')),
      body: Obx(() {
        final messages = otp.inbox;
        if (messages.isEmpty) {
          return const Center(child: Text('Aún no has recibido ningún código.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final message = messages[index];
            final expired = message.isExpired;
            return ListTile(
              leading: Icon(Icons.sms_outlined, color: expired ? Colors.grey : Colors.indigo),
              title: Text(
                message.code,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
              subtitle: Text('Para: ${message.destination}'),
              trailing: Chip(
                label: Text(expired ? 'Expirado' : 'Vigente'),
                backgroundColor: expired ? Colors.grey.shade200 : Colors.green.shade100,
                labelStyle: TextStyle(color: expired ? Colors.grey.shade700 : Colors.green.shade800),
              ),
            );
          },
        );
      }),
    );
  }
}
