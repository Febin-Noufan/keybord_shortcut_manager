import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_shortcut_listener/keybord_shortcut_manager.dart';

void main() {
  group('KeyboardShortcutListener', () {
    testWidgets('Shortcut visibility toggle', (WidgetTester tester) async {
      // Create a ValueNotifier to track shortcut visibility
      final shortcutKeysVisible = ValueNotifier<bool>(false);

      // Flags to track if actions were called
      bool focusCalled = false;
      bool submitCalled = false;

      // Create a test focus node and shortcut
      final testFocusNode = FocusNode();
      final testShortcut = ShortcutFocus(
        key: 'a',
        focusNode: testFocusNode,
        onFocus: () => focusCalled = true,
        onSubmit: () => submitCalled = true,
        onPress: true,
      );

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: KeyboardShortcutListener(
            shortcutKeysVisible: shortcutKeysVisible,
            shortcuts: [testShortcut],
            child: Scaffold(
              body: TextField(
                focusNode: testFocusNode,
              ),
            ),
          ),
        ),
      );

      // Simulate left shift key press to toggle visibility
      await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
      expect(shortcutKeysVisible.value, isTrue, 
        reason: 'Shortcut visibility should toggle to true on first shift press');

      // Simulate 'a' key press when shortcuts are visible
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      // Verify that actions were called
      expect(focusCalled, isTrue, 
        reason: 'onFocus should be called when shortcut is visible');
      expect(submitCalled, isTrue, 
        reason: 'onSubmit should be called when onPress is true');

      // Reset flags
      focusCalled = false;
      submitCalled = false;

      // Simulate left shift key press to hide shortcuts
      await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
      expect(shortcutKeysVisible.value, isFalse, 
        reason: 'Shortcut visibility should toggle to false on second shift press');

      // Simulate 'a' key press when shortcuts are not visible
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      // Verify that actions were not called
      expect(focusCalled, isFalse, 
        reason: 'onFocus should not be called when shortcuts are not visible');
      expect(submitCalled, isFalse, 
        reason: 'onSubmit should not be called when shortcuts are not visible');
    });

    testWidgets('Multiple shortcuts handling', (WidgetTester tester) async {
      final shortcutKeysVisible = ValueNotifier<bool>(true);

      bool firstFocusCalled = false;
      bool secondFocusCalled = false;

      final firstFocusNode = FocusNode();
      final secondFocusNode = FocusNode();

      final testShortcuts = [
        ShortcutFocus(
          key: 'a',
          focusNode: firstFocusNode,
          onFocus: () => firstFocusCalled = true,
          onSubmit: () {},
          onPress: false,
        ),
        ShortcutFocus(
          key: 'b',
          focusNode: secondFocusNode,
          onFocus: () => secondFocusCalled = true,
          onSubmit: () {},
          onPress: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: KeyboardShortcutListener(
            shortcutKeysVisible: shortcutKeysVisible,
            shortcuts: testShortcuts,
            child: Scaffold(
              body: Column(
                children: [
                  TextField(focusNode: firstFocusNode),
                  TextField(focusNode: secondFocusNode),
                ],
              ),
            ),
          ),
        ),
      );

      // Simulate 'a' key press
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      expect(firstFocusCalled, isTrue, 
        reason: 'First shortcut should be triggered');
      expect(secondFocusCalled, isFalse, 
        reason: 'Second shortcut should not be triggered');
    });
  });
}