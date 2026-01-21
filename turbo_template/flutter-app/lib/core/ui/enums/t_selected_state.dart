import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';

enum SelectedState {
  deselected,
  selected,
  excluded;

  SelectedState get next {
    switch (this) {
      case deselected:
        return selected;
      case selected:
        return deselected;
      case excluded:
        return selected;
    }
  }

  bool get isSelected => this == selected;
  bool get isExcluded => this == excluded;
  bool get isDeselected => this == deselected;

  Color color({required BuildContext context}) {
    switch (this) {
      case deselected:
        return Colors.transparent;
      case selected:
        return context.colors.background.onColor.butWhenLightMode(
          context,
          (cValue) => context.colors.background,
        );
      case excluded:
        return context.colors.error;
    }
  }

  bool get isActive {
    switch (this) {
      case SelectedState.deselected:
        return false;
      case SelectedState.selected:
      case SelectedState.excluded:
        return true;
    }
  }

  SelectedState get nextWithSkipped {
    switch (this) {
      case deselected:
        return selected;
      case selected:
        return excluded;
      case excluded:
        return deselected;
    }
  }

  SelectedState get nextWithoutSkipped {
    switch (this) {
      case deselected:
        return selected;
      case selected:
        return deselected;
      case excluded:
        return deselected;
    }
  }
}
