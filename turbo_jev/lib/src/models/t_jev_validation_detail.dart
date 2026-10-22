/// One reason TypeSafe gave for finding the Request body invalid.
final class TJevValidationDetail {
  const TJevValidationDetail({required this.location, required this.message});

  /// Where in the Request the problem is, as TypeSafe names it, such as
  /// `['body', 'questions', 'q0', 'criteria']`.
  final List<Object?> location;

  /// What is wrong at [location].
  final String message;

  /// [location] without its `body` entries, joined with dots, such as
  /// `questions.q0.criteria`.
  String get path => location.where((entry) => entry != 'body').join('.');

  @override
  String toString() => path.isEmpty ? message : '$path: $message';
}
