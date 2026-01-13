# 🔔 Turbo Notifiers

[![Pub Version](https://img.shields.io/pub/v/turbo_notifiers?logo=dart&label=turbo_notifiers)](https://pub.dev/packages/turbo_notifiers)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GitHub Stars](https://img.shields.io/github/stars/appboypov/turbo_notifiers?style=social)](https://github.com/appboypov/turbo_notifiers)

**Turbo Notifiers** is a simple package that improves the behaviour of Flutter's `ValueNotifier`. It provides enhanced reactive state management with additional capabilities like force updates and silent updates.

## Features

- **Enhanced ValueNotifier**: `TurboNotifier` extends `ValueNotifier` with additional capabilities
- **Force Update Mode**: Trigger rebuilds even when the value hasn't changed (useful for reference types)
- **Silent Updates**: Update state without triggering listeners

## Installation

Add `turbo_notifiers` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  turbo_notifiers: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic TurboNotifier

```dart
import 'package:turbo_notifiers/turbo_notifiers.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _counter = TurboNotifier<int>(0);

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _counter,
      builder: (context, value, child) {
        return Text('Count: $value');
      },
    );
  }
}
```

### Using Lists

```dart
final _items = TurboNotifier<List<String>>([]);

// Update the list
_items.update(['Item 1', 'Item 2']);

// Or update current list
_items.updateCurrent((current) => current..add('Item 3'));

// Listen to changes
ValueListenableBuilder<List<String>>(
  valueListenable: _items,
  builder: (context, items, child) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ListTile(title: Text(items[index])),
    );
  },
)
```

### Using Maps

```dart
final _data = TurboNotifier<Map<String, int>>({});

// Update the map
_data.update({'key1': 10, 'key2': 20});

// Or update current map
_data.updateCurrent((current) => current..['key3'] = 30);
```

## API Reference

### TurboNotifier<T>

Enhanced `ValueNotifier` with additional methods:

- `update(T value)`: Update the value and notify listeners
- `updateCurrent(T Function(T) current)`: Update using current value
- `silentUpdate(T value)`: Update the value without notifying listeners
- `silentUpdateCurrent(T Function(T) current)`: Update current value without notifying listeners
- `value` getter/setter: Standard ValueNotifier interface
- `data` getter/setter: Alias for value getter/setter

## Example

Check the `/example` directory for a complete Flutter application demonstrating Turbo Notifiers features.

## Contributing

Contributions are welcome! Please open issues or pull requests on our [GitHub repository](https://github.com/appboypov/turbo_notifiers).

## License

This package is licensed under the BSD 3-Clause License. See the [LICENSE](LICENSE) file for details.
