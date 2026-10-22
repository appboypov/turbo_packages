import 'package:meta/meta.dart';

import '../constants/t_jev_http.dart';
import '../constants/t_jev_messages.dart';
import '../responses/t_jev_validation_error_detail_dto.dart';

/// One reason TypeSafe gave for finding the Request body invalid.
final class TJevValidationDetail {
  const TJevValidationDetail({required this.location, required this.message});

  /// The detail of [dto].
  @internal
  factory TJevValidationDetail.fromDto(TJevValidationErrorDetailDto dto) =>
      TJevValidationDetail(location: dto.loc, message: dto.msg);

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
    [TJevHttp.bodyLocation, ...final rest] => TJevMessages.fieldPath(rest),
    _ => TJevMessages.fieldPath(location),
  };

  @override
  String toString() =>
      path.isEmpty ? message : TJevMessages.fieldMessage(path, message);
}
