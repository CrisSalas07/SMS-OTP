import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:sms_otp/controllers/auth_controller.dart';
import 'package:sms_otp/controllers/otp_controller.dart';
import 'package:sms_otp/main.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(OtpController());
    Get.put(AuthController());
  });

  tearDown(Get.reset);

  testWidgets('App starts on the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OtpApp());
    await tester.pumpAndSettle();

    expect(find.text('SecureLogin'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('Login shows validation errors when fields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(const OtpApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();

    expect(find.text('Correo inválido'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña'), findsOneWidget);
  });
}
