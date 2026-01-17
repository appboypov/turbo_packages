extension TStringExtension on String {
  /// Returns null if the string is empty after trimming
  String? get tNullIfEmpty => tTrimIsEmpty ? null : this;

  /// Returns true if the string is empty after trimming
  bool get tTrimIsEmpty => trim().isEmpty;

  /// Returns a normalized version (lowercase, no spaces)
  String get tNaked => replaceAll(' ', '').toLowerCase().trim();

  /// Tries to parse as double, returns null if invalid
  double? get tTryAsDouble => double.tryParse(this);

  /// Tries to parse as int, returns null if invalid
  int? get tTryAsInt => int.tryParse(this);

  /// Capitalizes the first letter
  String get tCapitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter, optionally forcing lowercase for the rest
  String tCapitalize({bool forceLowercase = false}) {
    if (isEmpty) {
      return '';
    }
    return forceLowercase
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Returns a normalized version (single spaces, trimmed)
  String get tNormalized => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Checks if string contains any of the provided values
  bool tContainsAny(List<String> values) => values.any(contains);
}
