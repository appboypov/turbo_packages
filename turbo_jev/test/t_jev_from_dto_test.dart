import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:turbo_jev/src/enums/t_jev_question_type.dart';
import 'package:turbo_jev/src/responses/t_jev_box_answer_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_box_coordinates_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_choice_answer_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_model_card_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_noul_answer_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_score_answer_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_system_one_response_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_usage_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_validation_error_detail_dto.dart';
import 'package:turbo_jev/src/responses/t_jev_validation_error_dto.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/enums/severity.dart';
import 'support/enums/team.dart';

const _department = TJevChoice<Team>(
  id: 'department',
  options: {Team.returns: null, Team.shipping: null, Team.billing: null},
);

const _severity = TJevScore<Severity>(
  id: 'bug_severity',
  levels: {
    Severity.cosmetic: 'Cosmetic',
    Severity.degraded: 'Degraded',
    Severity.blocking: 'Blocking',
  },
);

const _billing = TJevNoul(id: 'billing', instructions: 'About billing?');

const _mug = TJevBox(id: 'mug', instructions: 'the mug in `photo`');

const _teamsByKey = {
  'returns': Team.returns,
  'shipping': Team.shipping,
  'billing': Team.billing,
};

const _departmentAnswer = TJevChoiceAnswerDto(
  type: TJevQuestionType.choice,
  choice: 'billing',
  confidence: 0.42,
  probabilities: {'shipping': 0.04, 'billing': 0.61, 'returns': 0.35},
);

const _severityAnswer = TJevScoreAnswerDto(
  type: TJevQuestionType.score,
  score: 1.43,
  confidence: 0.35,
  legend: {'0': 'Cosmetic', '1': 'Degraded', '2': 'Blocking'},
  probabilities: {'0': 0.0, '1': 0.57, '2': 0.43},
);

