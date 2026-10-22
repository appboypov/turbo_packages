import 'dart:convert';
import 'dart:typed_data';

import '../constants/t_jev_logging.dart';

/// [bytes] with the value of each secret field in the JSON at bytes [start]
/// up to [end] replaced in full by [TJevLogging.redactedValue], at any
/// depth. [end] defaults to the end of [bytes].
///
/// A field is secret when its name, in any case, holds one of
/// [TJevLogging.secretBodyFieldNameParts]. The bytes around the JSON stay
/// as they are. [bytes] come back as they are when the JSON is no UTF-8
/// JSON or holds no secret field.
List<int> redactedJsonBody(List<int> bytes, {int start = 0, int? end}) {
  final jsonEnd = end ?? bytes.length;
  final Object? json;
  try {
    json = jsonDecode(utf8.decoder.convert(bytes, start, jsonEnd));
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
  if (!redactsAny) return bytes;
  return (BytesBuilder(copy: false)
        ..add(bytes.sublist(0, start))
        ..add(utf8.encode(jsonEncode(redacted)))
        ..add(bytes.sublist(jsonEnd)))
      .takeBytes();
}

bool _isSecret(String name) {
  final lowercaseName = name.toLowerCase();
  return TJevLogging.secretBodyFieldNameParts.any(lowercaseName.contains);
}
