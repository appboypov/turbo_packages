@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/enums/severity.dart';
import 'support/enums/team.dart';
import 'support/models/candidate.dart';
import 'support/services/fake_type_safe.dart';

void main() {
  late FakeTypeSafe typeSafe;
  late TJev jev;

  setUp(() {
    typeSafe = FakeTypeSafe();
    jev = TJev(
      apiKey: 'ts_test_key',
      httpClient: typeSafe.client,
      environment: const {},
    );
  });

  group('Given a Choice', () {
    test(
      'When its Options are enum values, '
      'then each Option goes on the wire under its name in map order',
      () async {
        const department = TJevChoice<Team>(
          id: 'department',
          instructions: 'Which team should handle this?',
          options: {
            Team.returns: 'Exchanges, wrong or damaged items',
            Team.shipping: 'Delivery status, delays, lost packages',
            Team.billing: 'Charges, invoices, payment problems',
          },
        );

        await jev.ask(state: 'Wrong size.', questions: [department]);

        final questions = typeSafe.lastBody['questions']! as Map;
        expect(questions, {
          'department': {
            'type': 'choice',
            'instructions': 'Which team should handle this?',
            'criteria': {
              'returns': 'Exchanges, wrong or damaged items',
              'shipping': 'Delivery status, delays, lost packages',
              'billing': 'Charges, invoices, payment problems',
            },
          },
        });
        expect(
          ((questions['department'] as Map)['criteria'] as Map).keys,
          ['returns', 'shipping', 'billing'],
        );
      },
    );

    test(
      'When its Options are runtime values, '
      'then each Option goes on the wire under its toString',
      () async {
        final candidates = [const Candidate(7), const Candidate(12)];
        final hire = TJevChoice<Candidate>(
          instructions: 'Who fits the role best?',
          options: {
            for (final candidate in candidates)
              candidate: {'cv': 'Candidate ${candidate.id}', 'years': 5},
          },
        );

        await jev.ask(state: 'A senior Dart role.', questions: [hire]);

        expect(typeSafe.lastBody['questions'], {
          'q0': {
            'type': 'choice',
            'instructions': 'Who fits the role best?',
            'criteria': {
              'candidate_7': {'cv': 'Candidate 7', 'years': 5},
              'candidate_12': {'cv': 'Candidate 12', 'years': 5},
            },
          },
        });
      },
    );

    test(
      'When an Option has no description and there are no Instructions, '
      'then the Option goes on the wire as null and Instructions are left out',
      () async {
        const tone = TJevChoice<String>(
          options: {'calm': null, 'angry': 'Shouting or threats'},
        );

        await jev.ask(state: 'Fine.', questions: [tone]);

        expect(typeSafe.lastBody['questions'], {
          'q0': {
            'type': 'choice',
            'criteria': {'calm': null, 'angry': 'Shouting or threats'},
          },
        });
      },
    );
  });
  group('Given a Score', () {
    test(
      'When its Levels are enum values, '
      'then their descriptions go on the wire as a list in map order',
      () async {
        const severity = TJevScore<Severity>(
          id: 'bug_severity',
          instructions: 'How severe is the reported issue?',
          levels: {
            Severity.cosmetic: 'Cosmetic; no impact to functionality',
            Severity.degraded:
                'Broken or degraded feature, but workaround exists',
            Severity.blocking: 'Blocking issue; no workaround exists',
          },
        );

        await jev.ask(state: 'Export crashes.', questions: [severity]);

        expect(typeSafe.lastBody['questions'], {
          'bug_severity': {
            'type': 'score',
            'instructions': 'How severe is the reported issue?',
            'criteria': [
              'Cosmetic; no impact to functionality',
              'Broken or degraded feature, but workaround exists',
              'Blocking issue; no workaround exists',
            ],
          },
        });
      },
    );

    test(
      'When its Levels are runtime values, '
      'then only their descriptions go on the wire',
      () async {
        final candidates = [const Candidate(3), const Candidate(9)];
        final fit = TJevScore<Candidate>(
          levels: {
            for (final candidate in candidates)
              candidate: {
                'profile': 'Candidate ${candidate.id}',
                'senior': true,
              },
          },
        );

        await jev.ask(state: 'A senior Dart role.', questions: [fit]);

        expect(typeSafe.lastBody['questions'], {
          'q0': {
            'type': 'score',
            'criteria': [
              {'profile': 'Candidate 3', 'senior': true},
              {'profile': 'Candidate 9', 'senior': true},
            ],
          },
        });
      },
    );

    test(
      'When its Levels are a list of descriptions, '
      'then the list goes on the wire as is',
      () async {
        const frustration = TJevScore.list(
          instructions: 'How frustrated is the customer?',
          levels: ['Calm', 'Frustrated but civil', 'Very angry'],
        );

        await jev.ask(state: 'Third time!', questions: [frustration]);

        expect(typeSafe.lastBody['questions'], {
          'q0': {
            'type': 'score',
            'instructions': 'How frustrated is the customer?',
            'criteria': ['Calm', 'Frustrated but civil', 'Very angry'],
          },
        });
      },
    );
  });

  group('Given a Choice, a Score and a Noul', () {
    test(
      'When asked in one Request, then each goes on the wire under its id',
      () async {
        await jev.ask(
          state: 'Wrong size, third time.',
          questions: const [
            TJevChoice<Team>(options: {Team.returns: 'Returns'}),
            TJevScore.list(levels: ['Calm', 'Angry']),
            TJevNoul(instructions: 'Is this about billing?'),
          ],
        );

        final questions = typeSafe.lastBody['questions']! as Map;
        expect(
          [for (final question in questions.values) (question as Map)['type']],
          ['choice', 'score', 'noul'],
        );
        expect(questions.keys, ['q0', 'q1', 'q2']);
      },
    );
  });
}
