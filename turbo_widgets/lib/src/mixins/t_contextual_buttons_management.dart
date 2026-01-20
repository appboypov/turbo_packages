import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
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
///     setTopPrimary([MyButton()]);
///   }
/// }
///
/// class MyCustomViewModel with TContextualButtonsManagement {
///   // Uses custom service instance
///   @override
///   TContextualButtonsService get contextualButtonsService => _myService;
///
///   final _myService = TContextualButtonsServiceNotifier();
/// }
/// ```
mixin TContextualButtonsManagement {
  /// The service instance to use for managing contextual buttons.
  ///
  /// Override this getter to provide a custom service instance.
  /// Defaults to the singleton [TContextualButtonsService.instance].
  TContextualButtonsService get contextualButtonsService =>
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
  /// See [TContextualButtonsService.updateContextualButtons] for details.
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

  // Convenience methods for setting content at specific positions

  /// Sets primary content for top position.
  void setTopPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        top: config.top.copyWith(primary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for top position.
  void setTopSecondary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        top: config.top.copyWith(secondary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for top position.
  void setTopTertiary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        top: config.top.copyWith(tertiary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets primary content for bottom position.
  void setBottomPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        bottom: config.bottom.copyWith(primary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for bottom position.
  void setBottomSecondary(
    List<Widget> widgets, {
    bool doNotifyListeners = true,
  }) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        bottom: config.bottom.copyWith(secondary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for bottom position.
  void setBottomTertiary(
    List<Widget> widgets, {
    bool doNotifyListeners = true,
  }) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        bottom: config.bottom.copyWith(tertiary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets primary content for left position.
  void setLeftPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        left: config.left.copyWith(primary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for left position.
  void setLeftSecondary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        left: config.left.copyWith(secondary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for left position.
  void setLeftTertiary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        left: config.left.copyWith(tertiary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets primary content for right position.
  void setRightPrimary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        right: config.right.copyWith(primary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets secondary content for right position.
  void setRightSecondary(
    List<Widget> widgets, {
    bool doNotifyListeners = true,
  }) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        right: config.right.copyWith(secondary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  /// Sets tertiary content for right position.
  void setRightTertiary(List<Widget> widgets, {bool doNotifyListeners = true}) {
    updateContextualButtonsConfig(
      (config) => config.copyWith(
        right: config.right.copyWith(tertiary: widgets),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }
}
