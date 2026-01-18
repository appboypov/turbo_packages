import 'package:flutter/material.dart';

sealed class TBackground {
  const TBackground();

  Color? get color => switch (this) {
    final TBackgroundColor bg => bg.color,
    TBackgroundGradient() => null,
  };

  List<Color>? get colors => switch (this) {
    TBackgroundColor() => null,
    final TBackgroundGradient bg => bg.colors,
  };
}

class TBackgroundColor extends TBackground {
  const TBackgroundColor({required this.color});

  @override
  final Color color;
}

class TBackgroundGradient extends TBackground {
  const TBackgroundGradient({required this.colors});

  @override
  final List<Color> colors;
}
