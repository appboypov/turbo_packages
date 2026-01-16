extension TurboStringExtension on String {
  /// Returns null if the string is empty after trimming
  String? get turboNullIfEmpty => turboTrimIsEmpty ? null : this;

  /// Returns true if the string is empty after trimming
  bool get turboTrimIsEmpty => trim().isEmpty;

  /// Returns a normalized version (lowercase, no spaces)
  String get turboNaked => replaceAll(' ', '').toLowerCase().trim();

  /// Tries to parse as double, returns null if invalid
  double? get turboTryAsDouble => double.tryParse(this);

  /// Tries to parse as int, returns null if invalid
  int? get turboTryAsInt => int.tryParse(this);

  /// Capitalizes the first letter
  String get turboCapitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter, optionally forcing lowercase for the rest
  String turboCapitalize({bool forceLowercase = false}) {
    if (isEmpty) {
      return '';
    }
    return forceLowercase
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Returns a normalized version (single spaces, trimmed)
  String get turboNormalized => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Checks if string contains any of the provided values
  bool turboContainsAny(List<String> values) => values.any(contains);
}
