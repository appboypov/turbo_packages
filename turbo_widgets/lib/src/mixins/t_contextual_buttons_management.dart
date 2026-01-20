import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/abstracts/t_contextual_buttons_service_interface.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/enums/t_contextual_variation.dart';
import 'package:turbo_widgets/src/models/t_contextual_buttons_config.dart';
import 'package:turbo_widgets/src/services/t_contextual_buttons_service.dart';

/// Mixin that provides convenient methods for managing contextual buttons.
///
/// By default, uses the singleton [TContextualButtonsService.instance].
/// Override [contextualButtonsService] to use a custom service instance.
///
/// Example:
/// ```dart
/// class MyViewModel with TContextualButtonsManagement {
///   // Uses default singleton service
///   void showTopButton() {
///     setContent(TContextualPosition.top, TContextualVariation.primary, [MyButton()]);
///   }
/// }
///
/// class MyCustomViewModel with TContextualButtonsManagement {
///   // Uses custom service instance
///   @override
///   TContextualButtonsServiceInterface get contextualButtonsService => _myService;
///
///   final _myService = TContextualButtonsService();
/// }
/// ```
mixin TContextualButtonsManagement {
  /// The service instance to use for managing contextual buttons.
  ///
  /// Override this getter to provide a custom service instance.
  /// Defaults to the singleton [TContextualButtonsService.instance].
  TContextualButtonsServiceInterface get contextualButtonsService =>
      TContextualButtonsService.instance;

  /// Current configuration value from the service.
  TContextualButtonsConfig get contextualButtonsConfig =>
      contextualButtonsService.value;

  /// Updates the configuration directly.
  void setContextualButtonsConfig(
    TContextualButtonsConfig config, {
    bool doNotifyListeners = true,
  }) {
    contextualButtonsService.update(
      config,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Updates the configuration using an updater function.
  void updateContextualButtonsConfig(
    TContextualButtonsConfig Function(TContextualButtonsConfig current) updater, {
    bool doNotifyListeners = true,
  }) {
    contextualButtonsService.updateWith(
      updater,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Updates the configuration with animated transitions.
  ///
  /// See [TContextualButtonsServiceInterface.updateContextualButtons] for details.
  Future<void> updateContextualButtonsAnimated(
    TContextualButtonsConfig Function(TContextualButtonsConfig current) updater, {
    bool doNotifyListeners = true,
    bool animated = true,
    Set<TContextualPosition>? positionsToAnimate,
  }) {
    return contextualButtonsService.updateContextualButtons(
      updater,
      doNotifyListeners: doNotifyListeners,
      animated: animated,
      positionsToAnimate: positionsToAnimate,
    );
  }

  /// Hides all buttons.
  void hideAllButtons({bool doNotifyListeners = true}) {
    contextualButtonsService.hideAllButtons(doNotifyListeners: doNotifyListeners);
  }

  /// Shows all buttons.
  void showAllButtons({bool doNotifyListeners = true}) {
    contextualButtonsService.showAllButtons(doNotifyListeners: doNotifyListeners);
  }

  /// Hides a specific position.
  void hidePosition(
    TContextualPosition position, {
    bool doNotifyListeners = true,
  }) {
    contextualButtonsService.hidePosition(
      position,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Shows a specific position.
  void showPosition(
    TContextualPosition position, {
    bool doNotifyListeners = true,
  }) {
    contextualButtonsService.showPosition(
      position,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Resets the configuration to empty.
  void clearContextualButtons({bool doNotifyListeners = true}) {
    contextualButtonsService.reset(doNotifyListeners: doNotifyListeners);
  }

  /// Sets content for a specific position and variation.
  ///
  /// This is the unified method for setting content. The position-specific
  /// convenience methods (setTopPrimary, setBottomSecondary, etc.) delegate
  /// to this method.
  void setContent(
    TContextualPosition position,
    TContextualVariation variation,
    List<Widget> widgets, {
    bool doNotifyListeners = true,
  }) {
    updateContextualButtonsConfig(
      (config) {
        final slot = _getSlotForPosition(config, position);
        final updatedSlot = _updateSlotVariation(slot, variation, widgets);
        return _updateConfigWithSlot(config, position, updatedSlot);
      },
      doNotifyListeners: doNotifyListeners,
    );
  }

  TContextualButtonsSlotConfig _getSlotForPosition(
    TContextualButtonsConfig config,
    TContextualPosition position,
  ) {
    switch (position) {
      case TContextualPosition.top:
        return config.top;
      case TContextualPosition.bottom:
        return config.bottom;
      case TContextualPosition.left:
        return config.left;
      case TContextualPosition.right:
        return config.right;
    }
  }

  TContextualButtonsSlotConfig _updateSlotVariation(
    TContextualButtonsSlotConfig slot,
    TContextualVariation variation,
    List<Widget> widgets,
  ) {
    switch (variation) {
      case TContextualVariation.primary:
        return slot.copyWith(primary: widgets);
      case TContextualVariation.secondary:
        return slot.copyWith(secondary: widgets);
      case TContextualVariation.tertiary:
        return slot.copyWith(tertiary: widgets);
    }
  }

  TContextualButtonsConfig _updateConfigWithSlot(
    TContextualButtonsConfig config,
    TContextualPosition position,
    TContextualButtonsSlotConfig slot,
  ) {
    switch (position) {
      case TContextualPosition.top:
        return config.copyWith(top: slot);
      case TContextualPosition.bottom:
        return config.copyWith(bottom: slot);
      case TContextualPosition.left:
        return config.copyWith(left: slot);
      case TContextualPosition.right:
        return config.copyWith(right: slot);
    }
  }

  // Convenience methods for setting content at specific positions

  /// Sets primary content for top position.
  void setTopPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.top,
      TContextualVariation.primary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for top position.
  void setTopSecondary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.top,
      TContextualVariation.secondary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for top position.
  void setTopTertiary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.top,
      TContextualVariation.tertiary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets primary content for bottom position.
  void setBottomPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.bottom,
      TContextualVariation.primary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for bottom position.
  void setBottomSecondary(
    List<Widget> widgets, {
    bool doNotifyListeners = true,
  }) {
    setContent(
      TContextualPosition.bottom,
      TContextualVariation.secondary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for bottom position.
  void setBottomTertiary(
    List<Widget> widgets, {
    bool doNotifyListeners = true,
  }) {
    setContent(
      TContextualPosition.bottom,
      TContextualVariation.tertiary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets primary content for left position.
  void setLeftPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.left,
      TContextualVariation.primary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for left position.
  void setLeftSecondary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.left,
      TContextualVariation.secondary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for left position.
  void setLeftTertiary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.left,
      TContextualVariation.tertiary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets primary content for right position.
  void setRightPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.right,
      TContextualVariation.primary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for right position.
  void setRightSecondary(
    List<Widget> widgets, {
    bool doNotifyListeners = true,
  }) {
    setContent(
      TContextualPosition.right,
      TContextualVariation.secondary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for right position.
  void setRightTertiary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    setContent(
      TContextualPosition.right,
      TContextualVariation.tertiary,
      widgets,
      doNotifyListeners: doNotifyListeners,
    );
  }
}
