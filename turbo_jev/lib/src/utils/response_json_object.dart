import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/t_jev_messages.dart';

/// The body of [response] as a JSON object.
///
/// Throws a [FormatException] when the body is no UTF-8 JSON object.
Map<String, dynamic> responseJsonObject(http.Response response) {
  final body = jsonDecode(utf8.decode(response.bodyBytes));
  if (body is! Map<String, dynamic>) {
    throw const FormatException(TJevMessages.noJsonObject);
  }
  return body;
}
