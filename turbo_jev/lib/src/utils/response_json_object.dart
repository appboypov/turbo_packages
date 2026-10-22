import 'dart:convert';

import 'package:http/http.dart' as http;

/// The body of [response] as a JSON object.
///
/// Throws a [FormatException] when the body is no UTF-8 JSON object.
Map<String, dynamic> responseJsonObject(http.Response response) {
  final body = jsonDecode(utf8.decode(response.bodyBytes));
  if (body is! Map<String, dynamic>) {
    throw const FormatException('The body is no JSON object.');
  }
  return body;
}
