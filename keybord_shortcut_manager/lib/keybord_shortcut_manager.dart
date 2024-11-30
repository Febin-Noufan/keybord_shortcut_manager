// ignore: unnecessary_library_name
library keyboard_shortcut_listener;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that enables keyboard shortcut functionality with configurable actions.
///
/// This widget wraps child widgets and provides a mechanism to listen to keyboard events,
/// trigger focus and submit actions based on specific key presses, and toggle shortcut visibility.
class KeyboardShortcutListener extends StatefulWidget {
  /// The child widget to be wrapped with keyboard shortcut functionality.
  final Widget child;

  /// A list of [ShortcutFocus] configurations defining keyboard shortcuts.
  final List<ShortcutFocus> shortcuts;

  /// A [ValueNotifier] to control and observe the visibility of shortcut keys.
  ///
  /// When set to true, keyboard shortcuts are active and can be triggered.
  final ValueNotifier<bool> shortcutKeysVisible;

  /// Creates a [KeyboardShortcutListener] widget.
  ///
  /// [child] is the widget to be wrapped.
  /// [shortcuts] defines the keyboard shortcuts and their associated actions.
  /// [shortcutKeysVisible] controls the visibility and activation of shortcuts.
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

/// The state class for [KeyboardShortcutListener] that manages keyboard event handling.
class _KeyboardShortcutListenerState extends State<KeyboardShortcutListener> {
  /// A map to efficiently lookup shortcut configurations by their key.
  late Map<String, ShortcutFocus> shortcutMap;

  @override
  void initState() {
    super.initState();
    // Convert the list of shortcuts into a map for faster key-based lookups
    shortcutMap = {
      for (var shortcut in widget.shortcuts) shortcut.key: shortcut
    };
  }

  /// Handles keyboard events and triggers appropriate actions.
  ///
  /// This method does two primary things:
  /// 1. Toggles shortcut visibility when the left shift key is pressed
  /// 2. Triggers focus and submit actions for configured shortcuts
  // ignore: deprecated_member_use
  void handleKeyPress(RawKeyEvent event) {
    // Check for key down events to prevent multiple triggers
    // ignore: deprecated_member_use
    if (event is RawKeyDownEvent) {
      // Toggle shortcut visibility when left shift is pressed
      // ignore: deprecated_member_use
      if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
        widget.shortcutKeysVisible.value = !widget.shortcutKeysVisible.value;
      }

      // Process shortcuts only when shortcut keys are visible
      if (widget.shortcutKeysVisible.value) {
        String keyLabel = event.logicalKey.keyLabel.toLowerCase();
        
        // Check if the pressed key matches any configured shortcut
        if (shortcutMap.containsKey(keyLabel)) {
          // Trigger focus action
          shortcutMap[keyLabel]?.onFocus();

          // Conditionally trigger submit action based on onPress configuration
          if (shortcutMap[keyLabel]!.onPress) {
            shortcutMap[keyLabel]?.onSubmit();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the child with RawKeyboardListener to capture keyboard events
    // ignore: deprecated_member_use
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: handleKeyPress,
      child: widget.child,
    );
  }
}

/// Represents a keyboard shortcut configuration with associated actions.
///
/// This class allows defining complex keyboard interactions for form fields
/// or other interactive widgets.
class ShortcutFocus {
  /// The keyboard key representing the shortcut (lowercase).
  final String key;

  /// The [FocusNode] associated with the target widget or field.
  final FocusNode focusNode;

  /// A function to be called when the shortcut key is pressed to focus the widget.
  final Function onFocus;

  /// A function to be called when the shortcut key triggers a submission.
  final Function onSubmit;

  /// Determines whether the [onSubmit] function should be called.
  ///
  /// If true, [onSubmit] is triggered along with [onFocus].
  /// If false, only [onFocus] is triggered.
  final bool onPress;

  /// Creates a [ShortcutFocus] configuration.
  ///
  /// [key] specifies the keyboard key.
  /// [focusNode] provides focus control for the target widget.
  /// [onFocus] defines the action to focus on the widget.
  /// [onSubmit] defines the action to submit or perform on the widget.
  /// [onPress] controls whether [onSubmit] is triggered.
  ShortcutFocus({
    required this.onPress,
    required this.key,
    required this.focusNode,
    required this.onFocus,
    required this.onSubmit,
  });
}