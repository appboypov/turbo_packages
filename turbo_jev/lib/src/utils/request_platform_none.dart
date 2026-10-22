import '../records/t_jev_encoded_body.dart';

/// The headers that name the SDK and runtime of a browser Request: none, as
/// browsers control the user agent.
Map<String, String> get platformHeaders => const {};

/// The body a browser sends for [bytes]: the bytes as they are.
TJevEncodedBody encodeBody(List<int> bytes) => (bytes: bytes, encoding: null);
