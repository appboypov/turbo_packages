@TestOn('vm')
library;

import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';
import 'support/images.dart';

const _imagesHeader = 'TypeSafe-Danger-Zone-Images';

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

  group('Given an Image placed as a value in the State', () {
    late TJevImage door;

    setUp(() => door = TJevImage(jpegBytes));

    test(
      'When asked, then the Request is multipart with the JSON in a request '
      'part and the Image in an asset-0 part with its sniffed content type',
      () async {
        await jev.ask(
          state: {'door': door},
          questions: const [TJevNoul(instructions: 'Is someone at `door`?')],
        );

        final request = typeSafe.lastRequest;
        final contentType = MediaType.parse(request.headers['Content-Type']!);
        expect(contentType.mimeType, 'multipart/form-data');
        expect(contentType.parameters['boundary'], isNotEmpty);
        final parts = FakeTypeSafe.partsOf(request);
        expect([for (final part in parts) part.name], ['request', 'asset-0']);
        expect(parts.first.contentType, 'application/json');
        expect(parts.last.contentType, 'image/jpeg');
        expect(parts.last.bytes, jpegBytes);
        expect(FakeTypeSafe.bodyOf(request), {
          'model': 'jev-latest',
          'state': {'door': door.reference},
          'questions': {
            'q0': {'type': 'noul', 'instructions': 'Is someone at `door`?'},
          },
          'assets': {
            door.reference: {'type': 'image', 'part': 'asset-0'},
          },
        });
      },
    );

    test(
      'When asked, then the Request sends the Images Danger Zone header',
      () async {
        await jev.ask(
          state: door,
          questions: const [TJevNoul(instructions: 'Is someone there?')],
        );

        expect(typeSafe.lastRequest.headers[_imagesHeader], 'true');
      },
    );

    test(
      'When it is placed twice, then it is sent in one part',
      () async {
        await jev.ask(
          state: [door, door],
          questions: const [TJevNoul(instructions: 'Same frame twice?')],
        );

        final parts = FakeTypeSafe.partsOf(typeSafe.lastRequest);
        expect([for (final part in parts) part.name], ['request', 'asset-0']);
        expect(typeSafe.lastBody['assets'], {
          door.reference: {'type': 'image', 'part': 'asset-0'},
        });
      },
    );
  });

  test(
    'Given an Image placed in Instructions, when asked, '
    'then it is found and sent',
    () async {
      final badge = TJevImage(pngBytes);

      await jev.ask(
        state: 'A person at the door.',
        questions: [
          TJevNoul(
            instructions: {
              'question': 'Is this the person on the badge?',
              'badge': badge,
            },
          ),
        ],
      );

      final parts = FakeTypeSafe.partsOf(typeSafe.lastRequest);
      expect(parts.last.contentType, 'image/png');
      expect(parts.last.bytes, pngBytes);
      expect(typeSafe.lastBody['assets'], {
        badge.reference: {'type': 'image', 'part': 'asset-0'},
      });
      expect(typeSafe.lastRequest.headers[_imagesHeader], 'true');
    },
  );

  test(
    'Given Images placed in the Criteria of a Choice, a Score and a Noul, '
    'when asked, then each is sent in its own part in order of first use',
    () async {
      final thumbsUp = TJevImage(pngBytes);
      final openPalm = TJevImage(jpegBytes);
      final calm = TJevImage(pngBytes);
      final yes = TJevImage(jpegBytes);

      await jev.ask(
        state: 'A hand in front of the camera.',
        questions: [
          TJevChoice<String>(
            options: {
              'thumbs_up': thumbsUp,
              'open_palm': {
                'description': 'A hand held up',
                'examples': [openPalm],
              },
            },
          ),
          TJevScore.list(levels: [calm, 'Agitated']),
          TJevNoul(instructions: 'Is it waving?', trueMeans: yes),
        ],
      );

      final parts = FakeTypeSafe.partsOf(typeSafe.lastRequest);
      expect(
        [for (final part in parts) (part.name, part.contentType)],
        [
          ('request', 'application/json'),
          ('asset-0', 'image/png'),
          ('asset-1', 'image/jpeg'),
          ('asset-2', 'image/png'),
          ('asset-3', 'image/jpeg'),
        ],
      );
      expect(typeSafe.lastBody['assets'], {
        thumbsUp.reference: {'type': 'image', 'part': 'asset-0'},
        openPalm.reference: {'type': 'image', 'part': 'asset-1'},
        calm.reference: {'type': 'image', 'part': 'asset-2'},
        yes.reference: {'type': 'image', 'part': 'asset-3'},
      });
    },
  );

  test(
    'Given Images placed inside the toJson of objects in the State and the '
    'Criteria, when asked without images, then each is found and sent',
    () async {
      final front = TJevImage(jpegBytes);
      final example = TJevImage(pngBytes);

      await jev.ask(
        state: _Frames([front]),
        questions: [
          TJevNoul(
            instructions: 'Is it the same car?',
            trueMeans: _Frames([example]),
          ),
        ],
      );

      expect(typeSafe.lastBody['state'], [front.reference]);
      expect(typeSafe.lastBody['assets'], {
        front.reference: {'type': 'image', 'part': 'asset-0'},
        example.reference: {'type': 'image', 'part': 'asset-1'},
      });
      final parts = FakeTypeSafe.partsOf(typeSafe.lastRequest);
      expect(parts.map((part) => part.bytes), [anything, jpegBytes, pngBytes]);
    },
  );

  group('Given an Image interpolated in a string', () {
    late TJevImage badge;

    setUp(() => badge = TJevImage(pngBytes));

    test(
      'When it is listed in images, then it is sent with the string as is',
      () async {
        await jev.ask(
          state: 'A person at the door.',
          questions: [
            TJevNoul(instructions: 'Is this the person in $badge?'),
          ],
          images: [badge],
        );

        expect(typeSafe.lastBody['questions'], {
          'q0': {
            'type': 'noul',
            'instructions': 'Is this the person in ${badge.reference}?',
          },
        });
        expect(typeSafe.lastBody['assets'], {
          badge.reference: {'type': 'image', 'part': 'asset-0'},
        });
        expect(FakeTypeSafe.partsOf(typeSafe.lastRequest).last.bytes, pngBytes);
      },
    );

    test(
      'When it is not listed in images, then asking throws before sending',
      () {
        expect(
          () => jev.ask(
            state: 'A person at the door.',
            questions: [
              TJevNoul(instructions: 'Is this the person in $badge?'),
            ],
          ),
          throwsA(isA<TJevImageReferenceException>()),
        );
        expect(typeSafe.requests, isEmpty);
      },
    );
  });

  test(
    'Given an Image listed in images, when no content uses it, '
    'then asking throws before sending',
    () {
      final unused = TJevImage(pngBytes);

      expect(
        () => jev.ask(
          state: 'A person at the door.',
          questions: const [TJevNoul(instructions: 'Is someone there?')],
          images: [unused],
        ),
        throwsA(isA<TJevImageReferenceException>()),
      );
      expect(typeSafe.requests, isEmpty);
    },
  );

  test(
    'Given a Request without Images or Boxes, when asked, '
    'then it is sent as JSON without the Images Danger Zone header',
    () async {
      await jev.ask(
        state: 'I was charged twice.',
        questions: const [TJevNoul(instructions: 'About billing?')],
      );

      final request = typeSafe.lastRequest;
      expect(request.headers['Content-Type'], 'application/json');
      expect(request.headers.containsKey(_imagesHeader), isFalse);
      expect(typeSafe.lastBody.containsKey('assets'), isFalse);
    },
  );
}

/// A model whose `toJson` holds Images.
final class _Frames {
  const _Frames(this.frames);

  final List<TJevImage> frames;

  List<TJevImage> toJson() => frames;
}
