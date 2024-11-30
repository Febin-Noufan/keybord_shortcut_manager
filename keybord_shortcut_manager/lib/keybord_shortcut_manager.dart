import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardShortcutListener extends StatefulWidget {
  final Widget child;
  final List<ShortcutFocus> shortcuts;
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
  bool _shortcutActive = false;

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
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.altLeft) {
        _shortcutActive = !_shortcutActive;
        widget.shortcutKeysVisible.value = _shortcutActive;
        return; // Prevent further processing when Alt is pressed
      }

      if (_shortcutActive && widget.shortcutKeysVisible.value) {
        String keyLabel = event.logicalKey.keyLabel.toLowerCase();
        if (shortcutMap.containsKey(keyLabel)) {
          shortcutMap[keyLabel]?.onFocus();
          if (shortcutMap[keyLabel]!.onPress) {
            shortcutMap[keyLabel]?.onSubmit();
          }
        }
        // Don't process further key events when a shortcut is active
        return;
      }
    }
    // ... existing code for non-shortcut key handling ...
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
  final String key;
  final FocusNode focusNode;
  final Function onFocus;
  final Function onSubmit;
  final bool onPress;

  ShortcutFocus({
    required this.onPress,
    required this.key,
    required this.focusNode,
    required this.onFocus,
    required this.onSubmit,
  });
}