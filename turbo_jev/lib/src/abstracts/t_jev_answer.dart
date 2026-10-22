import 'dart:math' as math;

import 'package:meta/meta.dart';

import '../constants/t_jev_http.dart';
import '../constants/t_jev_messages.dart';
import '../enums/t_jev_question_type.dart';
import '../responses/t_jev_box_answer_dto.dart';
import '../responses/t_jev_choice_answer_dto.dart';
import '../responses/t_jev_noul_answer_dto.dart';
import '../responses/t_jev_score_answer_dto.dart';

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

  // 🏗️ HELPERS

  /// Throws a [FormatException] when an Answer of type [actual] answers a
  /// Question of type [expected].
  static void _checkType(TJevQuestionType actual, TJevQuestionType expected) {
    if (actual != expected) {
      throw FormatException(
        TJevMessages.answerTypeMismatch(actual.wireValue, expected.wireValue),
      );
    }
  }

  /// Throws a [FormatException] when the keys of the Answer's [field] are not
  /// exactly [expected].
  static void _checkKeys(
    String field,
    Iterable<String> actual,
    List<String> expected,
  ) {
    final keys = actual.toSet();
    if (keys.length != expected.length || !keys.containsAll(expected)) {
      throw FormatException(TJevMessages.unexpectedKeys(field, keys, expected));
    }
  }
}
