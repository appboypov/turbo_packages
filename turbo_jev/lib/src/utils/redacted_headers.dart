import '../constants/t_jev_logging.dart';

/// [headers] with the value of each secret header replaced in full by
/// [TJevLogging.redactedValue].
///
/// A header is secret when its name, in any case, is one of
/// [TJevLogging.secretHeaders] or holds one of
/// [TJevLogging.secretHeaderNameParts].
Map<String, String> redactedHeaders(Map<String, String> headers) => {
  for (final MapEntry(key: name, value: value) in headers.entries)
    name: _isSecret(name) ? TJevLogging.redactedValue : value,
};

bool _isSecret(String name) {
  final lowercaseName = name.toLowerCase();
  return TJevLogging.secretHeaders.contains(lowercaseName) ||
      TJevLogging.secretHeaderNameParts.any(lowercaseName.contains);
}
