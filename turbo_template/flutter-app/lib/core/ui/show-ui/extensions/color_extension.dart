import 'dart:math';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color get onColor {
    final HSLColor hsl = HSLColor.fromColor(this);
    final bool isLight =
        material.ThemeData.estimateBrightnessForColor(this) == material.Brightness.light;

    if (isLight) {
      return HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        min(0.4, hsl.saturation * 0.5),
        0.1,
      ).toColor();
    } else {
      return HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        min(0.2, hsl.saturation * 0.3),
        1,
      ).toColor();
    }
  }

  Color darken([final int amount = 5]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.black;
    final HSLColor hsl = HSLColor.fromColor(this);
    return hsl.withLightness(min(1, max(0, hsl.lightness - amount / 100))).toColor();
  }

  Color lighten([final int amount = 5]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.white;
    final HSLColor hsl = HSLColor.fromColor(this);
    return hsl.withLightness(min(1, max(0, hsl.lightness + amount / 100))).toColor();
  }

  Color get onHover {
    final bool isLight =
        material.ThemeData.estimateBrightnessForColor(this) == material.Brightness.light;

    if (isLight) {
      return darken(4);
    } else {
      return lighten(4);
    }
  }
}

