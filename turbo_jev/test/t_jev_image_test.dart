@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/images.dart';

void main() {
  group('Given PNG bytes', () {
    test(
      'When an Image is created from them, then it holds a copy of the bytes '
      'and is sniffed as PNG',
      () {
        final bytes = [...pngBytes];

        final image = TJevImage(bytes);
        bytes[0] = 0;

        expect(image.bytes, pngBytes);
        expect(image.format, TJevImageFormat.png);
        expect(image.format.contentType, 'image/png');
      },
    );

    test(
      'When an Image is created from them, '
      'then toString and toJson give its Image Reference',
      () {
        final image = TJevImage(pngBytes);

        expect(image.reference, matches(RegExp(r'^<image:[0-9a-f]{32}>$')));
        expect(image.toString(), image.reference);
        expect(image.toJson(), image.reference);
        expect(jsonEncode({'photo': image}), '{"photo":"${image.reference}"}');
      },
    );

    test(
      'When two Images are created from them, '
      'then each has its own Image Reference',
      () {
        final first = TJevImage(pngBytes);
        final second = TJevImage(pngBytes);

        expect(first.reference, isNot(second.reference));
      },
    );
  });

  test(
    'Given JPEG bytes, when an Image is created from them, '
    'then it is sniffed as JPEG',
    () {
      final image = TJevImage(jpegBytes);

      expect(image.format, TJevImageFormat.jpeg);
      expect(image.format.contentType, 'image/jpeg');
    },
  );

  group('Given base64 text', () {
    test(
      'When it encodes a JPEG, then the Image holds the decoded bytes',
      () {
        final image = TJevImage.fromBase64(base64.encode(jpegBytes));

        expect(image.bytes, jpegBytes);
        expect(image.format, TJevImageFormat.jpeg);
      },
    );

    test(
      'When it is wrapped over several lines, then the whitespace is ignored',
      () {
        final text = base64.encode(pngBytes);
        final wrapped = '${text.substring(0, 8)}\n${text.substring(8)}\r\n';

        final image = TJevImage.fromBase64(wrapped);

        expect(image.bytes, pngBytes);
      },
    );

    test('When it is no base64, then creating the Image throws', () {
      expect(
        () => TJevImage.fromBase64('not base64!'),
        throwsA(isA<TJevInvalidImageException>()),
      );
    });
  });

  group('Given a file', () {
    late Directory directory;

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('turbo_jev_image');
    });

    tearDown(() => directory.delete(recursive: true));

    test(
      'When it holds a PNG, then the Image holds its bytes',
      () async {
        final file = File('${directory.path}/door.png');
        await file.writeAsBytes(pngBytes);

        final image = await TJevImage.fromFile(file.path);

        expect(image.bytes, pngBytes);
        expect(image.format, TJevImageFormat.png);
      },
    );

    test('When it is empty, then creating the Image throws', () async {
      final file = File('${directory.path}/empty.png');
      await file.writeAsBytes(const []);

      await expectLater(
        TJevImage.fromFile(file.path),
        throwsA(isA<TJevInvalidImageException>()),
      );
    });
  });

  group('Given data that is no PNG or JPEG', () {
    test('When it is empty, then creating the Image throws', () {
      expect(
        () => TJevImage(const []),
        throwsA(isA<TJevInvalidImageException>()),
      );
    });

    test('When it is a GIF, then creating the Image throws', () {
      expect(
        () => TJevImage(gifBytes),
        throwsA(isA<TJevInvalidImageException>()),
      );
    });

    test(
      'When it is shorter than the PNG signature, then creating the Image '
      'throws',
      () {
        expect(
          () => TJevImage(pngBytes.sublist(0, 4)),
          throwsA(isA<TJevInvalidImageException>()),
        );
      },
    );
  });
}
