import 'dart:convert';

import '../constants/t_jev_logging.dart';

/// [bytes] with the value of each secret field in their JSON replaced in
/// full by [TJevLogging.redactedValue], at any depth.
///
/// A field is secret when its name, in any case, holds one of
/// [TJevLogging.secretBodyFieldNameParts]. [bytes] come back as they are
/// when they are no UTF-8 JSON or hold no secret field.
List<int> redactedJsonBody(List<int> bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return bytes;
  }
  var redactsAny = false;
  Object? redact(Object? value) {
    if (value is List<Object?>) return [for (final item in value) redact(item)];
    if (value is! Map<String, Object?>) return value;
    final redacted = <String, Object?>{};
    for (final MapEntry(:key, :value) in value.entries) {
      if (_isSecret(key)) {
        redactsAny = true;
        redacted[key] = TJevLogging.redactedValue;
      } else {
        redacted[key] = redact(value);
      }
    }
    return redacted;
  }

  final redacted = redact(json);
  return redactsAny ? utf8.encode(jsonEncode(redacted)) : bytes;
}

bool _isSecret(String name) {
  final lowercaseName = name.toLowerCase();
  return TJevLogging.secretBodyFieldNameParts.any(lowercaseName.contains);
}
