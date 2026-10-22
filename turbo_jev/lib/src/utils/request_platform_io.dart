import 'dart:ffi';
import 'dart:io';

import '../constants/t_jev_http.dart';
import '../constants/t_jev_sdk.dart';
import '../records/t_jev_encoded_body.dart';

/// The headers that name the SDK and the Dart runtime with its platform.
final Map<String, String> platformHeaders = Map.unmodifiable({
  TJevHttp.userAgentHeader: TJevSdk.id,
  TJevHttp.sdkHeader: TJevSdk.id,
  TJevHttp.runtimeHeader:
      'dart/${Platform.version.split(' ').first} '
      '(${Platform.operatingSystem}; ${Abi.current().toString().split('_').last})',
});

/// The body sent for [bytes]: gzip compressed from
/// [TJevHttp.minCompressedBodyBytes] bytes on, else the bytes as they are.
TJevEncodedBody encodeBody(List<int> bytes) =>
    bytes.length < TJevHttp.minCompressedBodyBytes
    ? (bytes: bytes, encoding: null)
    : (bytes: gzip.encode(bytes), encoding: TJevHttp.gzipEncoding);
