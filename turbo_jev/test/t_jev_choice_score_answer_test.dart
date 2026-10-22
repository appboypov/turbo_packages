@TestOn('vm')
library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/enums/severity.dart';
import 'support/enums/team.dart';
import 'support/fake_type_safe.dart';

const _department = TJevChoice<Team>(
  id: 'department',
  instructions: 'Which team should handle this?',
  options: {
    Team.returns: 'Exchanges, wrong or damaged items',
    Team.shipping: 'Delivery status, delays, lost packages',
    Team.billing: 'Charges, invoices, payment problems',
  },
);

const _severity = TJevScore<Severity>(
  id: 'bug_severity',
  instructions: 'How severe is the reported issue?',
  levels: {
    Severity.cosmetic: 'Cosmetic; no impact to functionality',
    Severity.degraded: 'Broken or degraded feature, but workaround exists',
    Severity.blocking: 'Blocking issue; no workaround exists',
  },
);

const _frustration = TJevScore.list(
  id: 'frustration',
  levels: [
    'Calm, just stating facts',
    'Frustrated but civil',
    'Very angry, strong language or threatening to leave',
  ],
);

const _billing = TJevNoul(id: 'billing', instructions: 'About billing?');

const _departmentAnswer = {
  'type': 'choice',
  'choice': 'returns',
  'confidence': 0.42,
  'probabilities': {'shipping': 0.04, 'billing': 0.35, 'returns': 0.61},
};

const _severityAnswer = {
  'type': 'score',
  'score': 1.43,
  'confidence': 0.35,
  'legend': {
    '0': 'Cosmetic; no impact to functionality',
    '1': 'Broken or degraded feature, but workaround exists',
    '2': 'Blocking issue; no workaround exists',
  },
  'probabilities': {'0': 0.0, '1': 0.57, '2': 0.43},
};

/// A 200 System One response holding [answers] keyed by Question id.
http.Response _answered(Map<String, Object?> answers) => http.Response(
  jsonEncode({
    'model': 'jev-1.13.0',
    'answers': answers,
    'usage': {'input_tokens': 328, 'output_tokens': 34},
  }),
  200,
  headers: {
    'content-type': 'application/json',
    'x-typesafe-request-id': 'req_answers',
  },
);

