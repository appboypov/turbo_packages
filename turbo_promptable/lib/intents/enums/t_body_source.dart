/// Where the body of a reference is kept.
enum TBodySource {
  /// The body is the content itself.
  content,

  /// The body is an absolute file path.
  path,

  /// The body is an http or https URL.
  url,
}
