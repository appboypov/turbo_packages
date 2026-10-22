@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/models/no_json.dart';
import 'support/services/fake_type_safe.dart';
import 'support/utils/throws_t_jev_exception.dart';

const _billing = TJevNoul(instructions: 'Is this message about billing?');

const _billingQuestions = {
  'q0': {'type': 'noul', 'instructions': 'Is this message about billing?'},
};

void main() {
  group('Given a client with a default model', () {
    late FakeTypeSafe typeSafe;
    late TJev jev;

    setUp(() {
      typeSafe = FakeTypeSafe();
      jev = TJev(
        apiKey: 'ts_test_key',
        defaultModel: TJevModel.jev1_13_0,
        httpClient: typeSafe.client,
        environment: const {},
      );
    });

    test('When a call names a model, then only that Request uses it', () async {
      await jev.ask(
        state: 'I was charged twice.',
        questions: const [_billing],
        model: TJevModel.jevPreview,
      );
      await jev.ask(state: 'Where is my parcel?', questions: const [_billing]);

      expect(FakeTypeSafe.bodyOf(typeSafe.requests.first), {
        'model': 'jev-preview',
        'state': 'I was charged twice.',
        'questions': _billingQuestions,
      });
      expect(FakeTypeSafe.bodyOf(typeSafe.requests.last), {
        'model': 'jev-1.13.0',
        'state': 'Where is my parcel?',
        'questions': _billingQuestions,
      });
    });

    test(
      'When a call has extra body fields, then they land in the body',
      () async {
        await jev.ask(
          state: 'I was charged twice.',
          questions: const [_billing],
          extraBody: {
            'trace': {'id': 'trace_1'},
            'note': null,
          },
        );

        expect(typeSafe.lastBody, {
          'model': 'jev-1.13.0',
          'state': 'I was charged twice.',
          'questions': _billingQuestions,
          'trace': {'id': 'trace_1'},
          'note': null,
        });
      },
    );

    test(
      'When an extra body field names a Request field, '
      'then the extra value is sent',
      () async {
        await jev.ask(
          state: 'I was charged twice.',
          questions: const [_billing],
          model: TJevModel.jevPreview,
          extraBody: {'model': 'jev-custom'},
        );

        expect(typeSafe.lastBody, {
          'model': 'jev-custom',
          'state': 'I was charged twice.',
          'questions': _billingQuestions,
        });
      },
    );

    for (final (what, extraBody) in <(String, Map<String, Object?>)>[
      (
        'a non-finite number',
        {
          'trace': {'score': double.nan},
        },
      ),
      ('an object without toJson', {'trace': const NoJson()}),
    ]) {
      test(
        'When an extra body field holds $what, then asking throws before '
        'sending',
        () {
          expect(
            () => jev.ask(
              state: 'I was charged twice.',
              questions: const [_billing],
              extraBody: extraBody,
            ),
            throwsTJevException<TJevInvalidQuestionException>(),
          );
          expect(typeSafe.requests, isEmpty);
        },
      );
    }
  });
}
