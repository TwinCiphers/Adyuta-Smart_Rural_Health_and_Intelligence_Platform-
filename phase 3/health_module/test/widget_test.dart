// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:health_module/main.dart';

void main() {
  testWidgets('Smoke test for AdyutaHealthApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: AdyutaHealthApp()));

    // Verify that the app starts.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
