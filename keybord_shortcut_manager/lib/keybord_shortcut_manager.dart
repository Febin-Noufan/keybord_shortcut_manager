import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardShortcutListener extends StatefulWidget {
  final Widget child;
  final List<ShortcutFocus> shortcuts;

  /// Expose a [ValueNotifier] for the child app to observe the shortcut visibility state.
  final ValueNotifier<bool> shortcutKeysVisible;

  const KeyboardShortcutListener({
    super.key,
    required this.child,
    required this.shortcuts,
    required this.shortcutKeysVisible,
  });

  @override
  // ignore: library_private_types_in_public_api
  _KeyboardShortcutListenerState createState() =>
      _KeyboardShortcutListenerState();
}

class _KeyboardShortcutListenerState extends State<KeyboardShortcutListener> {
  late Map<String, ShortcutFocus> shortcutMap;

  @override
  void initState() {
    super.initState();
    // Map shortcuts to actions for easy lookup
    shortcutMap = {
      for (var shortcut in widget.shortcuts) shortcut.key: shortcut
    };
  }

  // Handle key events
  // ignore: deprecated_member_use
  void handleKeyPress(RawKeyEvent event) {
    // ignore: deprecated_member_use
    if (event is RawKeyDownEvent) {
      // Handle ShiftLeft to toggle shortcut visibility
      if (event.logicalKey == LogicalKeyboardKey.shiftLeft) {
        widget.shortcutKeysVisible.value = !widget.shortcutKeysVisible.value;
      }

      // Handle shortcuts when enabled
      if (widget.shortcutKeysVisible.value) {
        String keyLabel = event.logicalKey.keyLabel.toLowerCase();
        if (shortcutMap.containsKey(keyLabel)) {
          shortcutMap[keyLabel]?.onFocus();
          if (shortcutMap[keyLabel]!.onPress) {
            shortcutMap[keyLabel]?.onSubmit();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: handleKeyPress,
      child: widget.child,
    );
  }
}

class ShortcutFocus {
  final String key; // The keyboard key for the shortcut
  final FocusNode focusNode; // The focus node for the field
  final Function onFocus; // Action to focus on the field
  final Function onSubmit; // Action to trigger the submit button
  final bool onPress;

  ShortcutFocus({
    required this.onPress,
    required this.key,
    required this.focusNode,
    required this.onFocus,
    required this.onSubmit,
  });
}
