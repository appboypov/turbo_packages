import 'dart:convert';

import 'package:meta/meta.dart';

import '../constants/t_jev_http.dart';
import '../constants/t_jev_limits.dart';
import '../constants/t_jev_messages.dart';
import '../exceptions/t_jev_invalid_question_exception.dart';
import '../models/t_jev_image.dart';
import '../requests/t_jev_box_question_dto.dart';
import '../requests/t_jev_choice_question_dto.dart';
import '../requests/t_jev_noul_criteria_dto.dart';
import '../requests/t_jev_noul_question_dto.dart';
import '../requests/t_jev_score_question_dto.dart';
import '../responses/t_jev_box_answer_dto.dart';
import '../responses/t_jev_choice_answer_dto.dart';
import '../responses/t_jev_noul_answer_dto.dart';
import '../responses/t_jev_score_answer_dto.dart';
import 't_jev_answer.dart';
import 't_jev_question_dto.dart';

part '../models/t_jev_box.dart';
part '../models/t_jev_choice.dart';
part '../models/t_jev_noul.dart';
part '../models/t_jev_score.dart';

/// One typed judgment about the State, typed on its Answer [A].
///
/// A Question object is the key of its own Answer:
/// [TJevResult.answer] returns an [A] for it.
///
/// Instructions and descriptions are content: strings, numbers, booleans,
/// Images, maps with string keys, lists and objects with `toJson`.
sealed class TJevQuestion<A extends TJevAnswer> {
  const TJevQuestion({this.id});

  /// The id that keys this Question in its Request.
  ///
  /// Questions without an id get `q0`, `q1` and so on in Request order. Jev
  /// does not read ids, so an id only makes logged JSON easier to read.
  final String? id;

  /// The wire form of this Question, which [id] keys in its Request.
  ///
  /// Throws [TJevInvalidQuestionException] when this Question is invalid.
  @internal
  TJevQuestionDto toDto({required String id});

  /// Parses the wire form of the Answer to this Question.
  ///
  /// Throws a [FormatException] whose message starts with the path of the
  /// field when the Answer does not fit this Question.
  @internal
  A answerFromJson(Map<String, dynamic> json);

  /// The key of [value] on the wire: the name of an enum value, else its
  /// `toString`.
  static String _wireKey(Object value) =>
      value is Enum ? value.name : value.toString();

  /// Throws [TJevInvalidQuestionException] when [content] at [location] is
  /// not JSON content or holds a non-finite number.
  @internal
  static void checkContent(Object? content, String location) {
    switch (content) {
      case null || String() || bool() || TJevImage():
        return;
      case num() when !content.isFinite:
        throw TJevInvalidQuestionException(
          reason: TJevMessages.nonFiniteNumber(location, content),
        );
      case num():
        return;
      case List():
        for (final item in content) {
          checkContent(item, location);
        }
      case Map():
        for (final MapEntry(:key, :value) in content.entries) {
          if (key is! String) {
            throw TJevInvalidQuestionException(
              reason: TJevMessages.nonStringMapKey(location, key),
            );
          }
          checkContent(value, location);
        }
      default:
        try {
          jsonEncode(content);
        } on JsonUnsupportedObjectError {
          throw TJevInvalidQuestionException(
            reason: TJevMessages.unencodableContent(
              location,
              content.runtimeType,
            ),
          );
        }
    }
  }

  /// Throws a [FormatException] when an Answer of type [actual] answers a
  /// Question of type [expected].
  static void _checkAnswerType(String actual, String expected) {
    if (actual != expected) {
      throw FormatException(TJevMessages.answerTypeMismatch(actual, expected));
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
