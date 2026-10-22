import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

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

/// A fake TypeSafe that answers the Requests in order with [responses] and
/// every later Request with the last of them.
FakeTypeSafe _answering(List<http.Response> responses) {
  var next = 0;
  return FakeTypeSafe(
    respond: (_) => responses[min(next++, responses.length - 1)],
  );
}

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
  });

  group('Given the log level info', () {
    test(
      'When TypeSafe answers 503 and then 200, then the client logs one '
      'summary with the retry, the status and the request id',
      () {
        fakeAsync((async) {
          final typeSafe = _answering([
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

          expect(levels(), {Level.INFO});
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
      'When the Abort Trigger completes while the client waits to retry, '
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
      'When the Abort Trigger completes before TypeSafe answers, then the '
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
          final typeSafe = _answering([
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
}
