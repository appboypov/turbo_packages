@TestOn('vm')
library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/services/fake_type_safe.dart';

http.Response _modelsResponse(http.Request _) => http.Response(
  jsonEncode({
    'models': [
      {
        'name': 'jev-latest',
        'description': 'General-purpose system one model.',
        'release_date': '2026-09-15',
      },
      {
        'name': 'jev-preview',
        'description': 'The next Jev model, with Box.',
        'release_date': '2026-10-14',
      },
    ],
  }),
  200,
  headers: {'content-type': 'application/json'},
);

void main() {
  group('Given the models of the account', () {
    late FakeTypeSafe typeSafe;
    late TJev jev;

    setUp(() {
      typeSafe = FakeTypeSafe(respond: _modelsResponse);
      jev = TJev(
        apiKey: 'ts_test_key',
        defaultHeaders: {'X-Team': 'billing'},
        httpClient: typeSafe.client,
        environment: const {},
      );
    });

    test('When listed, then it gets /v1/models without a body', () async {
      await jev.models(headers: {'X-Trace': 'call'});

      final request = typeSafe.lastRequest;
      expect(request.method, 'GET');
      expect(request.url, Uri.parse('https://api.typesafe.ai/v1/models'));
      expect(request.bodyBytes, isEmpty);
      expect(request.headers['Authorization'], 'Bearer ts_test_key');
      expect(request.headers['Accept'], 'application/json');
      expect(request.headers.containsKey('Content-Type'), isFalse);
      expect(request.headers['X-Team'], 'billing');
      expect(request.headers['X-Trace'], 'call');
    });

    test('When listed, then each model card is parsed', () async {
      final response = await jev.models();

      final cards = response.result!;
      expect(cards.map((card) => card.name), [
        TJevModel.jevLatest,
        TJevModel.jevPreview,
      ]);
      expect(cards.map((card) => card.description), [
        'General-purpose system one model.',
        'The next Jev model, with Box.',
      ]);
      expect(cards.map((card) => card.releaseDate), [
        '2026-09-15',
        '2026-10-14',
      ]);
    });
  });

  for (final (what, body) in [
    ('a JSON list', '[]'),
    ('no JSON', 'not json'),
    ('a JSON object of the wrong shape', '{"models": 5}'),
  ]) {
    group('Given a 2xx models response whose body is $what', () {
      test(
        'When listed, then it fails with a response validation failure',
        () async {
          final typeSafe = FakeTypeSafe(
            respond: (_) => http.Response(body, 200),
          );
          final jev = TJev(
            apiKey: 'ts_test_key',
            httpClient: typeSafe.client,
            environment: const {},
          );

          final response = await jev.models();

          expect(response.error, isA<TJevResponseValidationFailure>());
        },
      );
    });
  }
}
