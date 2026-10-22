import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../abstracts/t_jev_answer.dart';
import '../abstracts/t_jev_question.dart';
import '../constants/t_jev_http.dart';
import '../constants/t_jev_messages.dart';
import '../exceptions/t_jev_unasked_question_exception.dart';
import '../responses/t_jev_system_one_response_dto.dart';
import '../types/t_jev_model.dart';
import '../utils/t_jev_response_json_object.dart';
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
  ///
  /// Throws a [FormatException] or a [CheckedFromJsonException] when the
  /// body is no System One response or an Answer is missing or does not fit
  /// its Question.
  @internal
  factory TJevResult.fromSystemOne({
    required Map<String, TJevQuestion> questions,
    required http.Response response,
  }) {
    final dto = TJevSystemOneResponseDto.fromJson(responseJsonObject(response));
    return TJevResult(
      model: TJevModel(dto.model),
      usage: TJevUsage(
        inputTokens: dto.usage.inputTokens,
        outputTokens: dto.usage.outputTokens,
      ),
      requestId: response.headers[TJevHttp.requestIdHeader],
      httpResponse: response,
      answers: {
        for (final MapEntry(key: id, value: question) in questions.entries)
          question: _answerFromJson(question, id, dto.answers[id]),
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
      throw TJevUnaskedQuestionException(
        reason: TJevMessages.unaskedQuestion(question.runtimeType, question.id),
      );
    }
    return answer as A;
  }

  /// The Answer of every Noul of the Request, in Request order.
  Map<TJevNoul, TJevNoulAnswer> get nouls => _answersOf();

  /// The Answer of every Choice of the Request, in Request order.
  Map<TJevChoice, TJevChoiceAnswer> get choices => _answersOf();

  /// The Answer of every Score of the Request, in Request order.
  Map<TJevScore, TJevScoreAnswer> get scores => _answersOf();

  /// The Answer of every Box of the Request, in Request order.
  Map<TJevBox, TJevBoxAnswer> get boxes => _answersOf();

  /// The Answer of every Question of type [Q] of the Request, in Request
  /// order.
  Map<Q, A> _answersOf<Q extends TJevQuestion<A>, A extends TJevAnswer>() => {
    for (final MapEntry(key: question, value: answer) in _answers.entries)
      if (question is Q) question: answer as A,
  };

  /// Parses [json], the Answer TypeSafe sent under [id], to [question].
  static A _answerFromJson<A extends TJevAnswer>(
    TJevQuestion<A> question,
    String id,
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      throw FormatException(TJevMessages.missingAnswer(id));
    }
    try {
      return question.answerFromJson(json);
    } on CheckedFromJsonException catch (error) {
      throw FormatException(
        TJevMessages.invalidAnswer(
          id,
          TJevMessages.fieldMessage(error.key, error.message),
        ),
      );
    } on FormatException catch (error) {
      throw FormatException(TJevMessages.invalidAnswer(id, error.message));
    }
  }
}
