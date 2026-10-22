@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/constants/jpeg_bytes.dart';
import 'support/services/fake_type_safe.dart';

const _billing = TJevNoul(instructions: 'Is this about billing?');

TJev _jevFor(
  http.Client client, {
  TJevLogLevel? logLevel,
  Map<String, String> environment = const {},
  String apiKey = 'ts_key',
  Map<String, String>? defaultHeaders,
}) => TJev(
  apiKey: apiKey,
  httpClient: client,
  environment: environment,
  logLevel: logLevel,
  defaultHeaders: defaultHeaders,
  retry: TJevRetryPolicy(jitter: 0),
);

/// A client on [client] that logs at debug with body redaction off.
TJev _unredactedJevFor(http.Client client) => TJev(
  apiKey: 'ts_key',
  httpClient: client,
  environment: const {},
  logLevel: TJevLogLevel.debug,
  redactLoggedBodies: false,
);

void main() {
  late List<LogRecord> records;
  late StreamSubscription<LogRecord> subscription;

  setUp(() {
    Logger.root.level = Level.ALL;
    records = [];
    subscription = Logger('turbo_jev').onRecord
        .where((record) => record.loggerName == 'turbo_jev')
        .listen(records.add);
  });

  tearDown(() async {
    await subscription.cancel();
    Logger.root.level = Level.INFO;
  });

  Iterable<Level> levels() => records.map((record) => record.level).toSet();

  Iterable<T> objectsOf<T>() => records.map((r) => r.object).whereType<T>();

  group('Given a log level in config and another in the environment', () {
    test('When a Request is sent, then the config level wins', () async {
      final typeSafe = FakeTypeSafe();

      await _jevFor(
        typeSafe.client,
        logLevel: TJevLogLevel.info,
        environment: const {'TYPESAFE_LOG_LEVEL': 'debug'},
      ).ask(state: 'I was charged twice.', questions: const [_billing]);

      expect(levels(), {Level.INFO});
    });
  });

  group('Given no log level in config', () {
    test(
      'When the environment sets debug, then the client logs at debug',
      () async {
        final typeSafe = FakeTypeSafe();

        await _jevFor(
          typeSafe.client,
          environment: const {'TYPESAFE_LOG_LEVEL': ' Debug '},
        ).ask(state: 'I was charged twice.', questions: const [_billing]);

        expect(levels(), {Level.FINE, Level.INFO});
      },
    );

    test(
      'When the environment sets warn, then the client logs at warning',
      () async {
        final typeSafe = FakeTypeSafe();

        await _jevFor(
          typeSafe.client,
          environment: const {'TYPESAFE_LOG_LEVEL': 'warn'},
        ).ask(state: 'I was charged twice.', questions: const [_billing]);

        expect(records, isEmpty);
      },
    );

    for (final environment in [
      const <String, String>{},
      const {'TYPESAFE_LOG_LEVEL': ' '},
      const {'TYPESAFE_LOG_LEVEL': 'verbose'},
    ]) {
      test(
        'When the environment holds $environment, then the client logs at '
        'warning and skips the info summary',
        () async {
          final typeSafe = FakeTypeSafe();

          await _jevFor(
            typeSafe.client,
            environment: environment,
          ).ask(state: 'I was charged twice.', questions: const [_billing]);

          expect(records, isEmpty);
        },
      );
    }
  });

  group('Given the log level off', () {
    test('When a Request fails, then the client logs nothing', () async {
      final typeSafe = FakeTypeSafe(respond: (_) => http.Response('{}', 400));

      await _jevFor(
        typeSafe.client,
        logLevel: TJevLogLevel.off,
        environment: const {'TYPESAFE_LOG_LEVEL': 'debug'},
      ).ask(state: 'I was charged twice.', questions: const [_billing]);

      expect(records, isEmpty);
    });

    test(
      'When a Request is retried and then fails, then the client logs '
      'nothing',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe(
            respond: (_) => http.Response('{}', 500),
          );
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.off).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 2));

          expect(typeSafe.requests, hasLength(3));
          expect(records, isEmpty);
        });
      },
    );
  });

  group('Given the log level warning', () {
    test(
      'When TypeSafe answers 500 and then 200, then the client logs one '
      'warning with the failed attempt, its failure and the delay',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe.answering([
            http.Response(
              jsonEncode({'error': 'overloaded'}),
              500,
              headers: const {'x-typesafe-request-id': 'req_500'},
            ),
            FakeTypeSafe.noulResponse(nouls: {'q0': 0.9}),
          ]);
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.warning).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 1));

          expect(levels(), {Level.WARNING});
          expect(
            objectsOf<TJevRetryLog>().single,
            isA<TJevRetryLog>()
                .having((l) => l.method, 'method', 'POST')
                .having((l) => l.path, 'path', '/v1/systemone')
                .having((l) => l.attempt, 'attempt', 1)
                .having(
                  (l) => l.failureType,
                  'failureType',
                  TJevInternalServerFailure,
                )
                .having((l) => l.message, 'message', 'overloaded')
                .having((l) => l.status, 'status', 500)
                .having((l) => l.requestId, 'requestId', 'req_500')
                .having(
                  (l) => l.delay,
                  'delay',
                  const Duration(milliseconds: 500),
                ),
          );
        });
      },
    );

    test(
      'When TypeSafe answers 429 twice and then 200, then the client logs a '
      'warning per Retry with the delay TypeSafe asks for',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe.answering([
            http.Response(
              '{}',
              429,
              headers: const {'retry-after-ms': '1500'},
            ),
            http.Response(
              '{}',
              429,
              headers: const {'retry-after-ms': '1500'},
            ),
            FakeTypeSafe.noulResponse(nouls: {'q0': 0.9}),
          ]);
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.warning).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 4));

          final logs = objectsOf<TJevRetryLog>().toList();
          expect(levels(), {Level.WARNING});
          expect(logs.map((l) => l.attempt), [1, 2]);
          expect(
            logs.map((l) => l.failureType),
            everyElement(TJevRateLimitFailure),
          );
          expect(logs.map((l) => l.status), everyElement(429));
          expect(
            logs.map((l) => l.delay),
            everyElement(const Duration(milliseconds: 1500)),
          );
        });
      },
    );

    test(
      'When the first attempt times out and the Retry succeeds, then the '
      'warning holds the timeout without a status',
      () {
        fakeAsync((async) {
          var requests = 0;
          final client = MockClient((request) {
            if (requests++ == 0) return Completer<http.Response>().future;
            return Future.value(
              FakeTypeSafe.noulResponse(nouls: {'q0': 0.9}),
            );
          });
          _jevFor(client, logLevel: TJevLogLevel.warning).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 11));

          expect(
            objectsOf<TJevRetryLog>().single,
            isA<TJevRetryLog>()
                .having((l) => l.attempt, 'attempt', 1)
                .having(
                  (l) => l.failureType,
                  'failureType',
                  TJevTimeoutFailure,
                )
                .having((l) => l.status, 'status', isNull)
                .having((l) => l.requestId, 'requestId', isNull),
          );
          expect(objectsOf<TJevFailureLog>(), isEmpty);
        });
      },
    );

    test(
      'When every attempt fails with 500, then the client logs a warning per '
      'Retry and one error for the last attempt',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe(
            respond: (_) => http.Response(
              jsonEncode({'error': 'overloaded'}),
              500,
              headers: const {'x-typesafe-request-id': 'req_500'},
            ),
          );
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.warning).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 2));

          expect(levels(), {Level.WARNING, Level.SEVERE});
          expect(objectsOf<TJevRetryLog>().map((l) => l.attempt), [1, 2]);
          expect(
            records.where((r) => r.level == Level.SEVERE).single.object,
            isA<TJevFailureLog>()
                .having((l) => l.method, 'method', 'POST')
                .having((l) => l.path, 'path', '/v1/systemone')
                .having((l) => l.attempt, 'attempt', 3)
                .having(
                  (l) => l.failureType,
                  'failureType',
                  TJevInternalServerFailure,
                )
                .having((l) => l.message, 'message', 'overloaded')
                .having((l) => l.status, 'status', 500)
                .having((l) => l.requestId, 'requestId', 'req_500'),
          );
        });
      },
    );

    test(
      'When TypeSafe answers 400, then the client logs one error without a '
      'warning',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response('{}', 400),
        );

        await _jevFor(
          typeSafe.client,
          logLevel: TJevLogLevel.warning,
        ).models();

        expect(levels(), {Level.SEVERE});
        expect(
          objectsOf<TJevFailureLog>().single,
          isA<TJevFailureLog>()
              .having((l) => l.method, 'method', 'GET')
              .having((l) => l.path, 'path', '/v1/models')
              .having((l) => l.attempt, 'attempt', 1)
              .having(
                (l) => l.failureType,
                'failureType',
                TJevBadRequestFailure,
              )
              .having((l) => l.status, 'status', 400),
        );
      },
    );

    test(
      'When the abort trigger completes while the client waits to retry, '
      'then the client logs the warning and no error',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe(
            respond: (_) => http.Response('{}', 503),
          );
          final abort = Completer<void>();
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.warning).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
            abortTrigger: abort.future,
          );

          async.elapse(const Duration(milliseconds: 200));
          abort.complete();
          async.flushMicrotasks();

          expect(objectsOf<TJevRetryLog>(), hasLength(1));
          expect(objectsOf<TJevFailureLog>(), isEmpty);
        });
      },
    );

    test(
      'When the failure body holds a secret field and no message, then the '
      'error message has its value replaced',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response(
            jsonEncode({'token': 'secret-1', 'status': 'down'}),
            500,
          ),
        );

        await _jevFor(
          typeSafe.client,
          logLevel: TJevLogLevel.warning,
        ).models(retry: TJevRetryPolicy(maxRetries: 0));

        expect(
          objectsOf<TJevFailureLog>().single.message,
          '{"token":"***","status":"down"}',
        );
      },
    );

    test(
      'When body redaction is off, then the error message is the message of '
      'the failure',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response(
            jsonEncode({'token': 'secret-1', 'status': 'down'}),
            500,
          ),
        );

        final response = await _unredactedJevFor(
          typeSafe.client,
        ).models(retry: TJevRetryPolicy(maxRetries: 0));

        expect(
          objectsOf<TJevFailureLog>().single.message,
          ((response as Fail).error as TJevFailure).message,
        );
      },
    );
  });

  group('Given the log level error', () {
    test(
      'When every attempt fails with 500, then the client logs only the '
      'error',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe(
            respond: (_) => http.Response('{}', 500),
          );
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.error).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 2));

          expect(levels(), {Level.SEVERE});
          expect(
            objectsOf<TJevFailureLog>().single,
            isA<TJevFailureLog>()
                .having((l) => l.attempt, 'attempt', 3)
                .having(
                  (l) => l.failureType,
                  'failureType',
                  TJevInternalServerFailure,
                ),
          );
        });
      },
    );

    test('When a Retry succeeds, then the client logs nothing', () {
      fakeAsync((async) {
        final typeSafe = FakeTypeSafe.answering([
          http.Response('{}', 500),
          FakeTypeSafe.noulResponse(nouls: {'q0': 0.9}),
        ]);
        _jevFor(typeSafe.client, logLevel: TJevLogLevel.error).ask(
          state: 'I was charged twice.',
          questions: const [_billing],
        );

        async.elapse(const Duration(seconds: 1));

        expect(records, isEmpty);
      });
    });
  });

  group('Given the log level info', () {
    test(
      'When TypeSafe answers 503 and then 200, then the client logs one '
      'summary with the retry, the status and the request id',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe.answering([
            http.Response('{}', 503),
            FakeTypeSafe.noulResponse(
              nouls: {'q0': 0.9},
              headers: const {'x-typesafe-request-id': 'req_42'},
            ),
          ]);
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.info).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 1));

          expect(levels(), {Level.WARNING, Level.INFO});
          expect(
            objectsOf<TJevRequestSummary>().single,
            isA<TJevRequestSummary>()
                .having((s) => s.method, 'method', 'POST')
                .having((s) => s.path, 'path', '/v1/systemone')
                .having((s) => s.status, 'status', 200)
                .having((s) => s.requestId, 'requestId', 'req_42')
                .having((s) => s.retries, 'retries', 1)
                .having((s) => s.timeouts, 'timeouts', 0)
                .having((s) => s.aborted, 'aborted', isFalse)
                .having(
                  (s) => s.elapsed,
                  'elapsed',
                  const Duration(milliseconds: 500),
                ),
          );
        });
      },
    );

    test(
      'When the first attempt times out and the Retry succeeds, then the '
      'summary counts the timeout',
      () {
        fakeAsync((async) {
          var requests = 0;
          final client = MockClient((request) {
            if (requests++ == 0) return Completer<http.Response>().future;
            return Future.value(
              FakeTypeSafe.noulResponse(nouls: {'q0': 0.9}),
            );
          });
          _jevFor(client, logLevel: TJevLogLevel.info).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 11));

          expect(
            objectsOf<TJevRequestSummary>().single,
            isA<TJevRequestSummary>()
                .having((s) => s.status, 'status', 200)
                .having((s) => s.retries, 'retries', 1)
                .having((s) => s.timeouts, 'timeouts', 1)
                .having((s) => s.aborted, 'aborted', isFalse),
          );
        });
      },
    );

    test(
      'When the abort trigger completes while the client waits to retry, '
      'then the summary says the Request was aborted',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe(
            respond: (_) => http.Response(
              '{}',
              503,
              headers: const {'x-typesafe-request-id': 'req_503'},
            ),
          );
          final abort = Completer<void>();
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.info).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
            abortTrigger: abort.future,
          );

          async.elapse(const Duration(milliseconds: 200));
          abort.complete();
          async.flushMicrotasks();

          expect(
            objectsOf<TJevRequestSummary>().single,
            isA<TJevRequestSummary>()
                .having((s) => s.status, 'status', 503)
                .having((s) => s.requestId, 'requestId', 'req_503')
                .having((s) => s.retries, 'retries', 0)
                .having((s) => s.timeouts, 'timeouts', 0)
                .having((s) => s.aborted, 'aborted', isTrue),
          );
        });
      },
    );

    test(
      'When the abort trigger completes before TypeSafe answers, then the '
      'summary says the Request was aborted without a response',
      () {
        fakeAsync((async) {
          final client = MockClient(
            (_) => Completer<http.Response>().future,
          );
          final abort = Completer<void>();
          _jevFor(client, logLevel: TJevLogLevel.info).models(
            abortTrigger: abort.future,
          );

          async.elapse(const Duration(seconds: 1));
          abort.complete();
          async.flushMicrotasks();

          expect(
            objectsOf<TJevRequestSummary>().single,
            isA<TJevRequestSummary>()
                .having((s) => s.method, 'method', 'GET')
                .having((s) => s.path, 'path', '/v1/models')
                .having((s) => s.status, 'status', isNull)
                .having((s) => s.requestId, 'requestId', isNull)
                .having((s) => s.retries, 'retries', 0)
                .having((s) => s.aborted, 'aborted', isTrue),
          );
        });
      },
    );
  });

  group('Given the log level debug', () {
    test(
      'When the Request body is longer than 4096 bytes, then the request '
      'record holds its first 4096 bytes uncompressed and counts the rest',
      () async {
        final typeSafe = FakeTypeSafe();

        await _jevFor(typeSafe.client, logLevel: TJevLogLevel.debug).ask(
          state: 'a' * 5000,
          questions: const [_billing],
        );

        final sent = jsonEncode(FakeTypeSafe.bodyOf(typeSafe.lastRequest));
        expect(
          objectsOf<TJevRequestLog>().single,
          isA<TJevRequestLog>()
              .having((l) => l.attempt, 'attempt', 1)
              .having((l) => l.body, 'body', sent.substring(0, 4096))
              .having(
                (l) => l.omittedBodyBytes,
                'omittedBodyBytes',
                sent.length - 4096,
              ),
        );
      },
    );

    test(
      'When the response body is longer than 4096 bytes, then the response '
      'record holds its first 4096 bytes and counts the rest',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response('x' * 5000, 500),
        );

        await _jevFor(
          typeSafe.client,
          logLevel: TJevLogLevel.debug,
        ).models(retry: TJevRetryPolicy(maxRetries: 0));

        expect(
          objectsOf<TJevResponseLog>().single,
          isA<TJevResponseLog>()
              .having((l) => l.status, 'status', 500)
              .having((l) => l.body, 'body', 'x' * 4096)
              .having((l) => l.omittedBodyBytes, 'omittedBodyBytes', 904),
        );
      },
    );

    test(
      'When the bodies are at most 4096 bytes, then the records hold them '
      'whole',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response('y' * 4096, 500),
        );

        await _jevFor(
          typeSafe.client,
          logLevel: TJevLogLevel.debug,
        ).models(retry: TJevRetryPolicy(maxRetries: 0));

        expect(
          objectsOf<TJevRequestLog>().single,
          isA<TJevRequestLog>()
              .having((l) => l.body, 'body', isNull)
              .having((l) => l.omittedBodyBytes, 'omittedBodyBytes', 0),
        );
        expect(
          objectsOf<TJevResponseLog>().single,
          isA<TJevResponseLog>()
              .having((l) => l.body, 'body', 'y' * 4096)
              .having((l) => l.omittedBodyBytes, 'omittedBodyBytes', 0),
        );
      },
    );

    test(
      'When a Request is retried, then each attempt logs its number and '
      'each response its status',
      () {
        fakeAsync((async) {
          final typeSafe = FakeTypeSafe.answering([
            http.Response('{}', 503),
            FakeTypeSafe.noulResponse(nouls: {'q0': 0.9}),
          ]);
          _jevFor(typeSafe.client, logLevel: TJevLogLevel.debug).ask(
            state: 'I was charged twice.',
            questions: const [_billing],
          );

          async.elapse(const Duration(seconds: 1));

          expect(objectsOf<TJevRequestLog>().map((l) => l.attempt), [1, 2]);
          expect(objectsOf<TJevResponseLog>().map((l) => l.status), [
            503,
            200,
          ]);
        });
      },
    );
  });

  group('Given secret headers on the Request and on the response', () {
    const apiKey = 'ts_live_key_1234567890';
    const secrets = {
      'Proxy-Authorization': 'Basic cHJveHk6c2VjcmV0MQ==',
      'Cookie': 'session=cookie-secret-2',
      'X-Session-Token': 'token-secret-3',
      'Client-Secret': 'client-secret-4',
      'X-Goog-Api-Key': 'api-key-secret-5',
    };
    const responseSecrets = {
      'set-cookie': 'session=set-cookie-secret-6',
      'x-refresh-token': 'refresh-secret-7',
    };

    late FakeTypeSafe typeSafe;

    setUp(() {
      var requests = 0;
      typeSafe = FakeTypeSafe(
        respond: (request) => requests++ == 0
            ? http.Response('{}', 503, headers: responseSecrets)
            : FakeTypeSafe.noulResponse(
                nouls: {'q0': 0.9},
                headers: {
                  ...responseSecrets,
                  'x-typesafe-request-id': 'req_123',
                },
              ),
      );
    });

    void askWithSecrets(FakeAsync async) {
      _jevFor(
        typeSafe.client,
        apiKey: apiKey,
        logLevel: TJevLogLevel.debug,
        defaultHeaders: const {'X-Trace': 'trace-1'},
      ).ask(
        state: 'I was charged twice.',
        questions: const [_billing],
        headers: secrets,
      );
      async.elapse(const Duration(seconds: 1));
    }

    test(
      'When the client logs at debug, then each secret request header is '
      'replaced in full and the other headers are kept',
      () {
        fakeAsync((async) {
          askWithSecrets(async);

          for (final log in objectsOf<TJevRequestLog>()) {
            final headers = {
              for (final MapEntry(:key, :value) in log.headers.entries)
                key.toLowerCase(): value,
            };
            expect(headers['authorization'], '***');
            for (final name in secrets.keys) {
              expect(headers[name.toLowerCase()], '***', reason: name);
            }
            expect(headers['x-trace'], 'trace-1');
            expect(headers['accept'], 'application/json');
          }
        });
      },
    );

    test(
      'When the client logs at debug, then each secret response header is '
      'replaced in full and the other headers are kept',
      () {
        fakeAsync((async) {
          askWithSecrets(async);

          final headers = objectsOf<TJevResponseLog>().last.headers;
          expect(headers['set-cookie'], '***');
          expect(headers['x-refresh-token'], '***');
          expect(headers['x-typesafe-request-id'], 'req_123');
        });
      },
    );

    test(
      'When the client logs at debug, then no secret reaches a log record',
      () {
        fakeAsync((async) {
          askWithSecrets(async);

          expect(records, isNotEmpty);
          for (final record in records) {
            final logged = '${record.message} ${record.object} ${record.error}';
            for (final secret in [
              apiKey,
              ...secrets.values,
              ...responseSecrets.values,
            ]) {
              expect(logged, isNot(contains(secret)));
            }
          }
        });
      },
    );
  });

  group('Given secret fields in JSON bodies', () {
    /// One field per secret name part, each in another case and spelling.
    const secretFields = {
      'access_token': 'hidden-1',
      'clientSecret': 'hidden-2',
      'PASSWORD': 'hidden-3',
      'x_api_key': 'hidden-4',
      'Api-Key': 'hidden-5',
      'apiKey': 'hidden-6',
    };
    const redactedFields = {
      'access_token': '***',
      'clientSecret': '***',
      'PASSWORD': '***',
      'x_api_key': '***',
      'Api-Key': '***',
      'apiKey': '***',
    };
    final responseBody = jsonEncode({
      ...secretFields,
      'status': 'ok',
      'items': [
        {...secretFields, 'id': 1},
      ],
      'meta': {
        'inner': {...secretFields, 'name': 'jev'},
        'count': 2,
      },
    });
    const state = {
      'user': {...secretFields, 'name': 'Ann'},
      'sessions': [secretFields, 'plain'],
    };

    Future<FakeTypeSafe> askAtDebug({bool redactionOff = false}) async {
      final typeSafe = FakeTypeSafe(
        respond: (_) => http.Response(responseBody, 500),
      );
      final jev = redactionOff
          ? _unredactedJevFor(typeSafe.client)
          : _jevFor(typeSafe.client, logLevel: TJevLogLevel.debug);
      await jev.ask(
        state: state,
        questions: const [_billing],
        retry: TJevRetryPolicy(maxRetries: 0),
      );
      return typeSafe;
    }

    test(
      'When the client logs a response at debug, then each secret field is '
      'redacted at top level and inside lists and maps, and the other '
      'fields stay',
      () async {
        await askAtDebug();

        final body = jsonDecode(objectsOf<TJevResponseLog>().single.body!);
        expect(body, {
          ...redactedFields,
          'status': 'ok',
          'items': [
            {...redactedFields, 'id': 1},
          ],
          'meta': {
            'inner': {...redactedFields, 'name': 'jev'},
            'count': 2,
          },
        });
      },
    );

    test(
      'When the client logs a Request at debug, then each secret field in '
      'its State is redacted and the other fields stay',
      () async {
        final typeSafe = await askAtDebug();

        final logged =
            jsonDecode(
                  objectsOf<TJevRequestLog>().single.body!,
                )
                as Map<String, Object?>;
        expect(logged['state'], {
          'user': {...redactedFields, 'name': 'Ann'},
          'sessions': [redactedFields, 'plain'],
        });
        expect(
          {...logged}..remove('state'),
          {...FakeTypeSafe.bodyOf(typeSafe.lastRequest)}..remove('state'),
        );
      },
    );

    test(
      'When the client logs at debug, then no secret value reaches a log '
      'record',
      () async {
        await askAtDebug();

        expect(records, isNotEmpty);
        for (final record in records) {
          final logged = '${record.message} ${record.object} ${record.error}';
          for (final secret in secretFields.values) {
            expect(logged, isNot(contains(secret)));
          }
        }
      },
    );

    test(
      'When a secret field makes the body longer than 4096 bytes, then it is '
      'redacted before the body is cut',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response(
            jsonEncode({'token': 'h' * 5000, 'status': 'ok'}),
            500,
          ),
        );

        await _jevFor(
          typeSafe.client,
          logLevel: TJevLogLevel.debug,
        ).models(retry: TJevRetryPolicy(maxRetries: 0));

        expect(
          objectsOf<TJevResponseLog>().single,
          isA<TJevResponseLog>()
              .having((l) => l.body, 'body', '{"token":"***","status":"ok"}')
              .having((l) => l.omittedBodyBytes, 'omittedBodyBytes', 0),
        );
      },
    );

    test(
      'When a JSON body holds no secret field, then it is logged as it came',
      () async {
        const body = '{"status": "ok",  "items": [1, 2.0]}';
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response(body, 500),
        );

        await _jevFor(
          typeSafe.client,
          logLevel: TJevLogLevel.debug,
        ).models(retry: TJevRetryPolicy(maxRetries: 0));

        expect(objectsOf<TJevResponseLog>().single.body, body);
      },
    );

    test(
      'When body redaction is off, then the records hold the bodies '
      'unchanged',
      () async {
        final typeSafe = await askAtDebug(redactionOff: true);

        expect(
          objectsOf<TJevRequestLog>().single.body,
          jsonEncode(FakeTypeSafe.bodyOf(typeSafe.lastRequest)),
        );
        expect(objectsOf<TJevResponseLog>().single.body, responseBody);
      },
    );

    test(
      'When body redaction is off, then secret headers are still redacted',
      () async {
        final typeSafe = FakeTypeSafe(
          respond: (_) => http.Response(
            '{}',
            500,
            headers: {'x-refresh-token': 'refresh-secret'},
          ),
        );

        await _unredactedJevFor(
          typeSafe.client,
        ).models(retry: TJevRetryPolicy(maxRetries: 0));

        final requestHeaders = objectsOf<TJevRequestLog>().single.headers;
        expect(
          requestHeaders.entries
              .where((header) => header.key.toLowerCase() == 'authorization')
              .single
              .value,
          '***',
        );
        expect(
          objectsOf<TJevResponseLog>().single.headers['x-refresh-token'],
          '***',
        );
      },
    );
  });

  group('Given a Request with an Image and a secret field in its State', () {
    const secret = 'synthetic-secret';
    late TJevImage photo;

    setUp(() => photo = TJevImage(jpegBytes));

    Future<FakeTypeSafe> askAtDebug({bool redactionOff = false}) async {
      final typeSafe = FakeTypeSafe(respond: (_) => http.Response('{}', 500));
      final jev = redactionOff
          ? _unredactedJevFor(typeSafe.client)
          : _jevFor(typeSafe.client, logLevel: TJevLogLevel.debug);
      await jev.ask(
        state: {'apiKey': secret, 'photo': photo},
        questions: const [_billing],
        retry: TJevRetryPolicy(maxRetries: 0),
      );
      return typeSafe;
    }

    /// The JSON of the `request` part of the logged multipart body.
    Map<String, Object?> loggedRequestPart() =>
        jsonDecode(objectsOf<TJevRequestLog>().single.body!)
            as Map<String, Object?>;

    test(
      'When the client logs at debug, then no record holds the secret and '
      'the logged request part shows it redacted',
      () async {
        await askAtDebug();

        expect(records, isNotEmpty);
        for (final record in records) {
          final logged = '${record.message} ${record.object} ${record.error}';
          expect(logged, isNot(contains(secret)));
        }
        expect(loggedRequestPart()['state'], {
          'apiKey': '***',
          'photo': photo.reference,
        });
      },
    );

    test(
      'When the client logs at debug, then the logged body is the redacted '
      'request part only and counts the other parts as left out',
      () async {
        final typeSafe = await askAtDebug();

        final sent = typeSafe.lastRequest;
        final sentJson = FakeTypeSafe.partsOf(sent).first.bytes;
        final redactedJson = jsonEncode({
          ...FakeTypeSafe.bodyOf(sent),
          'state': {'apiKey': '***', 'photo': photo.reference},
        });
        final log = objectsOf<TJevRequestLog>().single;
        expect(log.body, redactedJson);
        expect(
          log.omittedBodyBytes,
          sent.bodyBytes.length - sentJson.length,
        );
      },
    );

    test(
      'When body redaction is off, then the logged request part holds the '
      'secret as sent',
      () async {
        await askAtDebug(redactionOff: true);

        expect(loggedRequestPart()['state'], {
          'apiKey': secret,
          'photo': photo.reference,
        });
      },
    );
  });
}
