/// The id of a Jev model: a Model Alias, a versioned model or a custom id.
///
/// ```dart
/// final jev = TJev(defaultModel: TJevModel.jevPreview);
/// final pinned = TJevModel('jev-1.15.0');
/// ```
extension type const TJevModel(String id) {
  /// The Model Alias of the current Jev model, the default model.
  static const jevLatest = TJevModel('jev-latest');

  /// The Model Alias of the next Jev model.
  static const jevPreview = TJevModel('jev-preview');

  /// Jev 1.13.0.
  static const jev1_13_0 = TJevModel('jev-1.13.0');

  /// Jev 1.14.0.
  static const jev1_14_0 = TJevModel('jev-1.14.0');
}
