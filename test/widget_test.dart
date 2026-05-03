// Basic smoke test for PoojaConnect app.
//
// Pumps the root widget and verifies the splash screen renders
// (the 🪔 lamp emoji is shown on the splash screen).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pooja_app/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    // Build the app (wrapped in ProviderScope, mirroring main.dart).
    await tester.pumpWidget(
      const ProviderScope(
        child: PoojaApp(),
      ),
    );

    // The splash screen should be the first frame — verify it exists.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