void main() {
  Future<TurboResponse<TJevResult>> ask(
    List<TJevQuestion> questions,
    http.Response response,
  ) {
    final typeSafe = FakeTypeSafe(respond: (_) => response);
    final jev = TJev(
      apiKey: 'ts_key',
      httpClient: typeSafe.client,
      environment: const {},
    );
    return jev.ask(state: 'Wrong size, charged twice.', questions: questions);
  }

  group('Given a Choice Answer', () {
    test(
      'When it is read, then it gives the chosen Option as its enum value, '
      'the Probability per Option in Option order and the Confidence',
      () async {
        final response = await ask(
          const [_department],
          _answered({'department': _departmentAnswer}),
        );

        final answer = response.result!.answer(_department);
        expect(answer.choice, Team.returns);
        expect(answer.probabilities, {
          Team.returns: 0.61,
          Team.shipping: 0.04,
          Team.billing: 0.35,
        });
        expect(answer.probabilities.keys, [
          Team.returns,
          Team.shipping,
          Team.billing,
        ]);
        expect(answer.confidence, 0.42);
      },
    );

    test(
      'When it is read, then the top Probability is p_max and the margin is '
      'p_max divided by p_second',
      () async {
        final response = await ask(
          const [_department],
          _answered({'department': _departmentAnswer}),
        );

        final answer = response.result!.answer(_department);
        expect(answer.topProbability, 0.61);
        expect(answer.margin, closeTo(1.742857, 1e-6));
      },
    );

    test(
      'When two Options tie at the top, then the margin is 1',
      () async {
        final response = await ask(
          const [_department],
          _answered({
            'department': {
              'type': 'choice',
              'choice': 'shipping',
              'confidence': 0.25,
              'probabilities': {
                'returns': 0.0,
                'shipping': 0.5,
                'billing': 0.5,
              },
            },
          }),
        );

        expect(response.result!.answer(_department).margin, 1);
      },
    );

    test(
      'When no other Option has any Probability, then the margin is infinite',
      () async {
        final response = await ask(
          const [_department],
          _answered({
            'department': {
              'type': 'choice',
              'choice': 'billing',
              'confidence': 1.0,
              'probabilities': {'returns': 0.0, 'shipping': 0.0, 'billing': 1},
            },
          }),
        );

        final answer = response.result!.answer(_department);
        expect(answer.choice, Team.billing);
        expect(answer.topProbability, 1);
        expect(answer.margin, double.infinity);
      },
    );

    test(
      'When the Options are runtime values, then the chosen Option is that '
      'value',
      () async {
        final candidates = {7: 'Ada', 12: 'Linus'};
        final hire = TJevChoice<int>(id: 'hire', options: candidates);

        final response = await ask(
          [hire],
          _answered({
            'hire': {
              'type': 'choice',
              'choice': '12',
              'confidence': 0.6,
              'probabilities': {'7': 0.2, '12': 0.8},
            },
          }),
        );

        final answer = response.result!.answer(hire);
        expect(answer.choice, 12);
        expect(answer.probabilities, {7: 0.2, 12: 0.8});
      },
    );
  });

  group('Given a Score Answer', () {
    test(
      'When it is read, then it gives the score, the Confidence, the '
      'Probability and legend per Level as its enum value',
      () async {
        final response = await ask(
          const [_severity],
          _answered({'bug_severity': _severityAnswer}),
        );

        final answer = response.result!.answer(_severity);
        expect(answer.score, 1.43);
        expect(answer.confidence, 0.35);
        expect(answer.probabilities, {
          Severity.cosmetic: 0.0,
          Severity.degraded: 0.57,
          Severity.blocking: 0.43,
        });
        expect(answer.legend, {
          Severity.cosmetic: 'Cosmetic; no impact to functionality',
          Severity.degraded:
              'Broken or degraded feature, but workaround exists',
          Severity.blocking: 'Blocking issue; no workaround exists',
        });
      },
    );

    test(
      'When it is read, then the normalized score is score / (levels - 1) '
      'and the most likely Level is the one with the highest Probability',
      () async {
        final response = await ask(
          const [_severity],
          _answered({'bug_severity': _severityAnswer}),
        );

        final answer = response.result!.answer(_severity);
        expect(answer.normalizedScore, closeTo(0.715, 1e-9));
        expect(answer.mostLikelyLevel, Severity.degraded);
      },
    );

    test(
      'When its Levels are a list of descriptions, then the most likely Level '
      'is its description',
      () async {
        final response = await ask(
          const [_frustration],
          _answered({
            'frustration': {
              'type': 'score',
              'score': 1.28,
              'confidence': 0.58,
              'legend': {
                '0': 'Calm, just stating facts',
                '1': 'Frustrated but civil',
                '2': 'Very angry, strong language or threatening to leave',
              },
              'probabilities': {'0': 0.0, '1': 0.72, '2': 0.28},
            },
          }),
        );

        final answer = response.result!.answer(_frustration);
        expect(answer.mostLikelyLevel, 'Frustrated but civil');
        expect(answer.normalizedScore, closeTo(0.64, 1e-9));
        expect(
          answer.probabilities['Very angry, strong language or '
              'threatening to leave'],
          0.28,
        );
      },
    );

    test(
      'When the top Level holds all Probability, then the normalized score is '
      '1',
      () async {
        const quality = TJevScore.list(
          id: 'report_quality',
          levels: [
            'No detail',
            'Names the feature',
            'Steps or environment',
            'Both',
          ],
        );

        final response = await ask(
          const [quality],
          _answered({
            'report_quality': {
              'type': 'score',
              'score': 3.0,
              'confidence': 1.0,
              'legend': {
                '0': 'No detail',
                '1': 'Names the feature',
                '2': 'Steps or environment',
                '3': 'Both',
              },
              'probabilities': {'0': 0.0, '1': 0.0, '2': 0.0, '3': 1.0},
            },
          }),
        );

        final answer = response.result!.answer(quality);
        expect(answer.normalizedScore, 1);
        expect(answer.mostLikelyLevel, 'Both');
      },
    );

    test(
      'When two Levels tie for the highest Probability, '
      'then the most likely Level is the lower one',
      () async {
        final response = await ask(
          const [_severity],
          _answered({
            'bug_severity': {
              ..._severityAnswer,
              'score': 1.0,
              'confidence': 0.25,
              'probabilities': {'0': 0.0, '1': 0.5, '2': 0.5},
            },
          }),
        );

        expect(
          response.result!.answer(_severity).mostLikelyLevel,
          Severity.degraded,
        );
      },
    );

    test(
      'When the Score has one Level, then the normalized score is 0',
      () async {
        const only = TJevScore.list(id: 'only', levels: ['The only Level']);

        final response = await ask(
          const [only],
          _answered({
            'only': {
              'type': 'score',
              'score': 0.0,
              'confidence': 1.0,
              'legend': {'0': 'The only Level'},
              'probabilities': {'0': 1.0},
            },
          }),
        );

        expect(response.result!.answer(only).normalizedScore, 0);
      },
    );
  });

  group('Given a Request with several Questions of each type', () {
    const refund = TJevNoul(id: 'refund', instructions: 'Wants a refund?');
    const priority = TJevChoice<String>(
      id: 'priority',
      options: {'low': null, 'high': null},
    );

    test(
      'When the grouped views are read, then each lists every Answer of its '
      'Question type in Request order',
      () async {
        final response = await ask(
          const [_billing, _department, _severity, refund, priority],
          _answered({
            'billing': {'type': 'noul', 'noul': 0.9},
            'department': _departmentAnswer,
            'bug_severity': _severityAnswer,
            'refund': {'type': 'noul', 'noul': 0.2},
            'priority': {
              'type': 'choice',
              'choice': 'high',
              'confidence': 0.4,
              'probabilities': {'low': 0.3, 'high': 0.7},
            },
          }),
        );

        final result = response.result!;
        expect(result.nouls.keys, [_billing, refund]);
        expect(
          [for (final answer in result.nouls.values) answer.probability],
          [0.9, 0.2],
        );
        expect(result.choices.keys, [_department, priority]);
        expect(
          [for (final answer in result.choices.values) answer.choice],
          [Team.returns, 'high'],
        );
        expect(result.scores.keys, [_severity]);
        expect(result.scores.values.single.score, 1.43);
      },
    );
  });

  group('Given a 2xx response that does not fit the Request', () {
    Future<void> expectValidationFailure(
      List<TJevQuestion> questions,
      http.Response response,
    ) async {
      final result = await ask(questions, response);

      expect(result.isFail, isTrue);
      final failure = result.error! as TJevResponseValidationFailure;
      expect(failure.status, response.statusCode);
      expect(failure.requestId, response.headers['x-typesafe-request-id']);
      expect(failure.reason, isNotEmpty);
    }

    test(
      'When an Answer has the type of another Question, '
      'then ask returns a response validation failure',
      () async {
        await expectValidationFailure(
          const [_department],
          _answered({
            'department': {'type': 'noul', 'noul': 0.9},
          }),
        );
        await expectValidationFailure(
          const [_billing],
          _answered({
            'billing': {'type': 'choice', 'noul': 0.9},
          }),
        );
      },
    );

    test(
      'When a Choice Answer chooses an unknown Option, '
      'then ask returns a response validation failure',
      () async {
        await expectValidationFailure(
          const [_department],
          _answered({
            'department': {..._departmentAnswer, 'choice': 'legal'},
          }),
        );
      },
    );

    test(
      'When the Probabilities of a Choice Answer miss or add an Option, '
      'then ask returns a response validation failure',
      () async {
        await expectValidationFailure(
          const [_department],
          _answered({
            'department': {
              ..._departmentAnswer,
              'probabilities': {'returns': 0.61, 'billing': 0.39},
            },
          }),
        );
        await expectValidationFailure(
          const [_department],
          _answered({
            'department': {
              ..._departmentAnswer,
              'probabilities': {
                'returns': 0.61,
                'shipping': 0.04,
                'billing': 0.3,
                'legal': 0.05,
              },
            },
          }),
        );
      },
    );

    test(
      'When the legend or Probabilities of a Score Answer do not fit its '
      'Levels, then ask returns a response validation failure',
      () async {
        await expectValidationFailure(
          const [_severity],
          _answered({
            'bug_severity': {
              ..._severityAnswer,
              'legend': {'0': 'Cosmetic', '1': 'Broken'},
            },
          }),
        );
        await expectValidationFailure(
          const [_severity],
          _answered({
            'bug_severity': {
              ..._severityAnswer,
              'probabilities': {'1': 0.57, '2': 0.43, '3': 0.0},
            },
          }),
        );
      },
    );

    test(
      'When an Answer field has the wrong type, '
      'then ask returns a response validation failure',
      () async {
        await expectValidationFailure(
          const [_severity],
          _answered({
            'bug_severity': {..._severityAnswer, 'confidence': 'high'},
          }),
        );
      },
    );

    test(
      'When an Answer is missing, '
      'then ask returns a response validation failure',
      () async {
        await expectValidationFailure(
          const [_billing, _department],
          _answered({
            'billing': {'type': 'noul', 'noul': 0.9},
          }),
        );
      },
    );

    test(
      'When the body is malformed, '
      'then ask returns a response validation failure holding the body',
      () async {
        final cases = [
          http.Response('not json', 200),
          http.Response('[1, 2]', 200),
          http.Response(
            jsonEncode({
              'answers': {
                'billing': {'type': 'noul', 'noul': 0.9},
              },
              'usage': {'input_tokens': 1, 'output_tokens': 1},
            }),
            200,
          ),
          http.Response(
            jsonEncode({
              'model': 'jev-1.13.0',
              'answers': {
                'billing': {'type': 'noul', 'noul': 0.9},
              },
              'usage': {'input_tokens': 'many', 'output_tokens': 1},
            }),
            200,
          ),
        ];
        for (final response in cases) {
          await expectValidationFailure(const [_billing], response);
        }

        final result = await ask(const [_billing], cases.first);
        expect(
          (result.error! as TJevResponseValidationFailure).body,
          'not json',
        );
      },
    );
  });
}
