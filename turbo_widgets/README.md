# 🎨 Turbo Widgets

[![Pub Version](https://img.shields.io/pub/v/turbo_widgets?logo=dart&label=turbo_widgets)](https://pub.dev/packages/turbo_widgets)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GitHub Stars](https://img.shields.io/github/stars/appboypov/turbo_packages?style=social)](https://github.com/appboypov/turbo_packages)

**Turbo Widgets** is a collection of common reusable UI widgets, extensions, and animation utilities for Flutter applications. It provides convenient widgets and extensions to speed up Flutter development.

## Features

- **Convenient Widgets**: Pre-built widgets like `TRow`, `TColumn`, `TPadding`, `TMargin`, `TDivider`, and more
- **Animation Utilities**: Widgets like `TAnimatedSize` and `TSlideShrink` for smooth animations
- **Extensions**: Helpful extensions for numbers, strings, durations, and more
- **Badge & Chip Widgets**: Ready-to-use badge and chip widgets for UI elements

## Installation

Add `turbo_widgets` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  turbo_widgets: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Widgets

```dart
import 'package:turbo_widgets/turbo_widgets.dart';

// Convenient padding
TPadding.app() // Standard app padding (16.0)
TPadding.button() // Button padding (16.0 horizontal, 0 vertical)
TPadding.card() // Card padding (12.0)

// Layout widgets
TRow(
  children: [
    // Your widgets
  ],
)

TColumn(
  children: [
    // Your widgets
  ],
)

// Divider
TDivider(
  height: 1.0,
  color: Colors.grey,
)
```

### Extensions

```dart
// Number extensions
5.0.scale(0.5) // Scale a number

// String extensions
'hello'.capitalize() // Capitalize first letter

// Duration extensions
Duration(seconds: 5).format() // Format duration
```

## Example

Check the `/example` directory for a complete Flutter application demonstrating Turbo Widgets features.

## Contributing

Contributions are welcome! Please open issues or pull requests on our [GitHub repository](https://github.com/appboypov/turbo_packages).

## License

This package is licensed under the BSD 3-Clause License. See the [LICENSE](LICENSE) file for details.