void main() {
  group('Given a model card DTO', () {
    test('When it becomes a model card, then it keeps every field', () {
      final card = TJevModelCard.fromDto(
        const TJevModelCardDto(
          name: TJevModel.jevLatest,
          description: 'The newest Jev',
          releaseDate: '2026-09-15',
        ),
      );

      expect(card.name, TJevModel.jevLatest);
      expect(card.description, 'The newest Jev');
      expect(card.releaseDate, '2026-09-15');
    });
  });

  group('Given a Usage DTO', () {
    test('When it becomes a Usage, then it keeps both token counts', () {
      final usage = TJevUsage.fromDto(
        const TJevUsageDto(inputTokens: 328, outputTokens: 34),
      );

      expect(usage.inputTokens, 328);
      expect(usage.outputTokens, 34);
    });

    test('When it has no token counts, then the Usage has none', () {
      final usage = TJevUsage.fromDto(const TJevUsageDto());

      expect(usage.inputTokens, isNull);
      expect(usage.outputTokens, isNull);
    });
  });

  group('Given a Noul Answer DTO', () {
    test('When it becomes a Noul Answer, then it keeps its Probability', () {
      final answer = TJevNoulAnswer.fromDto(
        const TJevNoulAnswerDto(type: TJevQuestionType.noul, noul: 0.9),
      );

      expect(answer.probability, 0.9);
    });

    test('When it is of another Question type, then it throws', () {
      expect(
        () => TJevNoulAnswer.fromDto(
          const TJevNoulAnswerDto(type: TJevQuestionType.box, noul: 0.9),
        ),
        throwsFormatException,
      );
    });
  });

  group('Given a Box Answer DTO', () {
    const coordinates = TJevBoxCoordinatesDto(
      top: 0.1,
      bottom: 0.6,
      left: 0.2,
      right: 0.7,
    );

    test(
      'When it becomes a Box Answer, then it keeps its edges and Confidence',
      () {
        final answer = TJevBoxAnswer.fromDto(
          const TJevBoxAnswerDto(
            type: TJevQuestionType.box,
            box: coordinates,
            confidence: 0.8,
          ),
        );

        expect(answer.top, 0.1);
        expect(answer.bottom, 0.6);
        expect(answer.left, 0.2);
        expect(answer.right, 0.7);
        expect(answer.confidence, 0.8);
      },
    );

    test('When it is of another Question type, then it throws', () {
      expect(
        () => TJevBoxAnswer.fromDto(
          const TJevBoxAnswerDto(
            type: TJevQuestionType.noul,
            box: coordinates,
            confidence: null,
          ),
        ),
        throwsFormatException,
      );
    });
  });

  group('Given a Choice Answer DTO', () {
    test(
      'When it becomes a Choice Answer, then the chosen Option and each '
      'Probability are Options, in Option order',
      () {
        final answer = TJevChoiceAnswer.fromDto(
          _departmentAnswer,
          options: _teamsByKey,
        );

        expect(answer, isA<TJevChoiceAnswer<Team>>());
        expect(answer.choice, Team.billing);
        expect(answer.confidence, 0.42);
        expect(answer.probabilities.keys, [
          Team.returns,
          Team.shipping,
          Team.billing,
        ]);
        expect(answer.probabilities.values, [0.35, 0.04, 0.61]);
      },
    );

    test('When it is of another Question type, then it throws', () {
      expect(
        () => TJevChoiceAnswer.fromDto(
          const TJevChoiceAnswerDto(
            type: TJevQuestionType.score,
            choice: 'billing',
            confidence: 0.42,
            probabilities: {'shipping': 0.04, 'billing': 0.61, 'returns': 0.35},
          ),
          options: _teamsByKey,
        ),
        throwsFormatException,
      );
    });

    test('When its Probabilities miss an Option, then it throws', () {
      expect(
        () => TJevChoiceAnswer.fromDto(
          const TJevChoiceAnswerDto(
            type: TJevQuestionType.choice,
            choice: 'billing',
            confidence: 0.42,
            probabilities: {'billing': 0.61, 'returns': 0.39},
          ),
          options: _teamsByKey,
        ),
        throwsFormatException,
      );
    });

    test('When it chooses no Option, then it throws', () {
      expect(
        () => TJevChoiceAnswer.fromDto(
          const TJevChoiceAnswerDto(
            type: TJevQuestionType.choice,
            choice: 'legal',
            confidence: 0.42,
            probabilities: {'shipping': 0.04, 'billing': 0.61, 'returns': 0.35},
          ),
          options: _teamsByKey,
        ),
        throwsFormatException,
      );
    });
  });

  group('Given a Score Answer DTO', () {
    test(
      'When it becomes a Score Answer, then each Probability and legend entry '
      'is a Level, in Level order',
      () {
        final answer = TJevScoreAnswer.fromDto(
          _severityAnswer,
          levels: Severity.values,
        );

        expect(answer, isA<TJevScoreAnswer<Severity>>());
        expect(answer.score, 1.43);
        expect(answer.confidence, 0.35);
        expect(answer.probabilities, {
          Severity.cosmetic: 0.0,
          Severity.degraded: 0.57,
          Severity.blocking: 0.43,
        });
        expect(answer.legend, {
          Severity.cosmetic: 'Cosmetic',
          Severity.degraded: 'Degraded',
          Severity.blocking: 'Blocking',
        });
      },
    );

    test('When it is of another Question type, then it throws', () {
      expect(
        () => TJevScoreAnswer.fromDto(
          const TJevScoreAnswerDto(
            type: TJevQuestionType.choice,
            score: 1.43,
            confidence: 0.35,
            legend: {'0': 'Cosmetic', '1': 'Degraded', '2': 'Blocking'},
            probabilities: {'0': 0.0, '1': 0.57, '2': 0.43},
          ),
          levels: Severity.values,
        ),
        throwsFormatException,
      );
    });

    test('When its legend misses a Level, then it throws', () {
      expect(
        () => TJevScoreAnswer.fromDto(
          const TJevScoreAnswerDto(
            type: TJevQuestionType.score,
            score: 1.43,
            confidence: 0.35,
            legend: {'0': 'Cosmetic', '1': 'Degraded'},
            probabilities: {'0': 0.0, '1': 0.57, '2': 0.43},
          ),
          levels: Severity.values,
        ),
        throwsFormatException,
      );
    });

    test('When its Probabilities miss a Level, then it throws', () {
      expect(
        () => TJevScoreAnswer.fromDto(
          const TJevScoreAnswerDto(
            type: TJevQuestionType.score,
            score: 1.43,
            confidence: 0.35,
            legend: {'0': 'Cosmetic', '1': 'Degraded', '2': 'Blocking'},
            probabilities: {'0': 0.43, '1': 0.57},
          ),
          levels: Severity.values,
        ),
        throwsFormatException,
      );
    });
  });

  group('Given a System One response DTO', () {
    final httpResponse = http.Response('{}', 200);

    TJevSystemOneResponseDto responseDto(
      Map<String, Map<String, dynamic>> answers,
    ) => TJevSystemOneResponseDto(
      model: TJevModel.jev1_13_0,
      answers: answers,
      usage: const TJevUsageDto(inputTokens: 328, outputTokens: 34),
    );

    test(
      'When it becomes a Result, then it holds the model, the Usage, the '
      'request id and the response',
      () {
        final result = TJevResult.fromDto(
          responseDto({
            'billing': {'type': 'noul', 'noul': 0.9},
          }),
          questions: const {'billing': _billing},
          requestId: 'req_abc',
          httpResponse: httpResponse,
        );

        expect(result.model, TJevModel.jev1_13_0);
        expect(result.usage.inputTokens, 328);
        expect(result.usage.outputTokens, 34);
        expect(result.requestId, 'req_abc');
        expect(result.httpResponse, same(httpResponse));
      },
    );

    test(
      'When it answers each Question type, then each Answer is typed on its '
      'Question',
      () {
        final result = TJevResult.fromDto(
          responseDto({
            'billing': {'type': 'noul', 'noul': 0.9},
            'department': {
              'type': 'choice',
              'choice': 'billing',
              'confidence': 0.42,
              'probabilities': {
                'shipping': 0.04,
                'billing': 0.61,
                'returns': 0.35,
              },
            },
            'bug_severity': {
              'type': 'score',
              'score': 1.43,
              'confidence': 0.35,
              'legend': {'0': 'Cosmetic', '1': 'Degraded', '2': 'Blocking'},
              'probabilities': {'0': 0.0, '1': 0.57, '2': 0.43},
            },
            'mug': {
              'type': 'box',
              'box': {'top': 0.1, 'bottom': 0.6, 'left': 0.2, 'right': 0.7},
              'confidence': null,
            },
          }),
          questions: const {
            'billing': _billing,
            'department': _department,
            'bug_severity': _severity,
            'mug': _mug,
          },
          requestId: null,
          httpResponse: httpResponse,
        );

        expect(result.answer(_billing).probability, 0.9);
        expect(result.answer(_department).choice, Team.billing);
        expect(result.answer(_severity).mostLikelyLevel, Severity.degraded);
        expect(result.answer(_mug).right, 0.7);
      },
    );

    test('When an Answer is missing, then it throws', () {
      expect(
        () => TJevResult.fromDto(
          responseDto({}),
          questions: const {'billing': _billing},
          requestId: null,
          httpResponse: httpResponse,
        ),
        throwsFormatException,
      );
    });

    test(
      'When an Answer is of another Question type, then it throws',
      () {
        expect(
          () => TJevResult.fromDto(
            responseDto({
              'billing': {'type': 'score', 'noul': 0.9},
            }),
            questions: const {'billing': _billing},
            requestId: null,
            httpResponse: httpResponse,
          ),
          throwsFormatException,
        );
      },
    );

    test('When an Answer lacks a field, then it throws', () {
      expect(
        () => TJevResult.fromDto(
          responseDto({
            'billing': {'type': 'noul'},
          }),
          questions: const {'billing': _billing},
          requestId: null,
          httpResponse: httpResponse,
        ),
        throwsFormatException,
      );
    });
  });

  group('Given a 422 body', () {
    test(
      'When it is read, then each entry with a message becomes a validation '
      'detail with its location',
      () {
        final dto = TJevValidationErrorDto.fromJson({
          'detail': [
            {
              'type': 'missing',
              'loc': ['body', 'questions', 'q0', 1],
              'msg': 'Field required',
            },
            {'msg': 'Too many Questions'},
            {
              'loc': ['body', 'model'],
            },
            'not an entry',
          ],
        });
        final details = dto.detail.map(TJevValidationDetail.fromDto).toList();

        expect(details.map((detail) => detail.location), [
          ['body', 'questions', 'q0', 1],
          isEmpty,
        ]);
        expect(details.map((detail) => detail.message), [
          'Field required',
          'Too many Questions',
        ]);
      },
    );

    test('When a detail DTO becomes a detail, then it keeps both fields', () {
      final detail = TJevValidationDetail.fromDto(
        const TJevValidationErrorDetailDto(
          loc: ['body', 'state'],
          msg: 'Input should be a string',
        ),
      );

      expect(detail.location, ['body', 'state']);
      expect(detail.message, 'Input should be a string');
      expect(detail.path, 'state');
    });
  });
}
