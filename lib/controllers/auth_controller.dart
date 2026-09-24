import 'package:get/get.dart';
import '../models/otp_verification.dart';
import '../models/user.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'otp_controller.dart';

/// Controller responsible for managing user authentication.
///
/// This controller handles the main authentication flows of the application,
/// including login, user registration, password recovery, OTP verification,
/// password changes, and logout.
///
/// It communicates with [AuthService] to manage user data and with
/// [OtpController] to handle OTP verification.
class AuthController extends GetxController {
/// Service used to manage and retrieve user information.
final _service = AuthService();

/// Controller responsible for sending and verifying OTP codes.
final OtpController _otp = Get.find<OtpController>();

/// Indicates whether an authentication operation is currently in progress.
final isLoading = false.obs;

/// Stores the current authentication error message.
///
/// An empty string means that there is no error.
final errorMessage = ''.obs;

/// Stores the currently authenticated user.
///
/// The value is `null` when no user is logged in.
final currentUser = Rxn<User>();

/// Temporarily stores the user involved in an authentication flow.
///
/// This is used while waiting for OTP verification during login,
/// registration, or password recovery.
User? _pendingUser;

/// Attempts to log in a user using their email and password.
///
/// Returns `true` if the credentials are valid and the OTP verification
/// process is started.
///
/// Returns `false` if the email is not registered or the password is
/// incorrect.
bool login(String email, String password) {
final user = _service.findByEmail(email);

if (user == null || user.password != password) {
  errorMessage.value = 'Correo o contraseña incorrectos.';
  return false;
}

_goToOtp(user, OtpPurpose.login);
return true;

}

/// Starts the user registration process.
///
/// Checks whether the provided email is already registered. If it is,
/// the registration process is rejected.
///
/// Otherwise, a new [User] is created and stored temporarily until
/// the OTP verification is completed.
///
/// Returns `true` if the registration process is started successfully.
/// Returns `false` if an account with the provided email already exists.
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

/// Starts the password recovery process for the specified email.
///
/// Checks whether an account exists with the provided email.
/// If the account exists, an OTP verification process is started.
///
/// Returns `true` if the recovery process is started successfully.
/// Returns `false` if no account is found with the provided email.
bool startRecovery(String email) {
final user = _service.findByEmail(email);

if (user == null) {
  errorMessage.value = 'No encontramos una cuenta con ese correo.';
  return false;
}

_goToOtp(user, OtpPurpose.passwordRecovery);
return true;

}

/// Starts the OTP verification process for the specified user.
///
/// Stores the user temporarily, sends an OTP with the specified [purpose],
/// and navigates the user to the OTP verification screen.
void _goToOtp(User user, OtpPurpose purpose) {
errorMessage.value = '';
_pendingUser = user;

_otp.sendOtp(user.email, purpose);

Get.toNamed(
  AppRoutes.otp,
  arguments: purpose,
);


}

/// Handles the actions required after a successful OTP verification.
///
/// The action performed depends on the [purpose] of the OTP:
///
/// - [OtpPurpose.login]: logs the user into the application.
/// - [OtpPurpose.register]: verifies the user's email and creates the account.
/// - [OtpPurpose.passwordRecovery]: navigates the user to the new password screen.
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

/// Changes the password of the user involved in the current recovery flow.
///
/// After successfully updating the password, the temporary user data is
/// cleared and the user is redirected to the login screen.
void changePassword(String newPassword) {
final user = _pendingUser;

if (user == null) return;

_service.updatePassword(user, newPassword);
_pendingUser = null;

Get.offAllNamed(AppRoutes.login);

Get.snackbar(
  'Contraseña actualizada',
  'Ya puedes iniciar sesión.',
);


}

/// Logs out the currently authenticated user.
///
/// Clears the current user and redirects to the login screen.
void logout() {
currentUser.value = null;
Get.offAllNamed(AppRoutes.login);
}
}
