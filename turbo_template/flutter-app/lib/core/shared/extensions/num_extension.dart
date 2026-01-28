import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';

extension NumExtension on num {
  bool get hasDecimals => this % 1 != 0;

  double asExtendRatio({
    required int buttonCount,
    required BuildContext context,
    double buttonSpacing = 16,
    double rightPadding = 16,
  }) {
    // Total width = screen width - any parent margins
    final totalWidth = context.maxWidth;

    // Width needed = buttonWidth + spacing + right margin (16)
    final neededWidth = (this * buttonCount) + (buttonCount * buttonSpacing);

    // Calculate ratio
    final ratio = neededWidth / totalWidth;

    return ratio;
  }

  T x<T extends num>(num other) => this * other as T;

  String toFormattedString() {
    if (this % 1 == 0) {
      // If the number is a whole number (e.g., 5.0), return it without decimal
      return toInt().toString();
    } else {
      // If it has a decimal part, limit to 1 decimal place
      return toStringAsFixed(1);
    }
  }

  T minimum<T extends num>(T other) => this >= other ? this as T : other;
  T maximum<T extends num>(T other) => this <= other ? this as T : other;
  T multiply<T extends num>(T other) => this * other as T;
  int get decimals {
    final valueAsString = toString();
    final decimalIndex = valueAsString.indexOf('.');
    if (decimalIndex == -1) {
      return 0;
    }
    return valueAsString.length - decimalIndex - 1;
  }
}
