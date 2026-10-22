import '../enums/t_jev_question_type.dart';

/// The wire form of one Question in a System One Request.
abstract interface class TJevQuestionDto {
  // 🧲 FETCHERS

  /// The type of the Question.
  TJevQuestionType get type;

  Map<String, dynamic> toJson();
}
