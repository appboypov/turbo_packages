/// One reason TypeSafe gave for finding the Request body invalid.
final class TJevValidationDetail {
  const TJevValidationDetail({required this.location, required this.message});

  /// Where in the Request the problem is, as TypeSafe names it, such as
  /// `['body', 'questions', 'q0', 'criteria']`.
  final List<Object?> location;

  /// What is wrong at [location].
  final String message;

  /// [location] without a leading `body` entry, joined with dots, such as
  /// `questions.q0.criteria`. A `body` further on, such as a Question id,
  /// stays: `['body', 'questions', 'body', 'options']` gives
  /// `questions.body.options`.
  String get path => switch (location) {
    ['body', ...final rest] => rest.join('.'),
    _ => location.join('.'),
  };

  @override
  String toString() => path.isEmpty ? message : '$path: $message';
}
