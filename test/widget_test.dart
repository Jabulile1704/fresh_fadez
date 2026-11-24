import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_fadez/main.dart';
import 'package:fresh_fadez/screens/login_screen.dart';

void main() {
  testWidgets('App starts on the login screen', (tester) async {
    await tester.pumpWidget(const FreshFadezApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Fresh\nFadez'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Sign in leads to the shell and its glass navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const FreshFadezApp());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Sign in'));
    await tester.pump();
    // The simulated sign-in waits before navigating.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);
    for (final label in ['Home', 'Services', 'Bookings', 'Profile']) {
      expect(find.text(label), findsWidgets);
    }
  });
}
