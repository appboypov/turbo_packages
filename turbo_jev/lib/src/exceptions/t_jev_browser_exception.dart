part of '../abstracts/t_jev_exception.dart';

/// Thrown when [TJev] is built in a browser without
/// `dangerouslyAllowBrowser`.
///
/// A client in a browser shows its API key to anyone using the page.
final class TJevBrowserException extends TJevException {
  const TJevBrowserException({required this.message});

  /// Why the client refuses to run in the browser.
  @override
  final String message;

  @override
  String toString() => 'TJevBrowserException{message: $message}';
}
