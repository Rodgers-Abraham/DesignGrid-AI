import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designgrid_ai/main.dart';

void main() {
  testWidgets('Navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DesignGridApp());
    await tester.pumpAndSettle();

    // Verify that we start on the Welcome Page.
    expect(find.text('Get Started'), findsOneWidget);

    // Click Get Started to go to Home.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify that we are on the Home Page.
    expect(find.text('DesignGrid.AI'), findsOneWidget);

    // Tap on Studio and verify navigation to Creator Studio.
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(find.text('Creator Studio'), findsOneWidget);

    // Tap on Projects and verify navigation to My Projects.
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    
    // Disambiguate: We expect 2 "My Projects" texts (one in AppBar, one in TabBar)
    expect(find.text('My Projects'), findsNWidgets(2));
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Drafts'), findsOneWidget);
  });
}
