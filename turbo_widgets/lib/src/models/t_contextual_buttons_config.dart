import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/enums/t_contextual_allow_filter.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/enums/t_contextual_variation.dart';

/// Compares two widget lists by identity (not equality).
bool _widgetListIdentical(List<Widget> a, List<Widget> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!identical(a[i], b[i])) return false;
  }
  return true;
}

/// Data configuration containing the widget content for a slot.
class TContextualButtonsSlotData {
  const TContextualButtonsSlotData({
    this.primary = const [],
    this.secondary = const [],
    this.tertiary = const [],
  });

  /// Primary content widgets for this position.
  final List<Widget> primary;

  /// Secondary content widgets for this position.
  final List<Widget> secondary;

  /// Tertiary content widgets for this position.
  final List<Widget> tertiary;

  /// Creates a copy with updated values.
  TContextualButtonsSlotData copyWith({
    List<Widget>? primary,
    List<Widget>? secondary,
    List<Widget>? tertiary,
  }) {
    return TContextualButtonsSlotData(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TContextualButtonsSlotData &&
          runtimeType == other.runtimeType &&
          _widgetListIdentical(primary, other.primary) &&
          _widgetListIdentical(secondary, other.secondary) &&
          _widgetListIdentical(tertiary, other.tertiary);

  @override
  int get hashCode => Object.hash(
        primary.length,
        secondary.length,
        tertiary.length,
      );
}

/// Presentation configuration for how content is displayed at a slot.
class TContextualButtonsSlotPresentation {
  const TContextualButtonsSlotPresentation({
    this.alignment = Alignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.builder,
  });

  /// Alignment for content at this position.
  final Alignment alignment;

  /// Main axis size for content at this position.
  final MainAxisSize mainAxisSize;

  /// Optional builder to wrap content with custom widgets (e.g., padding, margin).
  final Widget Function(List<Widget> children)? builder;

  /// Creates a copy with updated values.
  TContextualButtonsSlotPresentation copyWith({
    Alignment? alignment,
    MainAxisSize? mainAxisSize,
    Widget Function(List<Widget> children)? builder,
  }) {
    return TContextualButtonsSlotPresentation(
      alignment: alignment ?? this.alignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      builder: builder ?? this.builder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TContextualButtonsSlotPresentation &&
          runtimeType == other.runtimeType &&
          alignment == other.alignment &&
          mainAxisSize == other.mainAxisSize &&
          builder == other.builder;

  @override
  int get hashCode => Object.hash(
        alignment,
        mainAxisSize,
        builder,
      );
}

/// Configuration for a single position slot (top, bottom, left, or right).
///
/// Combines [TContextualButtonsSlotData] for content and
/// [TContextualButtonsSlotPresentation] for layout/styling.
class TContextualButtonsSlotConfig {
  const TContextualButtonsSlotConfig({
    this.primary = const [],
    this.secondary = const [],
    this.tertiary = const [],
    this.alignment = Alignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.builder,
  });

  /// Creates a slot config from separate data and presentation configs.
  factory TContextualButtonsSlotConfig.fromParts({
    TContextualButtonsSlotData data = const TContextualButtonsSlotData(),
    TContextualButtonsSlotPresentation presentation =
        const TContextualButtonsSlotPresentation(),
  }) {
    return TContextualButtonsSlotConfig(
      primary: data.primary,
      secondary: data.secondary,
      tertiary: data.tertiary,
      alignment: presentation.alignment,
      mainAxisSize: presentation.mainAxisSize,
      builder: presentation.builder,
    );
  }

  /// Primary content widgets for this position.
  final List<Widget> primary;

  /// Secondary content widgets for this position.
  final List<Widget> secondary;

  /// Tertiary content widgets for this position.
  final List<Widget> tertiary;

  /// Alignment for content at this position.
  final Alignment alignment;

  /// Main axis size for content at this position.
  final MainAxisSize mainAxisSize;

  /// Optional builder to wrap content with custom widgets (e.g., padding, margin).
  final Widget Function(List<Widget> children)? builder;

  /// Extracts the data portion of this config.
  TContextualButtonsSlotData get data => TContextualButtonsSlotData(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      );

  /// Extracts the presentation portion of this config.
  TContextualButtonsSlotPresentation get presentation =>
      TContextualButtonsSlotPresentation(
        alignment: alignment,
        mainAxisSize: mainAxisSize,
        builder: builder,
      );

  /// Creates a copy with updated values.
  TContextualButtonsSlotConfig copyWith({
    List<Widget>? primary,
    List<Widget>? secondary,
    List<Widget>? tertiary,
    Alignment? alignment,
    MainAxisSize? mainAxisSize,
    Widget Function(List<Widget> children)? builder,
  }) {
    return TContextualButtonsSlotConfig(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      alignment: alignment ?? this.alignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      builder: builder ?? this.builder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TContextualButtonsSlotConfig &&
          runtimeType == other.runtimeType &&
          _widgetListIdentical(primary, other.primary) &&
          _widgetListIdentical(secondary, other.secondary) &&
          _widgetListIdentical(tertiary, other.tertiary) &&
          alignment == other.alignment &&
          mainAxisSize == other.mainAxisSize &&
          builder == other.builder;

  @override
  int get hashCode => Object.hash(
        primary.length,
        secondary.length,
        tertiary.length,
        alignment,
        mainAxisSize,
        builder,
      );
}

/// Configuration model for contextual buttons widget.
///
/// Contains all parameters needed to configure the display of contextual
/// buttons at various positions (top, bottom, left, right).
class TContextualButtonsConfig {
  const TContextualButtonsConfig({
    this.top = const TContextualButtonsSlotConfig(),
    this.bottom = const TContextualButtonsSlotConfig(),
    this.left = const TContextualButtonsSlotConfig(),
    this.right = const TContextualButtonsSlotConfig(),
    this.activeVariations = const {
      TContextualVariation.primary,
      TContextualVariation.secondary,
      TContextualVariation.tertiary,
    },
    this.allowFilter = TContextualAllowFilter.all,
    this.positionOverrides = const {},
    this.hiddenPositions = const {},
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  /// Configuration for top position.
  final TContextualButtonsSlotConfig top;

  /// Configuration for bottom position.
  final TContextualButtonsSlotConfig bottom;

  /// Configuration for left position.
  final TContextualButtonsSlotConfig left;

  /// Configuration for right position.
  final TContextualButtonsSlotConfig right;

  /// Set of active variations to display.
  ///
  /// Only variations in this set will be rendered. If multiple variations
  /// are active for the same position, they are stacked according to the
  /// position's axis (vertical for top/bottom, horizontal for left/right).
  final Set<TContextualVariation> activeVariations;

  /// Filter to restrict which positions can display content.
  ///
  /// When set to [TContextualAllowFilter.all], all positions are allowed.
  /// When set to a specific position, only that position is allowed.
  final TContextualAllowFilter allowFilter;

  /// Overrides to move content from one position to another.
  ///
  /// Key is the source position, value is the target position.
  /// Content from the source position will be displayed at the target position.
  final Map<TContextualPosition, TContextualPosition> positionOverrides;

  /// Positions that should be hidden (content preserved but not displayed).
  final Set<TContextualPosition> hiddenPositions;

  /// Total duration for the animation (split 50/50 between out and in phases).
  final Duration animationDuration;

  /// Curve applied to both out and in animation phases.
  final Curve animationCurve;

  /// Creates a copy with updated values.
  TContextualButtonsConfig copyWith({
    TContextualButtonsSlotConfig? top,
    TContextualButtonsSlotConfig? bottom,
    TContextualButtonsSlotConfig? left,
    TContextualButtonsSlotConfig? right,
    Set<TContextualVariation>? activeVariations,
    TContextualAllowFilter? allowFilter,
    Map<TContextualPosition, TContextualPosition>? positionOverrides,
    Set<TContextualPosition>? hiddenPositions,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return TContextualButtonsConfig(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
      activeVariations: activeVariations ?? this.activeVariations,
      allowFilter: allowFilter ?? this.allowFilter,
      positionOverrides: positionOverrides ?? this.positionOverrides,
      hiddenPositions: hiddenPositions ?? this.hiddenPositions,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TContextualButtonsConfig &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          bottom == other.bottom &&
          left == other.left &&
          right == other.right &&
          _setEquals(activeVariations, other.activeVariations) &&
          allowFilter == other.allowFilter &&
          _mapEquals(positionOverrides, other.positionOverrides) &&
          _setEquals(hiddenPositions, other.hiddenPositions) &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;

  @override
  int get hashCode => Object.hash(
        top,
        bottom,
        left,
        right,
        Object.hashAll(activeVariations),
        allowFilter,
        Object.hashAll(positionOverrides.entries),
        Object.hashAll(hiddenPositions),
        animationDuration,
        animationCurve,
      );

  static bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final item in a) {
      if (!b.contains(item)) return false;
    }
    return true;
  }

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
