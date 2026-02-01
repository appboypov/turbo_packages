/// Numeric utilities for form field value handling.
extension TurboFormNumExtension on num {
  bool get tHasDecimals => this % 1 != 0;
}

/// String utilities for form field parsing and comparison.
extension TurboFormStringExtension on String {
  double? get tTryAsDouble => double.tryParse(this);
  int? get tTryAsInt => int.tryParse(this);
  String get tNaked => replaceAll(' ', '').toLowerCase().trim();
  bool get tTrimIsEmpty => trim().isEmpty;
}

/// Type casting utility for form field values.
extension TurboFormObjectExtension on Object {
  E tAsType<E extends Object>() => this as E;
}
