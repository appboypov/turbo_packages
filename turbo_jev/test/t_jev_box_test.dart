import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';
import 'support/images.dart';

const _mug = TJevBox(id: 'mug', instructions: 'the coffee mug in `photo`');

const _mugVisible = TJevNoul(
  id: 'mug_visible',
  instructions: 'Is there a coffee mug in `photo`?',
);

/// A 200 System One response holding [answers] keyed by Question id.
http.Response _answered(Map<String, Object?> answers) => http.Response(
  jsonEncode({
    'model': 'jev-1.14.0',
    'answers': answers,
    'usage': {'input_tokens': 290, 'output_tokens': 21},
  }),
  200,
  headers: {'content-type': 'application/json'},
);

void main() {
  late TJevImage photo;

  setUp(() => photo = TJevImage(jpegBytes));

  TJev jevAnswering(FakeTypeSafe typeSafe) => TJev(
    apiKey: 'ts_test_key',
    defaultModel: TJevModel.jevPreview,
    httpClient: typeSafe.client,
    environment: const {},
  );

  group('Given a Box', () {
    test(
      'When asked, then it goes on the wire with its Instructions',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => _answered({
            'mug': {
              'type': 'box',
              'box': {'top': 0.25, 'bottom': 0.82, 'left': 0.44, 'right': 0.84},
              'confidence': 0.92,
            },
          }),
        );

        await jevAnswering(
          typeSafe,
        ).ask(state: {'photo': photo}, questions: const [_mug]);

        expect(typeSafe.lastBody['questions'], {
          'mug': {'type': 'box', 'instructions': 'the coffee mug in `photo`'},
        });
      },
    );

    test(
      'When it has no Instructions, then only its type goes on the wire',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => _answered({
            'q0': {
              'type': 'box',
              'box': {'top': 0.1, 'bottom': 0.9, 'left': 0.2, 'right': 0.8},
              'confidence': null,
            },
          }),
        );

        await jevAnswering(
          typeSafe,
        ).ask(state: photo, questions: const [TJevBox()]);

        expect(typeSafe.lastBody['questions'], {
          'q0': {'type': 'box'},
        });
      },
    );

    test(
      'When asked without an Image, '
      'then the Request still sends the Images Danger Zone header',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => _answered({
            'mug': {
              'type': 'box',
              'box': {'top': 0.1, 'bottom': 0.9, 'left': 0.2, 'right': 0.8},
              'confidence': 0.5,
            },
          }),
        );

        await jevAnswering(
          typeSafe,
        ).ask(state: 'A kitchen.', questions: const [_mug]);

        expect(
          typeSafe.lastRequest.headers['TypeSafe-Danger-Zone-Images'],
          'true',
        );
      },
    );
  });

  group('Given a Box Answer', () {
    test(
      'When it has a Confidence, then the Box Answer gives the edges as '
      'fractions of the Image and the Confidence',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => _answered({
            'mug_visible': {'type': 'noul', 'noul': 0.97},
            'mug': {
              'type': 'box',
              'box': {'top': 0.25, 'bottom': 0.82, 'left': 0.44, 'right': 0.84},
              'confidence': 0.92,
            },
          }),
        );

        final response = await jevAnswering(typeSafe).ask(
          state: {'photo': photo},
          questions: const [_mugVisible, _mug],
        );

        final result = response.result!;
        final mug = result.answer(_mug);
        expect(
          (mug.top, mug.bottom, mug.left, mug.right, mug.confidence),
          (0.25, 0.82, 0.44, 0.84, 0.92),
        );
        expect(result.boxes.keys, [_mug]);
        expect(result.answer(_mugVisible).probability, 0.97);
      },
    );

    test('When its Confidence is null, then the Confidence is null', () async {
      final typeSafe = FakeTypeSafe(
        respond: (_) => _answered({
          'mug': {
            'type': 'box',
            'box': {'top': 0, 'bottom': 1, 'left': 0, 'right': 1},
            'confidence': null,
          },
        }),
      );

      final response = await jevAnswering(
        typeSafe,
      ).ask(state: {'photo': photo}, questions: const [_mug]);

      final mug = response.result!.answer(_mug);
      expect(mug.confidence, isNull);
      expect((mug.top, mug.bottom, mug.left, mug.right), (0.0, 1.0, 0.0, 1.0));
    });

    test(
      'When it answers with a Noul, then the call fails with a response '
      'validation failure',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => _answered({
            'mug': {'type': 'noul', 'noul': 0.4},
          }),
        );

        final response = await jevAnswering(
          typeSafe,
        ).ask(state: {'photo': photo}, questions: const [_mug]);

        expect(response.error, isA<TJevResponseValidationFailure>());
      },
    );

    test(
      'When it has no edges, then the call fails with a response validation '
      'failure',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => _answered({
            'mug': {'type': 'box', 'confidence': 0.9},
          }),
        );

        final response = await jevAnswering(
          typeSafe,
        ).ask(state: {'photo': photo}, questions: const [_mug]);

        expect(response.error, isA<TJevResponseValidationFailure>());
      },
    );
  });

  group('Given the Box model table', () {
    for (final model in [TJevModel.jevPreview, TJevModel.jev1_14_0]) {
      test('When a Box is asked of ${model.id}, then it is sent', () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => _answered({
            'mug': {
              'type': 'box',
              'box': {'top': 0.1, 'bottom': 0.9, 'left': 0.2, 'right': 0.8},
              'confidence': 0.5,
            },
          }),
        );

        await jevAnswering(
          typeSafe,
        ).ask(state: {'photo': photo}, questions: const [_mug], model: model);

        expect(typeSafe.lastBody['model'], model.id);
      });
    }

    for (final model in [
      TJevModel.jevLatest,
      TJevModel.jev1_13_0,
      const TJevModel('jev-custom'),
    ]) {
      test(
        'When a Box is asked of ${model.id}, then asking throws before '
        'sending and names the Box models',
        () {
          final typeSafe = FakeTypeSafe();

          expect(
            () => jevAnswering(typeSafe).ask(
              state: {'photo': photo},
              questions: const [_mug],
              model: model,
            ),
            throwsA(
              isA<TJevInvalidQuestionException>().having(
                (exception) => exception.reason,
                'reason',
                allOf(contains('jev-preview'), contains('jev-1.14.0')),
              ),
            ),
          );
          expect(typeSafe.requests, isEmpty);
        },
      );
    }

    test(
      'When a Noul is asked of jev-latest, then no Box model is needed',
      () async {
        final typeSafe = FakeTypeSafe();

        await jevAnswering(typeSafe).ask(
          state: {'photo': photo},
          questions: const [_mugVisible],
          model: TJevModel.jevLatest,
        );

        expect(typeSafe.requests, hasLength(1));
      },
    );
  });
}
