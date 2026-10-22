import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../abstracts/t_jev_answer.dart';
import '../abstracts/t_jev_question.dart';
import '../constants/t_jev_http.dart';
import '../exceptions/t_jev_unasked_question_exception.dart';
import '../responses/t_jev_system_one_response_dto.dart';
import '../utils/response_json_object.dart';
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
      usage: dto.usage,
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
      final id = question.id == null ? '' : ' with id ${question.id}';
      throw TJevUnaskedQuestionException(
        reason: 'The Request did not ask this ${question.runtimeType}$id.',
      );
    }
    return answer as A;
  }

  /// The Answer of every Noul of the Request, in Request order.
  Map<TJevNoul, TJevNoulAnswer> get nouls => {
    for (final MapEntry(key: question, value: answer) in _answers.entries)
      if (question is TJevNoul) question: answer as TJevNoulAnswer,
  };

  /// The Answer of every Choice of the Request, in Request order.
  Map<TJevChoice, TJevChoiceAnswer> get choices => {
    for (final MapEntry(key: question, value: answer) in _answers.entries)
      if (question is TJevChoice) question: answer as TJevChoiceAnswer,
  };

  /// The Answer of every Score of the Request, in Request order.
  Map<TJevScore, TJevScoreAnswer> get scores => {
    for (final MapEntry(key: question, value: answer) in _answers.entries)
      if (question is TJevScore) question: answer as TJevScoreAnswer,
  };

  /// The Answer of every Box of the Request, in Request order.
  Map<TJevBox, TJevBoxAnswer> get boxes => {
    for (final MapEntry(key: question, value: answer) in _answers.entries)
      if (question is TJevBox) question: answer as TJevBoxAnswer,
  };

  /// Parses [json], the Answer TypeSafe sent under [id], to [question].
  static A _answerFromJson<A extends TJevAnswer>(
    TJevQuestion<A> question,
    String id,
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      throw FormatException('answers.$id: TypeSafe sent no Answer.');
    }
    try {
      return question.answerFromJson(json);
    } on CheckedFromJsonException catch (error) {
      throw FormatException('answers.$id.${error.key}: ${error.message}');
    } on FormatException catch (error) {
      throw FormatException('answers.$id.${error.message}');
    }
  }
}
