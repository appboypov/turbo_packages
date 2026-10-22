part of 't_jev_failure.dart';

/// TypeSafe did not accept the API key (401).
final class TJevAuthenticationFailure extends TJevHttpFailure {
  const TJevAuthenticationFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
  });
}
