import 'package:http_parser/http_parser.dart';

import '../constants/t_jev_http.dart';

/// The delay TypeSafe asks for in [headers], or `null` when it gave no valid
/// delay.
///
/// It is read from `retry-after-ms` first and from `Retry-After` second, in
/// seconds or as an HTTP date. [headers] have lowercase names.
Duration? retryAfterOf(Map<String, String> headers) {
  final milliseconds = _nonNegativeNumber(headers[TJevHttp.retryAfterMsHeader]);
  if (milliseconds != null) return _duration(milliseconds: milliseconds);

  final retryAfter = headers[TJevHttp.retryAfterHeader];
  if (retryAfter == null) return null;
  final seconds = _number(retryAfter);
  if (seconds != null) {
    return seconds < 0 ? null : _duration(milliseconds: seconds * 1000);
  }
  try {
    final delay = parseHttpDate(retryAfter).difference(DateTime.now());
    return delay.isNegative ? Duration.zero : delay;
  } on FormatException {
    return null;
  }
}

double? _nonNegativeNumber(String? text) {
  final number = text == null ? null : _number(text);
  return number != null && number >= 0 ? number : null;
}

/// [text] as a finite number; blank text counts as zero.
double? _number(String text) {
  final trimmed = text.trim();
  final number = trimmed.isEmpty ? 0.0 : double.tryParse(trimmed);
  return number != null && number.isFinite ? number : null;
}

Duration _duration({required double milliseconds}) =>
    Duration(microseconds: (milliseconds * 1000).round());
