import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keybord_shortcut_manager/keybord_shortcut_manager.dart';
import 'package:flutter/services.dart';

void main() {
  group('KeyboardShortcutManager Tests', () {
    late FocusNode field1;
    late FocusNode field2;
    late Map<String, FocusNode> shortcuts;

    setUp(() {
      field1 = FocusNode();
      field2 = FocusNode();
      shortcuts = {'A': field1, 'B': field2};
    });

    tearDown(() {
      field1.dispose();
      field2.dispose();
    });

    testWidgets('Hover overlay toggles on ampersand (&) key press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: KeyboardShortcutListener(
            shortcuts: shortcuts.entries.map((entry) {
              return ShortcutFocus(
                key: entry.key,
                focusNode: entry.value,
                onFocus: () {},
                onSubmit: () {},
              );
            }).toList(),
            child: const Placeholder(),
          ),
        ),
      );

      // Verify overlay is initially hidden.
      expect(find.text('Press A to focus on this field'), findsNothing);
      expect(find.text('Press B to focus on this field'), findsNothing);

      // Simulate pressing the ampersand (&) key.
      await tester.sendKeyEvent(LogicalKeyboardKey.ampersand);
      await tester.pump();

      // Verify overlay appears.
      expect(find.text('Press A to focus on this field'), findsOneWidget);
      expect(find.text('Press B to focus on this field'), findsOneWidget);

      // Simulate pressing the ampersand (&) key again.
      await tester.sendKeyEvent(LogicalKeyboardKey.ampersand);
      await tester.pump();

      // Verify overlay disappears.
      expect(find.text('Press A to focus on this field'), findsNothing);
      expect(find.text('Press B to focus on this field'), findsNothing);
    });

    testWidgets('Focus changes to correct field on shortcut key press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: KeyboardShortcutListener(
            shortcuts: shortcuts.entries.map((entry) {
              return ShortcutFocus(
                key: entry.key,
                focusNode: entry.value,
                onFocus: () {},
                onSubmit: () {},
              );
            }).toList(),
            child: Column(
              children: [
                TextField(focusNode: field1),
                TextField(focusNode: field2),
              ],
            ),
          ),
        ),
      );

      // Simulate pressing the ampersand (&) key to show overlay.
      await tester.sendKeyEvent(LogicalKeyboardKey.ampersand);
      await tester.pump();

      // Simulate pressing the "A" key to focus the first field.
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.pump();

      expect(field1.hasFocus, isTrue);
      expect(field2.hasFocus, isFalse);

      // Simulate pressing the "B" key to focus the second field.
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      await tester.pump();

      expect(field1.hasFocus, isFalse);
      expect(field2.hasFocus, isTrue);
    });
  });
}
