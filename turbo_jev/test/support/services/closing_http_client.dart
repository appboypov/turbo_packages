import 'package:http/http.dart' as http;

/// An HTTP client that answers every Request with an empty 204 and records
/// whether it was closed.
class ClosingHttpClient extends http.BaseClient {
  bool isClosed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(const Stream.empty(), 204);

  @override
  void close() => isClosed = true;
}
