import 'dart:ffi';
import 'dart:io';

import '../constants/t_jev_http.dart';
import '../constants/t_jev_sdk.dart';
import '../records/t_jev_encoded_body.dart';

/// What a Request sends and how its errors look where `dart:io` exists.
final class TJevRequestPlatformService {
  const TJevRequestPlatformService();

  // 🛠 UTIL

  static final Map<String, String> _platformHeaders = Map.unmodifiable({
    TJevHttp.userAgentHeader: TJevSdk.id,
    TJevHttp.sdkHeader: TJevSdk.id,
    TJevHttp.runtimeHeader:
        'dart/${Platform.version.split(' ').first} '
        '(${Platform.operatingSystem}; '
        '${Abi.current().toString().split('_').last})',
  });

  // 🧲 FETCHERS

  /// The headers that name the SDK and the Dart runtime with its platform.
  Map<String, String> get platformHeaders => _platformHeaders;

  /// The headers that number retry [retryCount] of a Request.
  Map<String, String> retryHeaders(int retryCount) => {
    TJevHttp.retryCountHeader: '$retryCount',
  };

  /// The body sent for [bytes]: gzip compressed from
  /// [TJevHttp.minCompressedBodyBytes] bytes on, else the bytes as they are.
  TJevEncodedBody encodeBody(List<int> bytes) =>
      bytes.length < TJevHttp.minCompressedBodyBytes
      ? (bytes: bytes, encoding: null)
      : (bytes: gzip.encode(bytes), encoding: TJevHttp.gzipEncoding);

  /// Whether [error] is a connection error the HTTP client throws as it is:
  /// an [IOException] such as a [HandshakeException], which `IOClient` does
  /// not wrap in a `ClientException`.
  bool isUnwrappedConnectionError(Exception error) => error is IOException;
}
