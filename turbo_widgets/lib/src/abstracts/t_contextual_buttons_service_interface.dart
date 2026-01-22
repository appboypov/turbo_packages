import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/models/t_contextual_buttons_config.dart';

/// Service interface for managing contextual buttons state.
///
/// Provides reactive state management through [ValueListenable] pattern,
/// allowing widgets to listen to configuration changes and update accordingly.
abstract class TContextualButtonsServiceInterface extends ChangeNotifier
    implements ValueListenable<TContextualButtonsConfig> {
  /// Current configuration value.
  @override
  TContextualButtonsConfig get value;

  /// Updates the configuration directly.
  ///
  /// If [doNotifyListeners] is true, listeners are notified of the change.
  /// If false, the value is updated silently without notifying listeners.
  void update(
    TContextualButtonsConfig config, {
    bool doNotifyListeners = true,
  });

  /// Updates the configuration using an updater function.
  ///
  /// If [doNotifyListeners] is true, listeners are notified of the change.
  /// If false, the value is updated silently without notifying listeners.
  void updateWith(
    TContextualButtonsConfig Function(TContextualButtonsConfig current) updater, {
    bool doNotifyListeners = true,
  });

  /// Updates the configuration with animated transitions.
  ///
  /// When [animated] is true, the implementation may coordinate any
  /// extra transition behavior in addition to the widget-level animations.
  ///
  /// [positionsToAnimate] specifies which positions to animate (defaults to all).
  Future<void> updateContextualButtons(
    TContextualButtonsConfig Function(TContextualButtonsConfig current) updater, {
    bool doNotifyListeners = true,
    bool animated = true,
    Set<TContextualPosition>? positionsToAnimate,
  });

  /// Hides all buttons by adding all positions to hiddenPositions.
  void hideAllButtons({bool doNotifyListeners = true});

  /// Shows all buttons by clearing hiddenPositions.
  void showAllButtons({bool doNotifyListeners = true});

  /// Hides a specific position by adding it to hiddenPositions.
  void hidePosition(
    TContextualPosition position, {
    bool doNotifyListeners = true,
  });

  /// Shows a specific position by removing it from hiddenPositions.
  void showPosition(
    TContextualPosition position, {
    bool doNotifyListeners = true,
  });

  /// Resets the configuration to empty (no buttons shown).
  void reset({bool doNotifyListeners = true});
}
