import 'package:json_annotation/json_annotation.dart';

part '../models/t_jev_noul_answer.dart';
part 't_jev_answer.g.dart';

/// The typed result of one Question.
///
/// Each Question type has its own Answer type, which [TJevResult.answer]
/// returns for that Question.
sealed class TJevAnswer {
  const TJevAnswer();
}
