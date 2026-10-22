import 'package:meta/meta.dart';

import '../requests/t_jev_noul_criteria_dto.dart';
import '../requests/t_jev_noul_question_dto.dart';
import 't_jev_answer.dart';
import 't_jev_question_dto.dart';

part '../models/t_jev_noul.dart';

/// One typed judgment about the State, typed on its Answer [A].
///
/// A Question object is the key of its own Answer:
/// [TJevResult.answer] returns an [A] for it.
sealed class TJevQuestion<A extends TJevAnswer> {
  const TJevQuestion({this.id});

  /// The id that keys this Question in its Request.
  ///
  /// Questions without an id get `q0`, `q1` and so on in Request order. Jev
  /// does not read ids, so an id only makes logged JSON easier to read.
  final String? id;

  /// The wire form of this Question.
  @internal
  TJevQuestionDto toDto();

  /// Parses the wire form of the Answer to this Question.
  @internal
  A answerFromJson(Map<String, dynamic> json);
}
