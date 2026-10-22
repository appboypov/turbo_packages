import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../abstracts/t_jev_answer.dart';
import '../abstracts/t_jev_question.dart';
import '../constants/t_jev_http.dart';
import '../exceptions/t_jev_unasked_question_exception.dart';
import '../responses/t_jev_system_one_response_dto.dart';
import 't_jev_model.dart';
import 't_jev_usage.dart';

/// The Answers of one Request, with the model that answered and its Usage.
///
/// ```dart
/// final billingAnswer = result.answer(billing);
/// print(billingAnswer.probability);
/// ```
final class TJevResult {
  const TJevResult({
    required this.model,
    required this.usage,
    required this.requestId,
    required this.httpResponse,
    required Map<TJevQuestion, TJevAnswer> answers,
  }) : _answers = answers;

  /// Parses a System One response to the Questions keyed by their ids.
  @internal
  factory TJevResult.fromSystemOne({
    required Map<String, TJevQuestion> questions,
    required http.Response response,
  }) {
    final dto = TJevSystemOneResponseDto.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
    return TJevResult(
      model: TJevModel(dto.model),
      usage: dto.usage,
      requestId: response.headers[TJevHttp.requestIdHeader],
      httpResponse: response,
      answers: {
        for (final MapEntry(key: id, value: question) in questions.entries)
          question: question.answerFromJson(dto.answers[id]!),
      },
    );
  }

  /// The resolved model, which may differ from the Model Alias asked for.
  final TJevModel model;

  /// The tokens TypeSafe counted for the Request.
  final TJevUsage usage;

  /// The id TypeSafe gave the Request, if it sent one.
  final String? requestId;

  /// The raw HTTP response.
  final http.Response httpResponse;

  final Map<TJevQuestion, TJevAnswer> _answers;

  /// The Answer to [question].
  ///
  /// Throws [TJevUnaskedQuestionException] when the Request did not ask
  /// [question].
  A answer<A extends TJevAnswer>(TJevQuestion<A> question) {
    final answer = _answers[question];
    if (answer == null) {
      final id = question.id == null ? '' : ' with id ${question.id}';
      throw TJevUnaskedQuestionException(
        reason: 'The Request did not ask this ${question.runtimeType}$id.',
      );
    }
    return answer as A;
  }
}
