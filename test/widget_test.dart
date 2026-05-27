import 'package:flutter_test/flutter_test.dart';
import 'package:designgrid_ai/main.dart';

void main() {
  testWidgets('Navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DesignGridApp());
    await tester.pumpAndSettle();

    // Verify that we start on the Home Page.
    expect(find.text('DesignGrid.AI'), findsOneWidget);

    // Tap on Studio and verify navigation to Creator Studio.
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(find.text('Creator Studio'), findsOneWidget);

    // Tap on Projects and verify navigation to My Projects.
    await tester.tap(find.text('Projects'));
    // We use pump() because NetworkImages fail to load in tests,
    // which prevents pumpAndSettle from finishing.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Disambiguate: We expect 2 "My Projects" texts (one in AppBar, one in TabBar)
    expect(find.text('My Projects'), findsNWidgets(2));
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Drafts'), findsOneWidget);
  });
}
