import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designgrid_ai/main.dart';

void main() {
  testWidgets('Navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DesignGridApp());
    await tester.pumpAndSettle();

    // 1. Welcome Page
    expect(find.text('Get Started'), findsOneWidget);

    // 2. To Login
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);

    // 3. Sign In
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // 4. Home Page Check
    expect(find.text('Canvas Creator Studio'), findsOneWidget);

    // 5. Navigate to Studio via label
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(find.text('Creator Studio'), findsOneWidget);

    // 6. Navigate to Projects via label
    await tester.tap(find.text('Projects'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('My Projects'), findsWidgets);
  });
}
