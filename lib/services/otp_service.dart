import 'dart:math';

class OtpService {
  final _random = Random();

  String generateCode() {
    return (100000 + _random.nextInt(900000)).toString();
  }
}