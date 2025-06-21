import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_app/main.dart';
import 'package:novel_app/screens/main_navigation_page.dart';

void main() {
  setUp(() {});

  testWidgets(
    'App starts with SplashScreen and navigates directly to MainNavigationPage',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(MainNavigationPage), findsOneWidget);
    },
  );
}
