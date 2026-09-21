import 'package:flutter_test/flutter_test.dart';

import 'package:hair_salon_app/main.dart';
import 'package:hair_salon_app/screens/login_screen.dart';

void main() {
  testWidgets('App starts on the login screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
