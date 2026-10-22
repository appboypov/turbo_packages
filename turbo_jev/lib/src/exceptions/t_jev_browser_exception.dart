/// Thrown when [TJev] is built in a browser without
/// `dangerouslyAllowBrowser`.
///
/// A client in a browser shows its API key to anyone using the page.
final class TJevBrowserException implements Exception {
  const TJevBrowserException({required this.reason});

  /// Why the client refuses to run in the browser.
  final String reason;

  @override
  String toString() => 'TJevBrowserException{reason: $reason}';
}
