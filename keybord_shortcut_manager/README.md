# Keyboard Shortcut Listener

A Flutter package that enables dynamic keyboard shortcut functionality with configurable actions and visibility control.

## Features

- Configure custom keyboard shortcuts for any widget
- Toggle shortcut visibility with left shift key
- Support for focus and submit actions
- Flexible and easy to integrate

## Installation

Add `keyboard_shortcut_listener` to your `pubspec.yaml`:

```yaml
dependencies:
  keyboard_shortcut_listener: ^0.1.0
```

## Usage

```dart
import 'package:keyboard_shortcut_listener/keyboard_shortcut_listener.dart';
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameNode = FocusNode();
  final _emailNode = FocusNode();
  final _submitKey = GlobalKey();

  final _shortcutKeysVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcutListener(
      shortcutKeysVisible: _shortcutKeysVisible,
      shortcuts: [
        ShortcutFocus(
          key: 'n',
          focusNode: _nameNode,
          onFocus: () => _nameNode.requestFocus(),
          onSubmit: () {},
          onPress: false,
        ),
        ShortcutFocus(
          key: 'e',
          focusNode: _emailNode,
          onFocus: () => _emailNode.requestFocus(),
          onSubmit: () {},
          onPress: false,
        ),
        ShortcutFocus(
          key: 's',
          focusNode: _submitKey,
          onFocus: () {
            // Optional: add custom submit logic
          },
          onSubmit: () {
            // Perform form submission
          },
          onPress: true,
        ),
      ],
      child: Form(
        // Your form implementation
      ),
    );
  }
}
```

## Parameters

### KeyboardShortcutListener
- `child`: The widget to wrap with keyboard shortcut functionality
- `shortcuts`: List of `ShortcutFocus` configurations
- `shortcutKeysVisible`: `ValueNotifier` to control shortcut visibility

### ShortcutFocus
- `key`: Keyboard key for the shortcut
- `focusNode`: Focus node for the target widget
- `onFocus`: Function to call when focusing the widget
- `onSubmit`: Function to call for submission
- `onPress`: Whether to trigger `onSubmit`

## License

MIT License