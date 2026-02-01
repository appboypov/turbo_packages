import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/models/playground/t_select_option.dart';

/// Centralized model for all playground component parameters.
///
/// Contains maps of key-value pairs for each primitive type.
/// Form fields are auto-generated based on the entries in each map.
/// Components receive this model and extract their values by key.
class TPlaygroundParameterModel {
  const TPlaygroundParameterModel({
    this.strings = const {},
    this.textAreas = const {},
    this.ints = const {},
    this.doubles = const {},
    this.bools = const {},
    this.dateTimes = const {},
    this.dateRanges = const {},
    this.times = const {},
    this.selects = const {},
  });

  /// Creates an empty model with no parameters.
  const TPlaygroundParameterModel.empty()
      : strings = const {},
        textAreas = const {},
        ints = const {},
        doubles = const {},
        bools = const {},
        dateTimes = const {},
        dateRanges = const {},
        times = const {},
        selects = const {};

  /// String parameters displayed as single-line text inputs (ShadInput).
  final Map<String, String> strings;

  /// Multi-line string parameters displayed as text areas (ShadTextarea).
  final Map<String, String> textAreas;

  /// Integer parameters displayed as number inputs (ShadInput).
  final Map<String, int> ints;

  /// Double parameters displayed as sliders (ShadSlider).
  /// Use [TDoubleParam] wrapper if min/max/step configuration is needed.
  final Map<String, double> doubles;

  /// Boolean parameters displayed as switches (ShadSwitch).
  final Map<String, bool> bools;

  /// DateTime parameters displayed as date pickers (ShadDatePicker).
  final Map<String, DateTime> dateTimes;

  /// Date range parameters displayed as date range pickers (ShadDatePicker).
  final Map<String, ShadDateTimeRange> dateRanges;

  /// Time parameters displayed as time pickers (ShadTimePicker).
  final Map<String, ShadTimeOfDay> times;

  /// Select/enum parameters displayed as dropdowns (ShadSelect).
  final Map<String, TSelectOption<dynamic>> selects;

  /// Whether this model has any parameters.
  bool get isEmpty =>
      strings.isEmpty &&
      textAreas.isEmpty &&
      ints.isEmpty &&
      doubles.isEmpty &&
      bools.isEmpty &&
      dateTimes.isEmpty &&
      dateRanges.isEmpty &&
      times.isEmpty &&
      selects.isEmpty;

  /// Whether this model has at least one parameter.
  bool get isNotEmpty => !isEmpty;

  /// Total number of parameters across all types.
  int get length =>
      strings.length +
      textAreas.length +
      ints.length +
      doubles.length +
      bools.length +
      dateTimes.length +
      dateRanges.length +
      times.length +
      selects.length;

  /// Creates a copy with updated values.
  TPlaygroundParameterModel copyWith({
    Map<String, String>? strings,
    Map<String, String>? textAreas,
    Map<String, int>? ints,
    Map<String, double>? doubles,
    Map<String, bool>? bools,
    Map<String, DateTime>? dateTimes,
    Map<String, ShadDateTimeRange>? dateRanges,
    Map<String, ShadTimeOfDay>? times,
    Map<String, TSelectOption<dynamic>>? selects,
  }) {
    return TPlaygroundParameterModel(
      strings: strings ?? this.strings,
      textAreas: textAreas ?? this.textAreas,
      ints: ints ?? this.ints,
      doubles: doubles ?? this.doubles,
      bools: bools ?? this.bools,
      dateTimes: dateTimes ?? this.dateTimes,
      dateRanges: dateRanges ?? this.dateRanges,
      times: times ?? this.times,
      selects: selects ?? this.selects,
    );
  }

  /// Updates a single string value.
  TPlaygroundParameterModel updateString(String key, String value) {
    return copyWith(strings: {...strings, key: value});
  }

  /// Updates a single text area value.
  TPlaygroundParameterModel updateTextArea(String key, String value) {
    return copyWith(textAreas: {...textAreas, key: value});
  }

  /// Updates a single int value.
  TPlaygroundParameterModel updateInt(String key, int value) {
    return copyWith(ints: {...ints, key: value});
  }

  /// Updates a single double value.
  TPlaygroundParameterModel updateDouble(String key, double value) {
    return copyWith(doubles: {...doubles, key: value});
  }

  /// Updates a single bool value.
  TPlaygroundParameterModel updateBool(String key, bool value) {
    return copyWith(bools: {...bools, key: value});
  }

  /// Updates a single DateTime value.
  TPlaygroundParameterModel updateDateTime(String key, DateTime value) {
    return copyWith(dateTimes: {...dateTimes, key: value});
  }

  /// Updates a single date range value.
  TPlaygroundParameterModel updateDateRange(
    String key,
    ShadDateTimeRange value,
  ) {
    return copyWith(dateRanges: {...dateRanges, key: value});
  }

  /// Updates a single time value.
  TPlaygroundParameterModel updateTime(String key, ShadTimeOfDay value) {
    return copyWith(times: {...times, key: value});
  }

  /// Updates a single select value.
  TPlaygroundParameterModel updateSelect<T>(String key, T value) {
    final existing = selects[key];
    if (existing == null) return this;
    return copyWith(
      selects: {...selects, key: existing.copyWith(value: value)},
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPlaygroundParameterModel &&
          runtimeType == other.runtimeType &&
          _mapEquals(strings, other.strings) &&
          _mapEquals(textAreas, other.textAreas) &&
          _mapEquals(ints, other.ints) &&
          _mapEquals(doubles, other.doubles) &&
          _mapEquals(bools, other.bools) &&
          _mapEquals(dateTimes, other.dateTimes) &&
          _mapEquals(dateRanges, other.dateRanges) &&
          _mapEquals(times, other.times) &&
          _mapEquals(selects, other.selects);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(strings.entries),
        Object.hashAll(textAreas.entries),
        Object.hashAll(ints.entries),
        Object.hashAll(doubles.entries),
        Object.hashAll(bools.entries),
        Object.hashAll(dateTimes.entries),
        Object.hashAll(dateRanges.entries),
        Object.hashAll(times.entries),
        Object.hashAll(selects.entries),
      );

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
