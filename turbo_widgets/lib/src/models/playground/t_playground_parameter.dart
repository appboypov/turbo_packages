import 'package:flutter/foundation.dart';

/// Represents a single configurable playground parameter with reactive value source.
///
/// Uses [ValueListenable] and [ValueChanged] to integrate with any notifier type
/// (including TNotifier) without creating a dependency on specific implementations.
class TPlaygroundParameter<T> {
  /// Creates a playground parameter.
  ///
  /// - [id]: Unique identifier for this parameter.
  /// - [label]: Display label for the parameter.
  /// - [valueListenable]: Source of truth for the current value.
  /// - [onChanged]: Callback to write the new value back to the owner.
  /// - [description]: Optional helper text displayed below the control.
  /// - [enabled]: Whether the control is interactive.
  /// - [options]: When non-null, renders as a select/dropdown.
  /// - [optionLabel]: Custom label function for options.
  const TPlaygroundParameter({
    required this.id,
    required this.label,
    required this.valueListenable,
    required this.onChanged,
    this.description,
    this.enabled = true,
    this.options,
    this.optionLabel,
  });

  /// Unique identifier for this parameter.
  final String id;

  /// Display label for the parameter.
  final String label;

  /// Optional helper text displayed below the control.
  final String? description;

  /// Whether the control is interactive.
  final bool enabled;

  /// Source of truth for the current value.
  final ValueListenable<T> valueListenable;

  /// Callback to write the new value back to the owner.
  final ValueChanged<T> onChanged;

  /// When non-null, this parameter is rendered as a select/dropdown.
  final List<T>? options;

  /// Custom display label for each option.
  /// Defaults to [Enum.name] for enums or [toString] for other types.
  final String Function(T value)? optionLabel;

  /// Current value of the parameter.
  T get value => valueListenable.value;
}
