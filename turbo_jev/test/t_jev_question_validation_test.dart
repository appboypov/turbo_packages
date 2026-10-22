@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

enum _Kind { single }

final class _Tag {
  const _Tag(this.name, this.id);

  final String name;

  final int id;

  @override
  String toString() => name;
}

final class _Rubric {
  const _Rubric(this.weight);

  final double weight;

  Map<String, Object?> toJson() => {'weight': weight};
}

final class _NoJson {
  const _NoJson();
}

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

  void expectThrowsBeforeSending(TJevQuestion question) {
    expect(
      () => jev.ask(state: 'Some State.', questions: [question]),
      throwsA(isA<TJevInvalidQuestionException>()),
    );
    expect(typeSafe.requests, isEmpty);
  }

  group('Given a Choice', () {
    test('When it has no Options, then asking throws before sending', () {
      expectThrowsBeforeSending(const TJevChoice<String>(options: {}));
    });

    test(
      'When it has more than 255 Options, then asking throws before sending',
      () {
        expectThrowsBeforeSending(
          TJevChoice<int>(options: {for (var i = 0; i < 256; i++) i: null}),
        );
      },
    );

    test('When it has 255 Options, then it is sent', () async {
      await jev.ask(
        state: 'Some State.',
        questions: [
          TJevChoice<int>(options: {for (var i = 0; i < 255; i++) i: null}),
        ],
      );

      expect(typeSafe.requests, hasLength(1));
    });

    test(
      'When two Options share a wire key, then asking throws before sending',
      () {
        expectThrowsBeforeSending(
          const TJevChoice<_Tag>(
            options: {_Tag('urgent', 1): 'Now', _Tag('urgent', 2): 'Today'},
          ),
        );
      },
    );

    test(
      'When an enum value and a string share a wire key, '
      'then asking throws before sending',
      () {
        expectThrowsBeforeSending(
          const TJevChoice<Object>(
            options: {_Kind.single: 'One', 'single': 'Also one'},
          ),
        );
      },
    );
  });

  group('Given a Score', () {
    test('When it has no Levels, then asking throws before sending', () {
      expectThrowsBeforeSending(const TJevScore<String>(levels: {}));
      expectThrowsBeforeSending(const TJevScore<String>.list(levels: []));
    });

    test(
      'When it has more than 10 Levels, then asking throws before sending',
      () {
        expectThrowsBeforeSending(
          TJevScore<int>.list(levels: [for (var i = 0; i < 11; i++) i]),
        );
      },
    );

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

    test(
      'When two Levels of a list are equal, then asking throws before sending',
      () {
        expectThrowsBeforeSending(
          const TJevScore.list(levels: ['Low', 'High', 'Low']),
        );
      },
    );

    test(
      'When two Levels share a wire key, then asking throws before sending',
      () {
        expectThrowsBeforeSending(
          const TJevScore<Object>(
            levels: {_Kind.single: 'One', 'single': 'Also one'},
          ),
        );
        expectThrowsBeforeSending(
          const TJevScore<Object>.list(levels: [1, '1']),
        );
      },
    );
  });

  group('Given a Noul', () {
    test(
      'When it has no Instructions and no meanings, '
      'then asking throws before sending',
      () {
        expectThrowsBeforeSending(const TJevNoul(id: 'empty'));
      },
    );

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
              options: {'a': _Rubric(0.5), 'b': 7, 'c': false},
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
        const TJevChoice<String>(options: {'a': _Rubric(double.nan)}),
      ),
    ]) {
      test(
        'When $where holds a non-finite number, '
        'then asking throws before sending',
        () {
          expectThrowsBeforeSending(question);
        },
      );
    }

    test(
      'When it holds an object without toJson, '
      'then asking throws before sending',
      () {
        expectThrowsBeforeSending(const TJevNoul(instructions: _NoJson()));
      },
    );

    test(
      'When a map in it has a key that is no String, '
      'then asking throws before sending',
      () {
        expectThrowsBeforeSending(
          const TJevNoul(instructions: {1: 'one'}),
        );
      },
    );
  });

  group('Given State', () {
    const question = TJevNoul(instructions: 'Is this about billing?');

    for (final (what, state) in <(String, Object)>[
      ('a non-finite number', {'score': double.nan}),
      ('a map key that is no String', {1: 'one'}),
      ('an object without toJson', const _NoJson()),
      (
        'the toJson of an object with a non-finite number',
        const _Rubric(double.infinity),
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
