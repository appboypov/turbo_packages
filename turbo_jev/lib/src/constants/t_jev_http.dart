/// Paths and header names of the TypeSafe HTTP API.
abstract final class TJevHttp {
  /// The System One endpoint that answers Questions about State.
  static const systemOnePath = '/v1/systemone';

  /// The media type of JSON bodies.
  static const jsonMediaType = 'application/json';

  /// The response header that holds the request id.
  static const requestIdHeader = 'x-typesafe-request-id';
}
