import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:turbo_widgets/src/abstracts/t_contextual_buttons_service_interface.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/models/t_contextual_buttons_config.dart';

/// Service for managing contextual buttons state.
///
/// Extends [TContextualButtonsServiceInterface] and provides a singleton
/// instance for global access. Uses [ChangeNotifier] for manual notification
/// control and implements [ValueListenable] for reactive state management.
///
/// The singleton instance can be reset for testing via [resetInstance].
final class TContextualButtonsService
    extends TContextualButtonsServiceInterface {
  TContextualButtonsService([TContextualButtonsConfig? initialValue])
      : _value = initialValue ?? const TContextualButtonsConfig();

  static TContextualButtonsService? _instance;

  /// Singleton instance.
  ///
  /// Creates a new instance on first access. Use [resetInstance] to clear
  /// the singleton for testing or cleanup purposes.
  static TContextualButtonsService get instance {
    _instance ??= TContextualButtonsService();
    return _instance!;
  }

  /// Resets the singleton instance.
  ///
  /// Disposes the current instance and clears the reference, allowing
  /// a fresh instance to be created on next [instance] access.
  /// Use for testing or when the singleton needs to be completely reset.
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }

  TContextualButtonsConfig _value;
  bool _isDisposed = false;

  @override
  TContextualButtonsConfig get value => _value;

  @override
  void update(
    TContextualButtonsConfig config, {
    bool doNotifyListeners = true,
  }) {
    if (_isDisposed) return;
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
    if (_isDisposed) return;

    final nextConfig = updater(_value);
    if (_value == nextConfig) return;

    if (!animated || !doNotifyListeners) {
      update(nextConfig, doNotifyListeners: doNotifyListeners);
      return;
    }

    await _animateTransition(
      nextConfig: nextConfig,
      positionsToAnimate: positionsToAnimate,
    );
  }

  /// Orchestrates the animated transition between configurations.
  ///
  /// Separated from [updateContextualButtons] to maintain single responsibility.
  /// Flow: hide → wait → update → show (batched notifications)
  Future<void> _animateTransition({
    required TContextualButtonsConfig nextConfig,
    Set<TContextualPosition>? positionsToAnimate,
  }) async {
    if (_isDisposed) return;

    final positions = positionsToAnimate ?? TContextualPosition.values.toSet();

    // Step 1: Hide buttons
    final hiddenForAnimation = {..._value.hiddenPositions, ...positions};
    _value = _value.copyWith(hiddenPositions: hiddenForAnimation);
    notifyListeners();

    // Step 2: Wait for hide animation
    await Future.delayed(
      Duration(milliseconds: _value.animationDuration.inMilliseconds ~/ 2),
    );
    if (_isDisposed) return;

    // Step 3: Update configuration (silent)
    _value = nextConfig.copyWith(hiddenPositions: hiddenForAnimation);

    // Step 4: Show buttons
    final finalHiddenPositions = {..._value.hiddenPositions}..removeAll(positions);
    _value = _value.copyWith(hiddenPositions: finalHiddenPositions);
    notifyListeners();

    // Step 5: Wait for show animation
    await Future.delayed(
      Duration(milliseconds: nextConfig.animationDuration.inMilliseconds ~/ 2),
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

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
