@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/enums/kind.dart';
import 'support/models/no_json.dart';
import 'support/models/rubric.dart';
import 'support/models/tag.dart';
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

  void expectValid(TJevQuestion question) {
    expect(question.validate(), isA<Success<void>>());
  }

  void expectInvalid(TJevQuestion question) {
    expect(
      question.validate(),
      isA<Fail<void>>().having((fail) => fail.message, 'message', isNotEmpty),
    );
  }

  group('Given a Choice', () {
    test('When it has no Options, then it is invalid', () {
      expectInvalid(const TJevChoice<String>(options: {}));
    });

    test('When it has more than 255 Options, then it is invalid', () {
      expectInvalid(
        TJevChoice<int>(options: {for (var i = 0; i < 256; i++) i: null}),
      );
    });

    test('When it has 1 or 255 Options, then it is valid', () {
      expectValid(const TJevChoice<String>(options: {'only': null}));
      expectValid(
        TJevChoice<int>(options: {for (var i = 0; i < 255; i++) i: null}),
      );
    });

    test('When it has 255 Options, then it is sent', () async {
      await jev.ask(
        state: 'Some State.',
        questions: [
          TJevChoice<int>(options: {for (var i = 0; i < 255; i++) i: null}),
        ],
      );

      expect(typeSafe.requests, hasLength(1));
    });

    test('When two Options share a wire key, then it is invalid', () {
      expectInvalid(
        const TJevChoice<Tag>(
          options: {Tag('urgent', 1): 'Now', Tag('urgent', 2): 'Today'},
        ),
      );
    });

    test(
      'When an enum value and a string share a wire key, then it is invalid',
      () {
        expectInvalid(
          const TJevChoice<Object>(
            options: {Kind.single: 'One', 'single': 'Also one'},
          ),
        );
      },
    );
  });

  group('Given a Score', () {
    test('When it has no Levels, then it is invalid', () {
      expectInvalid(const TJevScore<String>(levels: {}));
      expectInvalid(const TJevScore<String>.list(levels: []));
    });

    test('When it has more than 10 Levels, then it is invalid', () {
      expectInvalid(
        TJevScore<int>.list(levels: [for (var i = 0; i < 11; i++) i]),
      );
    });

    test('When it has 1 or 10 Levels, then it is valid', () {
      expectValid(const TJevScore.list(levels: ['Only']));
      expectValid(
        TJevScore<int>.list(levels: [for (var i = 0; i < 10; i++) i]),
      );
    });

    test('When it has 1 or 10 Levels, then it is sent', () async {
      await jev.ask(
        state: 'Some State.',
        questions: [
          const TJevScore.list(levels: ['Only']),
          TJevScore<int>.list(levels: [for (var i = 0; i < 10; i++) i]),
        ],
      );

      expect(typeSafe.requests, hasLength(1));
    });

    test('When two Levels of a list are equal, then it is invalid', () {
      expectInvalid(const TJevScore.list(levels: ['Low', 'High', 'Low']));
    });

    test('When two Levels share a wire key, then it is invalid', () {
      expectInvalid(
        const TJevScore<Object>(
          levels: {Kind.single: 'One', 'single': 'Also one'},
        ),
      );
      expectInvalid(const TJevScore<Object>.list(levels: [1, '1']));
    });
  });

  group('Given a Noul', () {
    test('When it has no Instructions and no meanings, then it is invalid', () {
      expectInvalid(const TJevNoul(id: 'empty'));
    });

    test('When it has Instructions or a meaning, then it is valid', () {
      expectValid(const TJevNoul(instructions: 'Is this spam?'));
      expectValid(const TJevNoul(trueMeans: 'Spam'));
      expectValid(const TJevNoul(falseMeans: 'Not spam'));
    });

    test('When it has only the meaning of false, then it is sent', () async {
      await jev.ask(
        state: 'Some State.',
        questions: const [TJevNoul(falseMeans: 'Not spam')],
      );

      expect(typeSafe.lastBody['questions'], {
        'q0': {
          'type': 'noul',
          'criteria': {'false': 'Not spam'},
        },
      });
    });
  });

  group('Given a Box', () {
    test('When it has Instructions or none, then it is valid', () {
      expectValid(const TJevBox(instructions: 'the mug in `photo`'));
      expectValid(const TJevBox());
    });

    test('When its Instructions hold a non-finite number, '
        'then it is invalid', () {
      expectInvalid(const TJevBox(instructions: double.nan));
    });
  });

  group('Given content', () {
    test(
      'When it holds strings, numbers, booleans, maps, lists and objects with '
      'toJson, then it goes on the wire as JSON',
      () async {
        await jev.ask(
          state: 'Some State.',
          questions: const [
            TJevChoice<String>(
              instructions: [
                'Pick one',
                {'strict': true, 'max': 3},
              ],
              options: {'a': Rubric(0.5), 'b': 7, 'c': false},
            ),
          ],
        );

        expect(typeSafe.lastBody['questions'], {
          'q0': {
            'type': 'choice',
            'instructions': [
              'Pick one',
              {'strict': true, 'max': 3},
            ],
            'criteria': {
              'a': {'weight': 0.5},
              'b': 7,
              'c': false,
            },
          },
        });
      },
    );

    for (final (where, question) in <(String, TJevQuestion)>[
      ('Instructions', const TJevNoul(instructions: double.nan)),
      (
        'a nested meaning',
        const TJevNoul(
          trueMeans: {
            'scores': [1, double.infinity],
          },
        ),
      ),
      (
        'an Option description',
        const TJevChoice<String>(options: {'a': double.negativeInfinity}),
      ),
      (
        'a Level description',
        const TJevScore<String>(
          levels: {
            'low': {'weight': double.nan},
          },
        ),
      ),
      (
        'the toJson of an object',
        const TJevChoice<String>(options: {'a': Rubric(double.nan)}),
      ),
    ]) {
      test('When $where holds a non-finite number, then it is invalid', () {
        expectInvalid(question);
      });
    }

    test('When it holds an object without toJson, then it is invalid', () {
      expectInvalid(const TJevNoul(instructions: NoJson()));
    });

    test('When a map in it has a key that is no String, '
        'then it is invalid', () {
      expectInvalid(const TJevNoul(instructions: {1: 'one'}));
    });
  });

  group('Given an invalid Question', () {
    for (final question in <TJevQuestion>[
      const TJevNoul(id: 'empty'),
      const TJevChoice<String>(id: 'pick', options: {}),
      const TJevScore<String>.list(id: 'rate', levels: []),
      const TJevBox(id: 'find', instructions: double.nan),
    ]) {
      test(
        'When a ${question.runtimeType} is asked, then asking throws with its '
        'id and broken rule before sending',
        () {
          expect(
            () => jev.ask(
              state: 'Some State.',
              questions: [question],
              model: TJevModel.jevPreview,
            ),
            throwsA(
              isA<TJevInvalidQuestionException>().having(
                (exception) => exception.message,
                'message',
                allOf(
                  contains(question.id!),
                  endsWith(question.validate().message!),
                ),
              ),
            ),
          );
          expect(typeSafe.requests, isEmpty);
        },
      );
    }
  });

  group('Given State', () {
    const question = TJevNoul(instructions: 'Is this about billing?');

    for (final (what, state) in <(String, Object)>[
      ('a non-finite number', {'score': double.nan}),
      ('a map key that is no String', {1: 'one'}),
      ('an object without toJson', const NoJson()),
      (
        'the toJson of an object with a non-finite number',
        const Rubric(double.infinity),
      ),
    ]) {
      test('When it holds $what, then asking throws before sending', () {
        expect(
          () => jev.ask(state: state, questions: const [question]),
          throwsA(isA<TJevInvalidQuestionException>()),
        );
        expect(typeSafe.requests, isEmpty);
      });
    }
  });
}
