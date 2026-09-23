import '../models/user.dart';

class AuthService {
  final List<User> _users = [
    User(id: 1, name: 'Usuario Demo', email: 'demo@ucr.ac.cr', password: '123456', emailVerified: true),
  ];

  User? findByEmail(String email) {
    for (final u in _users) {
      if (u.email == email.trim().toLowerCase()) return u;
    }
    return null;
  }

  int nextId() => _users.length + 1;
  void addUser(User user) => _users.add(user);
  void updatePassword(User user, String newPassword) => user.password = newPassword;
}