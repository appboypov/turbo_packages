extension TStringExtension on String {
  /// Returns null if the string is empty after trimming
  String? get nullIfEmpty => trimIsEmpty ? null : this;

  /// Returns true if the string is empty after trimming
  bool get trimIsEmpty => trim().isEmpty;

  /// Returns a normalized version (lowercase, no spaces)
  String get naked => replaceAll(' ', '').toLowerCase().trim();

  /// Tries to parse as double, returns null if invalid
  double? get tryAsDouble => double.tryParse(this);

  /// Tries to parse as int, returns null if invalid
  int? get tryAsInt => int.tryParse(this);

  /// Capitalizes the first letter
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter, optionally forcing lowercase for the rest
  String capitalize({bool forceLowercase = false}) {
    if (isEmpty) {
      return '';
    }
    return forceLowercase
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Returns a normalized version (single spaces, trimmed)
  String get normalized => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Checks if string contains any of the provided values
  bool containsAny(List<String> values) => values.any(contains);
}
