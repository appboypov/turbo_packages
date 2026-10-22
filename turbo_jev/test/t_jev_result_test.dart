@TestOn('vm')
library;

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

const _billing = TJevNoul(
  id: 'billing',
  instructions: 'Is this about billing?',
);
const _refund = TJevNoul(
  id: 'refund',
  instructions: 'Does it ask for a refund?',
);

void main() {
  Future<TurboResponse<TJevResult>> ask(
    http.Response Function(http.Request request) respond, {
    List<TJevQuestion> questions = const [_billing, _refund],
  }) {
    final typeSafe = FakeTypeSafe(respond: respond);
    final jev = TJev(
      apiKey: 'ts_key',
      httpClient: typeSafe.client,
      environment: const {},
      retry: TJevRetryPolicy(maxRetries: 0),
    );
    return jev.ask(state: 'I was charged twice.', questions: questions);
  }

  group('Given a 2xx response', () {
    test(
      'When a Noul is read, then it gives its Probability and a Confidence '
      'of abs(2p - 1)',
      () async {
        final response = await ask(
          (_) => FakeTypeSafe.noulResponse(
            nouls: {'billing': 0.9, 'refund': 0.25},
          ),
        );

        final result = response.result!;
        final billing = result.answer(_billing);
        final refund = result.answer(_refund);
        expect(billing.probability, 0.9);
        expect(billing.confidence, closeTo(0.8, 1e-9));
        expect(refund.probability, 0.25);
        expect(refund.confidence, closeTo(0.5, 1e-9));
      },
    );

    test(
      'When the result is read, then it gives the resolved model, '
      'the Usage and the request id',
      () async {
        final response = await ask(
          (_) => FakeTypeSafe.noulResponse(
            nouls: {'billing': 0.9, 'refund': 0.1},
            model: 'jev-1.13.0',
            usage: {'input_tokens': 120, 'output_tokens': 12},
            headers: {'x-typesafe-request-id': 'req_abc'},
          ),
        );

        final result = response.result!;
        expect(result.model, TJevModel.jev1_13_0);
        expect(result.usage.inputTokens, 120);
        expect(result.usage.outputTokens, 12);
        expect(result.requestId, 'req_abc');
        expect(result.httpResponse.statusCode, 200);
      },
    );

    test(
      'When TypeSafe sends null token counts and no request id, '
      'then those values are null',
      () async {
        final response = await ask(
          (_) => FakeTypeSafe.noulResponse(
            nouls: {'billing': 0.9, 'refund': 0.1},
            usage: {'input_tokens': null, 'output_tokens': null},
            headers: {},
          ),
        );

        final result = response.result!;
        expect(result.usage.inputTokens, isNull);
        expect(result.usage.outputTokens, isNull);
        expect(result.requestId, isNull);
      },
    );

    test(
      'When a Question that was not asked is read, then it throws',
      () async {
        final response = await ask(
          (_) => FakeTypeSafe.noulResponse(nouls: {'billing': 0.9}),
          questions: const [_billing],
        );

        expect(
          () => response.result!.answer(_refund),
          throwsA(isA<TJevUnaskedQuestionException>()),
        );
      },
    );
  });

  group('Given a non-2xx response', () {
    for (final status in [400, 401, 404, 408, 422, 429, 500, 503]) {
      test(
        'When TypeSafe answers $status, then ask returns a fail '
        'with that status, request id, headers and body',
        () async {
          final response = await ask(
            (_) => http.Response(
              '{"detail": "Something went wrong"}',
              status,
              headers: {
                'content-type': 'application/json',
                'x-typesafe-request-id': 'req_failed',
              },
            ),
          );

          expect(response.isFail, isTrue);
          final failure = response.error! as TJevHttpFailure;
          expect(failure.status, status);
          expect(failure.requestId, 'req_failed');
          expect(failure.headers['x-typesafe-request-id'], 'req_failed');
          expect(failure.body, {'detail': 'Something went wrong'});
        },
      );
    }

    test(
      'When the body is not JSON, then the failure holds its text',
      () async {
        final response = await ask(
          (_) => http.Response('Bad gateway', 502),
        );

        final failure = response.error! as TJevHttpFailure;
        expect(failure.body, 'Bad gateway');
        expect(failure.requestId, isNull);
      },
    );
  });
}
