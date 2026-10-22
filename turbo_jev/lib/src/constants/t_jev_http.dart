/// Paths and header names of the TypeSafe HTTP API.
abstract final class TJevHttp {
  /// The System One endpoint that answers Questions about State.
  static const systemOnePath = '/v1/systemone';

  /// The endpoint that lists the models of the account.
  static const modelsPath = '/v1/models';

  /// The media type of JSON bodies.
  static const jsonMediaType = 'application/json';

  /// The content encoding of compressed bodies.
  static const gzipEncoding = 'gzip';

  /// The smallest body, in bytes, that is compressed where compression is
  /// available.
  static const minCompressedBodyBytes = 1024;

  /// The response header that holds the request id.
  static const requestIdHeader = 'x-typesafe-request-id';

  /// The response header that holds a retry delay in milliseconds.
  static const retryAfterMsHeader = 'retry-after-ms';

  /// The response header that holds a retry delay in seconds or as an HTTP
  /// date.
  static const retryAfterHeader = 'retry-after';

  /// The request header that carries the API key as bearer auth.
  static const authorizationHeader = 'Authorization';

  /// The request header that asks for a JSON response.
  static const acceptHeader = 'Accept';

  /// The request header that names the media type of the body.
  static const contentTypeHeader = 'Content-Type';

  /// The request header that names the compression of the body.
  static const contentEncodingHeader = 'Content-Encoding';

  /// The request header that names the client software.
  static const userAgentHeader = 'User-Agent';

  /// The request header that names the SDK and its version.
  static const sdkHeader = 'X-TypeSafe-SDK';

  /// The request header that names the runtime and its platform.
  static const runtimeHeader = 'X-TypeSafe-Runtime';

  /// The Danger Zone header that raises the context limits to 262k tokens.
  static const longContextHeader = 'TypeSafe-Danger-Zone-Long-Context';

  /// The lowercase names of the headers only the SDK sets.
  static const protectedHeaders = {
    'authorization',
    'accept',
    'content-type',
    'content-encoding',
    'user-agent',
    'x-typesafe-sdk',
    'x-typesafe-runtime',
  };
}
