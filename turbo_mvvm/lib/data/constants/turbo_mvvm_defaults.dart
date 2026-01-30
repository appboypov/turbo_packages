/// Default values used throughout the turbo_mvvm package.
///
/// This class provides centralized default constants for various configuration
/// options used across the package, replacing the previous [TMvvmDurations] class.
abstract class TurboMvvmDefaults {
  /// Default value for [TViewModelBuilder.isReactive].
  static const isReactive = true;

  /// Default value for [TViewModelBuilder.shouldDispose].
  static const shouldDispose = true;

  /// Default value for [TBusyService.timeout].
  static const timeout = Duration(seconds: 20);

  /// Default value for [TBusyService.minBusy].
  static const minBusy = Duration.zero;

  /// Default animation duration used for fade transitions.
  static const animation = Duration(milliseconds: 225);

  /// Default minimum busy animation duration used by [TViewModelBuilder.minBusyDuration].
  static const minBusyAnimation = Duration(milliseconds: 450);
}
