import 'package:http/http.dart' as http;

/// Parses the result of a Request from [json], the JSON object of its 2xx
/// [response].
///
/// Throws a [FormatException] or a `CheckedFromJsonException` when [json]
/// does not fit.
typedef TJevResponseParser<T> =
    T Function(Map<String, dynamic> json, http.Response response);
