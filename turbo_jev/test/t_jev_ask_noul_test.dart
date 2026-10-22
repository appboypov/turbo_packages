import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

void main() {
  group('Given a Noul Request', () {
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

    test('When asked, then it posts JSON to /v1/systemone', () async {
      const billing = TJevNoul(instructions: 'Is this message about billing?');

      await jev.ask(state: 'I was charged twice.', questions: [billing]);

      final request = typeSafe.lastRequest;
      expect(request.method, 'POST');
      expect(request.url, Uri.parse('https://api.typesafe.ai/v1/systemone'));
      expect(request.headers['Content-Type'], 'application/json');
      expect(typeSafe.lastBody, {
        'model': 'jev-latest',
        'state': 'I was charged twice.',
        'questions': {
          'q0': {
            'type': 'noul',
            'instructions': 'Is this message about billing?',
          },
        },
      });
    });

    test('When asked, then it sends the API key as bearer auth', () async {
      await jev.ask(
        state: 'I was charged twice.',
        questions: const [TJevNoul(instructions: 'Is this about billing?')],
      );

      expect(
        typeSafe.lastRequest.headers['Authorization'],
        'Bearer ts_test_key',
      );
    });

    test(
      'When a Noul has an id and meanings of true and false, '
      'then its id keys the Question and the meanings form its criteria',
      () async {
        const spam = TJevNoul(
          id: 'spam',
          instructions: {'task': 'Identify unsolicited advertising.'},
          trueMeans: 'Unsolicited advertising',
          falseMeans: 'A legitimate conversation',
        );

        await jev.ask(state: {'message': 'Buy now!'}, questions: [spam]);

        expect(typeSafe.lastBody['state'], {'message': 'Buy now!'});
        expect(typeSafe.lastBody['questions'], {
          'spam': {
            'type': 'noul',
            'instructions': {'task': 'Identify unsolicited advertising.'},
            'criteria': {
              'true': 'Unsolicited advertising',
              'false': 'A legitimate conversation',
            },
          },
        });
      },
    );

    test(
      'When a Noul has only the meaning of true, '
      'then it sends no Instructions and only that meaning',
      () async {
        const spam = TJevNoul(trueMeans: 'Unsolicited advertising');

        await jev.ask(state: 'Buy now!', questions: [spam]);

        expect(typeSafe.lastBody['questions'], {
          'q0': {
            'type': 'noul',
            'criteria': {'true': 'Unsolicited advertising'},
          },
        });
      },
    );

    test(
      'When several Questions miss an id, '
      'then they get q0, q1 and so on in Request order',
      () async {
        await jev.ask(
          state: 'I was charged twice.',
          questions: const [
            TJevNoul(instructions: 'Is this about billing?'),
            TJevNoul(id: 'refund', instructions: 'Does it ask for a refund?'),
            TJevNoul(instructions: 'Is the writer angry?'),
          ],
        );

        final questions = typeSafe.lastBody['questions']! as Map;
        expect(questions.keys, ['q0', 'refund', 'q1']);
      },
    );

    test(
      'When two Questions share an id, then asking throws before sending',
      () {
        expect(
          () => jev.ask(
            state: 'I was charged twice.',
            questions: const [
              TJevNoul(instructions: 'Is this about billing?'),
              TJevNoul(id: 'q0', instructions: 'Does it ask for a refund?'),
            ],
          ),
          throwsA(isA<TJevInvalidQuestionException>()),
        );
        expect(typeSafe.requests, isEmpty);
      },
    );

    test('When no Question is given, then asking throws before sending', () {
      expect(
        () => jev.ask(state: 'I was charged twice.', questions: const []),
        throwsA(isA<TJevInvalidQuestionException>()),
      );
      expect(typeSafe.requests, isEmpty);
    });
  });
}
