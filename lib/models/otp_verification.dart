enum OtpPurpose { login, register, passwordRecovery }

class OtpVerification {
  final String destination;
  final String code;
  final OtpPurpose purpose;
  final DateTime createdAt;
  final DateTime expiresAt;
  int attempts;
  bool used;

  OtpVerification({
    required this.destination,
    required this.code,
    required this.purpose,
    required this.createdAt,
    required this.expiresAt,
    this.attempts = 0,
    this.used = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}