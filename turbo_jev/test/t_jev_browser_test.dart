@TestOn('browser')
library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

const _billing = TJevNoul(instructions: 'Is this message about billing?');

void main() {
  group('Given a browser', () {
    test(
      'When the client is built without dangerouslyAllowBrowser, '
      'then it throws a TJevBrowserException',
      () {
        expect(
          () => TJev(apiKey: 'ts_test_key', environment: const {}),
          throwsA(isA<TJevBrowserException>()),
        );
      },
    );

    test(
      'When the client is built with dangerouslyAllowBrowser, '
      'then it is built',
      () {
        final jev = TJev(
          apiKey: 'ts_test_key',
          environment: const {},
          dangerouslyAllowBrowser: true,
        );

        expect(jev, isA<TJev>());
        jev.close();
      },
    );
  });

  group('Given a browser client', () {
    late FakeTypeSafe typeSafe;
    late TJev jev;

    setUp(() {
      var calls = 0;
      typeSafe = FakeTypeSafe(
        respond: (request) => calls++ == 0
            ? http.Response('{}', 500)
            : FakeTypeSafe.noulResponse(nouls: {'q0': 0.9}),
      );
      jev = TJev(
        apiKey: 'ts_test_key',
        retry: TJevRetryPolicy(initialBackoff: Duration.zero),
        httpClient: typeSafe.client,
        environment: const {},
        dangerouslyAllowBrowser: true,
      );
    });

    test(
      'When a Request is sent and retried, '
      'then neither attempt sends User-Agent or X-TypeSafe headers',
      () async {
        await jev.ask(state: 'I was charged twice.', questions: [_billing]);

        expect(typeSafe.requests, hasLength(2));
        for (final request in typeSafe.requests) {
          final names = request.headers.keys.map((name) => name.toLowerCase());
          expect(names, isNot(contains('user-agent')));
          expect(
            names.where((name) => name.startsWith('x-typesafe-')),
            isEmpty,
          );
          expect(request.headers['Authorization'], 'Bearer ts_test_key');
        }
      },
    );

    test(
      'When the body is 1024 bytes or more, then it is sent uncompressed',
      () async {
        final state = 'a' * 2048;

        await jev.ask(state: state, questions: [_billing]);

        final request = typeSafe.lastRequest;
        expect(request.headers.containsKey('Content-Encoding'), isFalse);
        expect(jsonDecode(utf8.decode(request.bodyBytes)), {
          'model': 'jev-latest',
          'state': state,
          'questions': {
            'q0': {
              'type': 'noul',
              'instructions': 'Is this message about billing?',
            },
          },
        });
      },
    );
  });

  group('Given an Image file path in a browser', () {
    test('When the Image is created from the file, then it throws', () {
      expect(
        TJevImage.fromFile('photo.png'),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
