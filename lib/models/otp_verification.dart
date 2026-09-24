/// Defines the purpose of an OTP verification code.
enum OtpPurpose {login,register,passwordRecovery,}

/// Represents an OTP verification request.
///
/// This class stores the information required to validate a
/// one-time password, including its destination, code, purpose,
/// creation time, expiration time, number of attempts, and
/// whether the code has already been used.
class OtpVerification {
/// The destination where the OTP was sent.
///
/// This can be an email address or a phone number.
final String destination;

/// The one-time password code.
final String code;

/// The purpose for which the OTP was generated.
final OtpPurpose purpose;

/// The date and time when the OTP was created.
final DateTime createdAt;

/// The date and time when the OTP expires.
final DateTime expiresAt;

/// The number of attempts made to verify the OTP.
///
/// The value starts at 0 and can be increased after each
/// unsuccessful verification attempt.
int attempts;

/// Indicates whether the OTP has already been successfully used.
///
/// A value of `true` means the OTP can no longer be used.
bool used;

/// Creates an [OtpVerification] instance.
///
/// [destination] specifies where the OTP was sent.
/// [code] contains the OTP value.
/// [purpose] specifies why the OTP was generated.
/// [createdAt] specifies when the OTP was created.
/// [expiresAt] specifies when the OTP becomes invalid.
/// [attempts] tracks the number of verification attempts.
/// [used] indicates whether the OTP has already been used.
OtpVerification({
required this.destination,
required this.code,
required this.purpose,
required this.createdAt,
required this.expiresAt,
this.attempts = 0,
this.used = false,
});

/// Returns `true` if the OTP has passed its expiration time.
///
/// This getter compares the current date and time with [expiresAt].
bool get isExpired => DateTime.now().isAfter(expiresAt);
}
