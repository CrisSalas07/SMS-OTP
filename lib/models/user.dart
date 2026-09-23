class User {
  final int id;
  final String name;
  final String email;
  String password;
  bool emailVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.emailVerified = false,
  });
}