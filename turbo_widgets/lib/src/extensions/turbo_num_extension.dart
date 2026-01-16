extension TurboNumExtension on num {
  /// Returns true if the number has decimal places
  bool get turboHasDecimals => this % 1 != 0;

  /// Multiplies this number by another number
  T turboX<T extends num>(num other) => this * other as T;

  /// Returns a formatted string representation
  String turboToFormattedString() {
    if (this % 1 == 0) {
      return toInt().toString();
    } else {
      return toStringAsFixed(1);
    }
  }

  /// Returns the minimum of this and other
  T turboMinimum<T extends num>(T other) => this >= other ? this as T : other;

  /// Returns the maximum of this and other
  T turboMaximum<T extends num>(T other) => this <= other ? this as T : other;

  /// Multiplies this by other
  T turboMultiply<T extends num>(T other) => this * other as T;

  /// Returns the number of decimal places
  int get turboDecimals {
    final valueAsString = toString();
    final decimalIndex = valueAsString.indexOf('.');
    if (decimalIndex == -1) {
      return 0;
    }
    return valueAsString.length - decimalIndex - 1;
  }
}
