import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designgrid_ai/main.dart';

void main() {
  testWidgets('Navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DesignGridApp());
    await tester.pumpAndSettle();

    // Verify that we start on the Home Page (checking for specific elements).
    expect(find.text('DesignGrid.AI'), findsOneWidget);
    expect(find.text('Canvas Creator Studio'), findsOneWidget);

    // Verify that the Bottom Navigation Dock is present.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Studio'), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap on Studio and verify navigation.
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(find.text('Studio Page Placeholder'), findsOneWidget);

    // Tap on Projects and verify navigation.
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    expect(find.text('Projects Page Placeholder'), findsOneWidget);
  });
}
