/// Wrapper for select/enum options in playground parameters.
///
/// Holds both the current selected value and the list of available options.
class TSelectOption<T> {
  const TSelectOption({
    required this.value,
    required this.options,
    this.labelBuilder,
  });

  /// The currently selected value.
  final T value;

  /// All available options to choose from.
  final List<T> options;

  /// Custom label builder for displaying options.
  /// Defaults to [Enum.name] for enums or [toString] for other types.
  final String Function(T value)? labelBuilder;

  /// Gets the display label for a value.
  String getLabel(T val) {
    if (labelBuilder != null) return labelBuilder!(val);
    if (val is Enum) return val.name;
    return val.toString();
  }

  /// Creates a copy with updated value.
  TSelectOption<T> copyWith({T? value}) {
    return TSelectOption<T>(
      value: value ?? this.value,
      options: options,
      labelBuilder: labelBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TSelectOption<T> &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          _listEquals(options, other.options);

  @override
  int get hashCode => Object.hash(value, Object.hashAll(options));

  static bool _listEquals<E>(List<E> a, List<E> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
