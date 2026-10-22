import 'package:http/http.dart' as http;

/// Parses the result of a Request from its 2xx [response].
///
/// Throws a [FormatException] or a `CheckedFromJsonException` when the
/// body does not fit.
typedef TJevResponseParser<T> = T Function(http.Response response);
