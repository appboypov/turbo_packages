import '../records/t_jev_encoded_body.dart';

/// The headers that name the SDK and runtime of a browser Request: none, as
/// browsers control the user agent.
Map<String, String> get platformHeaders => const {};

/// The headers that number a retry of a browser Request: none, as CORS
/// lets no `X-TypeSafe-*` header through.
Map<String, String> retryHeaders(int retryCount) => const {};

/// The body a browser sends for [bytes]: the bytes as they are.
TJevEncodedBody encodeBody(List<int> bytes) => (bytes: bytes, encoding: null);
