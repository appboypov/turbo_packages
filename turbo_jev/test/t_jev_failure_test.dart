@TestOn('vm')
library;

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/services/fake_type_safe.dart';

const _billing = TJevNoul(instructions: 'Is this about billing?');

/// These tests type single failures, so no Request is sent again.
final _noRetries = TJevRetryPolicy(maxRetries: 0);

void main() {
  Future<TJevFailure> failureFor(http.Response response) async {
    final typeSafe = FakeTypeSafe(respond: (_) => response);
    final jev = TJev(
      apiKey: 'ts_key',
      httpClient: typeSafe.client,
      environment: const {},
      retry: _noRetries,
    );
    final result = await jev.ask(
      state: 'I was charged twice.',
      questions: [_billing],
    );
    return result.error! as TJevFailure;
  }

  group('Given a non-2xx response', () {
    final failureTypes = <int, Matcher>{
      400: isA<TJevBadRequestFailure>(),
      401: isA<TJevAuthenticationFailure>(),
      403: isA<TJevPermissionDeniedFailure>(),
      404: isA<TJevNotFoundFailure>(),
      408: isA<TJevOtherStatusFailure>(),
      413: isA<TJevOtherStatusFailure>(),
      415: isA<TJevOtherStatusFailure>(),
      422: isA<TJevUnprocessableEntityFailure>(),
      429: isA<TJevRateLimitFailure>(),
      500: isA<TJevInternalServerFailure>(),
      503: isA<TJevInternalServerFailure>(),
      529: isA<TJevInternalServerFailure>(),
    };
    for (final MapEntry(key: status, value: failureType)
        in failureTypes.entries) {
      test(
        'When TypeSafe answers $status, then the failure has its type',
        () async {
          final failure = await failureFor(http.Response('{}', status));

          expect(failure, failureType);
          expect((failure as TJevHttpFailure).status, status);
        },
      );
    }
  });

  group('Given a non-2xx response body', () {
    Future<String> messageFor(String body) async {
      final failure = await failureFor(http.Response(body, 400));
      return (failure as TJevHttpFailure).message;
    }

    test('When it has an error string, then that is the message', () async {
      expect(
        await messageFor(
          '{"error": "Bad key", "message": "m", "detail": "d"}',
        ),
        'Bad key',
      );
    });

    test(
      'When it has no error string, then error.message comes first',
      () async {
        expect(
          await messageFor(
            '{"error": {"message": "Quota used"}, "message": "m"}',
          ),
          'Quota used',
        );
      },
    );

    test('When it has no error, then message comes next', () async {
      expect(
        await messageFor('{"error": 7, "message": "Too big", "detail": "d"}'),
        'Too big',
      );
    });

    test('When it has no message, then a detail string comes next', () async {
      expect(
        await messageFor('{"message": 7, "detail": "Missing state"}'),
        'Missing state',
      );
    });

    test('When detail is an object, then detail.message comes next', () async {
      expect(
        await messageFor('{"detail": {"message": "Unknown model"}}'),
        'Unknown model',
      );
    });

    test(
      'When detail is a list, then each entry reads loc: msg joined with ; '
      'and without a leading body',
      () async {
        expect(
          await messageFor(
            '{"detail": ['
            '{"loc": ["body", "questions", "q0", "criteria"], '
            '"msg": "Field required"}, '
            '{"loc": ["query", "verbose"], "msg": "Not a bool"}, '
            '{"msg": "State is empty"}, '
            '{"loc": ["body"], "msg": "Too many Questions"}, '
            '{"loc": ["body", "model"]}'
            ']}',
          ),
          'questions.q0.criteria: Field required; '
          'query.verbose: Not a bool; '
          'State is empty; '
          'Too many Questions',
        );
      },
    );

    test(
      'When a detail location holds body after its first entry, then that '
      'body stays in the message',
      () async {
        expect(
          await messageFor(
            '{"detail": ['
            '{"loc": ["body", "questions", "body", "options"], '
            '"msg": "Field required"}'
            ']}',
          ),
          'questions.body.options: Field required',
        );
      },
    );

    test('When it is plain text, then the text is the message', () async {
      expect(await messageFor('Bad gateway'), 'Bad gateway');
    });

    test(
      'When no step finds a message, then the message is the raw body',
      () async {
        expect(await messageFor('{"code": 7}'), '{"code":7}');
      },
    );

    test(
      'When the raw body is longer than 200 characters, then the message '
      'holds its first 200 characters and an ellipsis',
      () async {
        final body = '{"code": "${'x' * 300}"}';

        expect(await messageFor(body), '{"code":"${'x' * 191}…');
      },
    );

    test(
      'When the raw body is exactly 200 characters, then it is not cut',
      () async {
        final body = '{"code":"${'x' * 189}"}';

        expect(await messageFor(body), body);
      },
    );

    test(
      'When the body is empty, then the message says there is no body',
      () async {
        final failure =
            await failureFor(http.Response('', 503)) as TJevHttpFailure;

        expect(failure.message, 'status code (no body)');
        expect(failure.body, isNull);
      },
    );
  });

  group('Given a 422 response', () {
    test(
      'When its detail lists validation errors, then the failure holds each '
      'with its location and message',
      () async {
        final failure = await failureFor(
          http.Response(
            '{"detail": ['
            '{"type": "missing", "loc": ["body", "questions", "q0", 1], '
            '"msg": "Field required"}, '
            '{"loc": ["body", "state"], "msg": "Input should be a string"}, '
            '{"msg": "Too many Questions"}, '
            '{"loc": ["body", "model"]}'
            ']}',
            422,
          ),
        );

        final details = (failure as TJevUnprocessableEntityFailure).details;
        expect(details.map((detail) => detail.location), [
          ['body', 'questions', 'q0', 1],
          ['body', 'state'],
          isEmpty,
        ]);
        expect(details.map((detail) => detail.path), [
          'questions.q0.1',
          'state',
          '',
        ]);
        expect(details.map((detail) => detail.message), [
          'Field required',
          'Input should be a string',
          'Too many Questions',
        ]);
      },
    );

    test(
      'When its detail is not a list, then the failure holds no details',
      () async {
        final failure = await failureFor(
          http.Response('{"detail": "Invalid JSON"}', 422),
        );

        expect((failure as TJevUnprocessableEntityFailure).details, isEmpty);
      },
    );

    test(
      'When a location holds body after its first entry, then the path keeps '
      'that body and the location stays as TypeSafe sent it',
      () async {
        final failure = await failureFor(
          http.Response(
            '{"detail": ['
            '{"loc": ["body", "questions", "body", "options"], '
            '"msg": "Field required"}, '
            '{"loc": ["questions", "body"], "msg": "Field required"}'
            ']}',
            422,
          ),
        );

        final details = (failure as TJevUnprocessableEntityFailure).details;
        expect(details.map((detail) => detail.location), [
          ['body', 'questions', 'body', 'options'],
          ['questions', 'body'],
        ]);
        expect(details.map((detail) => detail.path), [
          'questions.body.options',
          'questions.body',
        ]);
      },
    );
  });

  group('Given a 429 response', () {
    Future<Duration?> retryAfterFor(Map<String, String> headers) async {
      final failure = await failureFor(
        http.Response('{"error": "Slow down"}', 429, headers: headers),
      );
      return (failure as TJevRateLimitFailure).retryAfter;
    }

    test('When it has retry-after-ms, then that is the delay', () async {
      expect(
        await retryAfterFor({'retry-after-ms': '1500'}),
        const Duration(milliseconds: 1500),
      );
    });

    test('When retry-after-ms has a fraction, then it is kept', () async {
      expect(
        await retryAfterFor({'retry-after-ms': '2.5'}),
        const Duration(microseconds: 2500),
      );
    });

    test(
      'When it has retry-after-ms and Retry-After, then retry-after-ms wins',
      () async {
        expect(
          await retryAfterFor({'retry-after-ms': '250', 'retry-after': '30'}),
          const Duration(milliseconds: 250),
        );
      },
    );

    test(
      'When it has Retry-After in seconds, then that is the delay',
      () async {
        expect(
          await retryAfterFor({'retry-after': '3'}),
          const Duration(seconds: 3),
        );
      },
    );

    test(
      'When retry-after-ms is invalid, then Retry-After gives the delay',
      () async {
        expect(
          await retryAfterFor({'retry-after-ms': 'soon', 'retry-after': '2'}),
          const Duration(seconds: 2),
        );
        expect(
          await retryAfterFor({'retry-after-ms': '-1', 'retry-after': '2'}),
          const Duration(seconds: 2),
        );
      },
    );

    test(
      'When it has Retry-After as an HTTP date, then the delay runs until '
      'that date',
      () async {
        final inOneHour = DateTime.now().toUtc().add(const Duration(hours: 1));

        final retryAfter = await retryAfterFor({
          'retry-after': formatHttpDate(inOneHour),
        });

        expect(retryAfter, lessThanOrEqualTo(const Duration(hours: 1)));
        expect(
          retryAfter,
          greaterThan(const Duration(minutes: 59, seconds: 58)),
        );
      },
    );

    test(
      'When Retry-After is an HTTP date in the past, then the delay is zero',
      () async {
        expect(
          await retryAfterFor({
            'retry-after': 'Wed, 21 Oct 2015 07:28:00 GMT',
          }),
          Duration.zero,
        );
      },
    );

    test(
      'When it has no delay header or an invalid one, then the delay is null',
      () async {
        expect(await retryAfterFor({}), isNull);
        expect(await retryAfterFor({'retry-after': 'later'}), isNull);
        expect(await retryAfterFor({'retry-after': '-5'}), isNull);
      },
    );
  });

  group('Given TypeSafe cannot be reached', () {
    test(
      'When the connection fails, then ask returns a connection failure',
      () async {
        final jev = TJev(
          apiKey: 'ts_key',
          httpClient: MockClient(
            (_) => throw http.ClientException('Connection refused'),
          ),
          environment: const {},
          retry: _noRetries,
        );

        final response = await jev.ask(state: 'Hi', questions: [_billing]);

        expect(
          response.error,
          isA<TJevConnectionFailure>().having(
            (failure) => failure.message,
            'message',
            'Connection error: Connection refused',
          ),
        );
      },
    );
  });

  group('Given TypeSafe does not answer', () {
    final silent = MockClient((_) => Completer<http.Response>().future);

    test(
      'When no timeout is set, then ask returns a timeout failure after 10 s',
      () {
        fakeAsync((async) {
          final jev = TJev(
            apiKey: 'ts_key',
            httpClient: silent,
            environment: const {},
            retry: _noRetries,
          );
          TurboResponse<TJevResult>? response;
          jev
              .ask(state: 'Hi', questions: [_billing])
              .then((value) => response = value);

          async.elapse(const Duration(milliseconds: 9999));
          expect(response, isNull);
          async.elapse(const Duration(milliseconds: 1));
          expect(
            response?.error,
            isA<TJevTimeoutFailure>().having(
              (failure) => failure.timeout,
              'timeout',
              const Duration(seconds: 10),
            ),
          );
        });
      },
    );

    test(
      'When the client sets a timeout, then ask returns a timeout failure '
      'after it',
      () async {
        final jev = TJev(
          apiKey: 'ts_key',
          httpClient: silent,
          environment: const {},
          retry: _noRetries,
          timeout: const Duration(milliseconds: 20),
        );

        final response = await jev.ask(state: 'Hi', questions: [_billing]);

        expect(
          response.error,
          isA<TJevTimeoutFailure>().having(
            (failure) => failure.timeout,
            'timeout',
            const Duration(milliseconds: 20),
          ),
        );
      },
    );

    test(
      'When a call sets a timeout, then it replaces the client timeout',
      () async {
        final jev = TJev(
          apiKey: 'ts_key',
          httpClient: silent,
          environment: const {},
          retry: _noRetries,
          timeout: const Duration(hours: 1),
        );

        final response = await jev.ask(
          state: 'Hi',
          questions: [_billing],
          timeout: const Duration(milliseconds: 20),
        );

        expect(
          response.error,
          isA<TJevTimeoutFailure>().having(
            (failure) => failure.timeout,
            'timeout',
            const Duration(milliseconds: 20),
          ),
        );
      },
    );

    test(
      'When the response body stops arriving, then ask returns a timeout '
      'failure',
      () async {
        final jev = TJev(
          apiKey: 'ts_key',
          httpClient: MockClient.streaming(
            (_, _) async => http.StreamedResponse(
              StreamController<List<int>>().stream,
              200,
            ),
          ),
          environment: const {},
          retry: _noRetries,
        );

        final response = await jev.ask(
          state: 'Hi',
          questions: [_billing],
          timeout: const Duration(milliseconds: 20),
        );

        expect(response.error, isA<TJevTimeoutFailure>());
      },
    );

    test('When a timeout is not positive, then it throws', () {
      expect(
        () => TJev(
          apiKey: 'ts_key',
          environment: const {},
          timeout: Duration.zero,
        ),
        throwsA(
          isA<TJevInvalidTimeoutException>()
              .having((error) => error.timeout, 'timeout', Duration.zero)
              .having(
                (error) => error.message,
                'message',
                'A timeout must be positive, not 0:00:00.000000.',
              ),
        ),
      );
      final jev = TJev(apiKey: 'ts_key', environment: const {});
      expect(
        () => jev.ask(
          state: 'Hi',
          questions: [_billing],
          timeout: const Duration(milliseconds: -1),
        ),
        throwsA(isA<TJevInvalidTimeoutException>()),
      );
      jev.close();
    });
  });

  group('Given a failed ask', () {
    Future<TurboResponse<TJevResult>> askThrough(
      http.Client client, {
      Duration? timeout,
      Future<void>? abortTrigger,
    }) {
      final jev = TJev(
        apiKey: 'ts_key',
        httpClient: client,
        environment: const {},
        retry: _noRetries,
      );
      return jev.ask(
        state: 'I was charged twice.',
        questions: [_billing],
        timeout: timeout,
        abortTrigger: abortTrigger,
      );
    }

    void expectFailMessage(TurboResponse<TJevResult> response) {
      final failure = response.error! as TJevFailure;
      expect(failure.message, isNotEmpty);
      expect(response.message, failure.message);
    }

    test(
      'When TypeSafe answers a non-2xx status, then the fail has the message '
      'of its HTTP failure',
      () async {
        final response = await askThrough(
          MockClient(
            (_) async => http.Response('{"error": "Unknown model"}', 400),
          ),
        );

        expect(response.error, isA<TJevHttpFailure>());
        expectFailMessage(response);
      },
    );

    test(
      'When a 2xx body does not fit the Request, then the fail has the '
      'message of its response validation failure',
      () async {
        final response = await askThrough(
          MockClient((_) async => http.Response('not json', 200)),
        );

        expect(response.error, isA<TJevResponseValidationFailure>());
        expectFailMessage(response);
      },
    );

    test(
      'When the connection fails, then the fail has the message of its '
      'connection failure',
      () async {
        final response = await askThrough(
          MockClient((_) => throw http.ClientException('Connection refused')),
        );

        expect(response.error, isA<TJevConnectionFailure>());
        expectFailMessage(response);
      },
    );

    test(
      'When the attempt times out, then the fail has the message of its '
      'timeout failure',
      () async {
        final response = await askThrough(
          MockClient((_) => Completer<http.Response>().future),
          timeout: const Duration(milliseconds: 20),
        );

        expect(response.error, isA<TJevTimeoutFailure>());
        expectFailMessage(response);
      },
    );

    test(
      'When the abort trigger completes, then the fail has the message of '
      'its aborted failure',
      () async {
        final response = await askThrough(
          MockClient((_) => Completer<http.Response>().future),
          abortTrigger: Future<void>.value(),
        );

        expect(response.error, isA<TJevAbortedFailure>());
        expectFailMessage(response);
      },
    );
  });
}
