import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/otp_controller.dart';
import 'routes/app_routes.dart';
import 'screens/otp_screen.dart';
import 'screens/register_screen.dart';
import 'screens/success_screen.dart';

void main() {
  Get.put(OtpController());
  runApp(const OtpApp());
}

class OtpApp extends StatelessWidget {
  const OtpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SecureLogin (simplificado)',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.register,
      getPages: [
        GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
        GetPage(name: AppRoutes.otp, page: () => const OtpScreen()),
        GetPage(name: AppRoutes.success, page: () => const SuccessScreen()),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4F46E5),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black87),
      ),
    );
  }
}