import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../abstracts/t_jev_answer.dart';
import '../abstracts/t_jev_exception.dart';
import '../abstracts/t_jev_question.dart';
import '../constants/t_jev_messages.dart';
import '../responses/t_jev_box_answer_dto.dart';
import '../responses/t_jev_choice_answer_dto.dart';
import '../responses/t_jev_noul_answer_dto.dart';
import '../responses/t_jev_score_answer_dto.dart';
import '../responses/t_jev_system_one_response_dto.dart';
import '../types/t_jev_model.dart';
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

  /// The Result of [dto], the System One response to the Questions keyed by
  /// their ids, received as [httpResponse] for the Request TypeSafe gave the
  /// id [requestId].
  ///
  /// Throws a [FormatException] when an Answer is missing or does not fit
  /// its Question.
  @internal
  factory TJevResult.fromDto(
    TJevSystemOneResponseDto dto, {
    required Map<String, TJevQuestion> questions,
    required String? requestId,
    required http.Response httpResponse,
  }) => TJevResult(
    model: dto.model,
    usage: TJevUsage.fromDto(dto.usage),
    requestId: requestId,
    httpResponse: httpResponse,
    answers: {
      for (final MapEntry(key: id, value: question) in questions.entries)
        question: _answerOf(question, id, dto.answers[id]),
    },
  );

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
        message: TJevMessages.unaskedQuestion(
          question.runtimeType,
          question.id,
        ),
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

  /// The Answer to [question] from [json], the wire form of the Answer
  /// TypeSafe sent under [id].
  ///
  /// Throws a [FormatException] whose message starts with the path of the
  /// Answer when [json] is missing or does not fit [question].
  static TJevAnswer _answerOf(
    TJevQuestion question,
    String id,
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      throw FormatException(TJevMessages.missingAnswer(id));
    }
    TJevChoiceAnswer<O> choiceAnswer<O extends Object>(TJevChoice<O> choice) =>
        TJevChoiceAnswer.fromDto(
          TJevChoiceAnswerDto.fromJson(json),
          options: {
            for (final option in choice.options.keys)
              TJevQuestion.wireKey(option): option,
          },
        );
    TJevScoreAnswer<L> scoreAnswer<L extends Object>(TJevScore<L> score) =>
        TJevScoreAnswer.fromDto(
          TJevScoreAnswerDto.fromJson(json),
          levels: score.levels.keys.toList(),
        );
    try {
      return switch (question) {
        TJevNoul() => TJevNoulAnswer.fromDto(TJevNoulAnswerDto.fromJson(json)),
        TJevChoice() => question.withOptionType<TJevAnswer>(choiceAnswer),
        TJevScore() => question.withLevelType<TJevAnswer>(scoreAnswer),
        TJevBox() => TJevBoxAnswer.fromDto(TJevBoxAnswerDto.fromJson(json)),
      };
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
