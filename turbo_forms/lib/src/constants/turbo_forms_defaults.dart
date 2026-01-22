import 'package:flutter/material.dart';

abstract final class TurboFormsDefaults {
  static const Duration animationDuration = Duration(milliseconds: 225);
  static const Duration animationDurationHalf = Duration(milliseconds: 113);
  static const num defaultIncrementAmount = 1;
  static const num defaultMaxValue = double.maxFinite;
  static const num defaultMinValue = 0;
  static const EdgeInsets defaultErrorPadding = EdgeInsets.only(
    bottom: 4,
    left: 8,
    top: 8,
  );
  static const double defaultDisabledOpacity = 0.3;
  static const Curve defaultFadeInCurve = Curves.easeInOut;
  static const Curve defaultFadeOutCurve = Curves.easeInOut;
  static const Curve defaultSizeCurve = Curves.easeInOut;
  static const Alignment defaultAlignment = Alignment.topCenter;
  static const Clip defaultClipBehavior = Clip.none;
}
