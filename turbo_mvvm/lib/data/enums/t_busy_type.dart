/// Enum for specifying different types of busy indicators.
///
/// Types include:
/// [indicator] Shows only the indicator.
/// [indicatorIgnorePointer] Shows the indicator and ignores touch events.
/// [indicatorBackdrop] Shows the indicator with a backdrop.
/// [indicatorBackdropIgnorePointer] Shows the indicator with a backdrop and ignores touch events.
enum TBusyType {
  /// Shows no indicator
  none,

  /// Shows only the indicator.
  indicator,

  /// Shows the indicator and ignores touch events.
  indicatorIgnorePointer,

  /// Shows the indicator with a backdrop.
  indicatorBackdrop,

  /// Shows the indicator with a backdrop and ignores touch events.
  indicatorBackdropIgnorePointer;

  /// Default value for `BusyType`.
  static const defaultValue = TBusyType.indicator;

  /// Checks if the current `BusyType` should ignore pointer events.
  ///
  /// Returns `true` for `indicatorIgnorePointer` and `indicatorBackdropIgnorePointer`,
  /// and `false` otherwise.
  bool get ignorePointer {
    switch (this) {
      case TBusyType.none:
      case TBusyType.indicator:
      case TBusyType.indicatorBackdrop:
        return false;
      case TBusyType.indicatorIgnorePointer:
      case TBusyType.indicatorBackdropIgnorePointer:
        return true;
    }
  }

  /// Checks if the current `BusyType` should show a backdrop.
  ///
  /// Returns `true` for `indicatorBackdrop` and `indicatorBackdropIgnorePointer`,
  /// and `false` otherwise.
  bool get showBackdrop {
    switch (this) {
      case TBusyType.none:
      case TBusyType.indicator:
      case TBusyType.indicatorIgnorePointer:
        return false;
      case TBusyType.indicatorBackdrop:
      case TBusyType.indicatorBackdropIgnorePointer:
        return true;
    }
  }
}
