import 'dart:math' as math;

part '../models/t_jev_box_answer.dart';
part '../models/t_jev_choice_answer.dart';
part '../models/t_jev_noul_answer.dart';
part '../models/t_jev_score_answer.dart';

/// The typed result of one Question.
///
/// Each Question type has its own Answer type, which [TJevResult.answer]
/// returns for that Question.
sealed class TJevAnswer {
  const TJevAnswer();
}
