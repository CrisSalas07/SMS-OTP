import 'package:get/get.dart';
import '../models/otp_verification.dart';
import '../models/user.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'otp_controller.dart';

class AuthController extends GetxController {
  final _service = AuthService();
  final OtpController _otp = Get.find<OtpController>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentUser = Rxn<User>();

  User? _pendingUser;

  bool login(String email, String password) {
    final user = _service.findByEmail(email);
    if (user == null || user.password != password) {
      errorMessage.value = 'Correo o contraseña incorrectos.';
      return false;
    }
    _goToOtp(user, OtpPurpose.login);
    return true;
  }

  bool startRegister(String name, String email, String password) {
    if (_service.findByEmail(email) != null) {
      errorMessage.value = 'Ya existe una cuenta con ese correo.';
      return false;
    }
    final user = User(
      id: _service.nextId(),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
    _goToOtp(user, OtpPurpose.register);
    return true;
  }

  bool startRecovery(String email) {
    final user = _service.findByEmail(email);
    if (user == null) {
      errorMessage.value = 'No encontramos una cuenta con ese correo.';
      return false;
    }
    _goToOtp(user, OtpPurpose.passwordRecovery);
    return true;
  }

  void _goToOtp(User user, OtpPurpose purpose) {
    errorMessage.value = '';
    _pendingUser = user;
    _otp.sendOtp(user.email, purpose);
    Get.toNamed(AppRoutes.otp, arguments: purpose);
  }

  void onOtpVerified(OtpPurpose purpose) {
    final user = _pendingUser;
    if (user == null) return;

    switch (purpose) {
      case OtpPurpose.login:
        currentUser.value = user;
        _pendingUser = null;
        Get.offAllNamed(AppRoutes.home);
        break;
      case OtpPurpose.register:
        user.emailVerified = true;
        _service.addUser(user);
        currentUser.value = user;
        _pendingUser = null;
        Get.offAllNamed(AppRoutes.home);
        break;
      case OtpPurpose.passwordRecovery:
        Get.offNamed(AppRoutes.newPassword);
        break;
    }
  }

  void changePassword(String newPassword) {
    final user = _pendingUser;
    if (user == null) return;
    _service.updatePassword(user, newPassword);
    _pendingUser = null;
    Get.offAllNamed(AppRoutes.login);
    Get.snackbar('Contraseña actualizada', 'Ya puedes iniciar sesión.');
  }

  void logout() {
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}