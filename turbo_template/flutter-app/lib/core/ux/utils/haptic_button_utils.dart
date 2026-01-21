import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ux/globals/g_vibrate.dart';

/// Utility functions for adding haptic feedback to button onPressed callbacks

/// Wraps a callback with light haptic feedback (for secondary actions)
VoidCallback? withLightHaptic(VoidCallback? onPressed) {
  if (onPressed == null) return null;
  return () {
    gVibrateLight();
    onPressed();
  };
}

/// Wraps a callback with medium haptic feedback (for primary actions)
VoidCallback? withMediumHaptic(VoidCallback? onPressed) {
  if (onPressed == null) return null;
  return () {
    gVibrateMedium();
    onPressed();
  };
}

/// Wraps a callback with selection haptic feedback (for navigation/selection)
VoidCallback? withSelectionHaptic(VoidCallback? onPressed) {
  if (onPressed == null) return null;
  return () {
    gVibrateSelection();
    onPressed();
  };
}

/// Wraps a callback with rigid haptic feedback (for destructive actions)
VoidCallback? withDestructiveHaptic(VoidCallback? onPressed) {
  if (onPressed == null) return null;
  return () {
    gVibrateRigid();
    onPressed();
  };
}

/// Wraps a callback with success haptic feedback (for confirmation actions)
VoidCallback? withSuccessHaptic(VoidCallback? onPressed) {
  if (onPressed == null) return null;
  return () {
    gVibrateSuccess();
    onPressed();
  };
}

/// Wraps a callback with error haptic feedback (for error states)
VoidCallback? withErrorHaptic(VoidCallback? onPressed) {
  if (onPressed == null) return null;
  return () {
    gVibrateError();
    onPressed();
  };
}
