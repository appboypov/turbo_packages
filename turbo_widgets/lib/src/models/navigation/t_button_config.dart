import 'package:flutter/widgets.dart';

/// Configuration for a navigation button.
///
/// Used by [TBottomNavigation], [TTopNavigation], and [TSideNavigation]
/// to define button appearance and behavior.
class TButtonConfig {
  /// Creates a button configuration.
  ///
  /// [onPressed] is required. [icon] and [label] are optional - at least one
  /// should be provided for the button to be meaningful.
  ///
  /// When [buttonBuilder] is null, the navigation component renders using
  /// default ShadButton styling. When provided, the builder receives
  /// [isSelected] to implement custom selection UI.
  const TButtonConfig({
    required this.onPressed,
    this.icon,
    this.label,
    this.buttonBuilder,
  });

  /// Callback invoked when the button is pressed.
  final VoidCallback onPressed;

  /// Optional icon to display on the button.
  final IconData? icon;

  /// Optional label text to display on the button.
  final String? label;

  /// Custom button builder for full control over button rendering.
  ///
  /// When provided, receives:
  /// - [icon]: The configured icon (may be null)
  /// - [label]: The configured label (may be null)
  /// - [onPressed]: The configured callback
  /// - [isSelected]: Whether this button is currently selected
  ///
  /// When null, the navigation component uses default ShadButton rendering.
  final Widget Function(
    IconData? icon,
    String? label,
    VoidCallback onPressed,
    bool isSelected,
  )? buttonBuilder;

  /// Creates a copy with updated values.
  TButtonConfig copyWith({
    VoidCallback? onPressed,
    IconData? icon,
    String? label,
    Widget Function(
      IconData? icon,
      String? label,
      VoidCallback onPressed,
      bool isSelected,
    )? buttonBuilder,
  }) {
    return TButtonConfig(
      onPressed: onPressed ?? this.onPressed,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      buttonBuilder: buttonBuilder ?? this.buttonBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TButtonConfig &&
          runtimeType == other.runtimeType &&
          onPressed == other.onPressed &&
          icon == other.icon &&
          label == other.label &&
          buttonBuilder == other.buttonBuilder;

  @override
  int get hashCode => Object.hash(onPressed, icon, label, buttonBuilder);
}
