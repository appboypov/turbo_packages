import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/models/t_contextual_buttons_config.dart';

/// Service interface for managing contextual buttons state.
///
/// Provides reactive state management through [ValueListenable] pattern,
/// allowing widgets to listen to configuration changes and update accordingly.
abstract class TContextualButtonsService extends ChangeNotifier
    implements ValueListenable<TContextualButtonsConfig> {
  /// Default singleton instance.
  static final TContextualButtonsService instance = TContextualButtonsServiceNotifier();

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
  /// When [animated] is true and [doNotifyListeners] is true:
  /// 1. Checks if the new config differs from current
  /// 2. Hides buttons by adding affected positions to hiddenPositions
  /// 3. Waits for hide animation to complete
  /// 4. Updates the configuration
  /// 5. Shows buttons by removing positions from hiddenPositions
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

/// Default concrete implementation of [TContextualButtonsService].
///
/// Uses [ChangeNotifier] for manual notification control and implements
/// [ValueListenable] for reactive state management.
final class TContextualButtonsServiceNotifier extends ChangeNotifier
    implements TContextualButtonsService {
  TContextualButtonsServiceNotifier([TContextualButtonsConfig? initialValue])
      : _value = initialValue ?? const TContextualButtonsConfig();

  TContextualButtonsConfig _value;

  @override
  TContextualButtonsConfig get value => _value;

  @override
  void update(
    TContextualButtonsConfig config, {
    bool doNotifyListeners = true,
  }) {
    if (_value == config) return;
    _value = config;
    if (doNotifyListeners) {
      notifyListeners();
    }
  }

  @override
  void updateWith(
    TContextualButtonsConfig Function(TContextualButtonsConfig current) updater, {
    bool doNotifyListeners = true,
  }) {
    final newConfig = updater(_value);
    update(newConfig, doNotifyListeners: doNotifyListeners);
  }

  @override
  Future<void> updateContextualButtons(
    TContextualButtonsConfig Function(TContextualButtonsConfig current) updater, {
    bool doNotifyListeners = true,
    bool animated = true,
    Set<TContextualPosition>? positionsToAnimate,
  }) async {
    final nextConfig = updater(_value);

    // Check if config actually changed
    if (_value == nextConfig) return;

    if (!animated || !doNotifyListeners) {
      // Direct update without animation
      update(nextConfig, doNotifyListeners: doNotifyListeners);
      return;
    }

    // Animated update flow: hide → wait → update → show
    final positionsToAnimateSet = positionsToAnimate ?? TContextualPosition.values.toSet();

    // Step 1: Hide buttons by adding positions to hiddenPositions
    final hiddenForAnimation = {..._value.hiddenPositions, ...positionsToAnimateSet};
    update(
      _value.copyWith(hiddenPositions: hiddenForAnimation),
      doNotifyListeners: doNotifyListeners,
    );

    // Step 2: Wait for hide animation (half duration for out phase)
    await Future.delayed(
      Duration(
        milliseconds: _value.animationDuration.inMilliseconds ~/ 2,
      ),
    );

    // Step 3: Update configuration
    final updatedConfig = nextConfig.copyWith(
      hiddenPositions: hiddenForAnimation,
    );
    update(updatedConfig, doNotifyListeners: doNotifyListeners);

    // Step 4: Show buttons by removing positions from hiddenPositions
    final finalHiddenPositions = {
      ...updatedConfig.hiddenPositions,
    }..removeAll(positionsToAnimateSet);

    update(
      updatedConfig.copyWith(hiddenPositions: finalHiddenPositions),
      doNotifyListeners: doNotifyListeners,
    );

    // Step 5: Wait for show animation (half duration for in phase)
    await Future.delayed(
      Duration(
        milliseconds: nextConfig.animationDuration.inMilliseconds ~/ 2,
      ),
    );
  }

  @override
  void hideAllButtons({bool doNotifyListeners = true}) {
    updateWith(
      (config) => config.copyWith(
        hiddenPositions: TContextualPosition.values.toSet(),
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  @override
  void showAllButtons({bool doNotifyListeners = true}) {
    updateWith(
      (config) => config.copyWith(
        hiddenPositions: const {},
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  @override
  void hidePosition(
    TContextualPosition position, {
    bool doNotifyListeners = true,
  }) {
    updateWith(
      (config) => config.copyWith(
        hiddenPositions: {...config.hiddenPositions, position},
      ),
      doNotifyListeners: doNotifyListeners,
    );
  }

  @override
  void showPosition(
    TContextualPosition position, {
    bool doNotifyListeners = true,
  }) {
    updateWith(
      (config) {
        final newHidden = {...config.hiddenPositions}..remove(position);
        return config.copyWith(hiddenPositions: newHidden);
      },
      doNotifyListeners: doNotifyListeners,
    );
  }

  @override
  void reset({bool doNotifyListeners = true}) {
    update(
      const TContextualButtonsConfig(),
      doNotifyListeners: doNotifyListeners,
    );
  }
}
