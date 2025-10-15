// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('LetzLevitate app smoke test', (WidgetTester tester) async {
    // Reset GetX state before test
    Get.reset();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that we can find the app title
    expect(find.text('LetzLevitate'), findsWidgets);

    // Verify splash screen appears
    expect(find.byType(Scaffold), findsWidgets);
  });
}
