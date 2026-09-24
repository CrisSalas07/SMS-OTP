import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/otp_controller.dart';
import 'routes/app_routes.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/new_password_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/register_screen.dart';

/// Entry point of the Flutter application.
///
/// Initializes the required GetX controllers and starts the application.
void main() {
/// Registers the OTP controller as a dependency in GetX.
///
/// This allows the controller to be retrieved from other parts
/// of the application using [Get.find].
Get.put(OtpController());

/// Registers the authentication controller as a dependency in GetX.
///
/// This controller depends on [OtpController], which is registered
/// before it.
Get.put(AuthController());

/// Starts the application.
runApp(const OtpApp());
}

/// Root widget of the SecureLogin application.
///
/// Configures the application's navigation, available routes,
/// title, and global visual theme.
class OtpApp extends StatelessWidget {
/// Creates the root application widget.
const OtpApp({super.key});

/// Builds the application configuration.
///
/// Uses [GetMaterialApp] to provide Flutter's Material design
/// components together with GetX navigation and dependency management.
@override
Widget build(BuildContext context) {
return GetMaterialApp(
/// Application title.
title: 'SecureLogin',

  /// Hides the debug banner displayed in the top-right corner.
  debugShowCheckedModeBanner: false,

  /// Defines the first screen displayed when the application starts.
  initialRoute: AppRoutes.login,

  /// Defines all named routes available in the application.
  getPages: [
    /// Login screen.
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),

    /// User registration screen.
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),

    /// OTP verification screen.
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
    ),

    /// Password recovery screen.
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    /// New password screen.
    GetPage(
      name: AppRoutes.newPassword,
      page: () => const NewPasswordScreen(),
    ),

    /// Home screen displayed after successful authentication.
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
  ],

  /// Defines the global visual theme of the application.
  theme: ThemeData(
    /// Enables Material 3 design components.
    useMaterial3: true,

    /// Defines the main color used to generate the application's
    /// color scheme.
    colorSchemeSeed: const Color(0xFF4F46E5),

    /// Defines the default background color for application screens.
    scaffoldBackgroundColor: const Color(0xFFF7F7FB),

    /// Configures the appearance of text input fields.
    inputDecorationTheme: InputDecorationTheme(
      /// Gives input fields a filled background.
      filled: true,

      /// Sets the background color of input fields.
      fillColor: Colors.white,

      /// Removes the default visible border and applies
      /// rounded corners.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    /// Configures the default appearance of elevated buttons.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        /// Adds vertical padding inside buttons.
        padding: const EdgeInsets.symmetric(vertical: 16),

        /// Gives buttons rounded corners.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    /// Configures the default appearance of application bars.
    appBarTheme: const AppBarTheme(
      /// Makes the AppBar background transparent.
      backgroundColor: Colors.transparent,

      /// Removes the AppBar shadow.
      elevation: 0,

      /// Sets the default color of AppBar foreground elements.
      foregroundColor: Colors.black87,
    ),
  ),
);

}
}
