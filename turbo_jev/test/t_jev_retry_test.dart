import 'dart:async';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

const _billing = TJevNoul(instructions: 'Is this about billing?');

final _success = FakeTypeSafe.noulResponse(nouls: {'q0': 0.9});

/// A fake TypeSafe that answers the Requests in order with [responses] and
/// every later Request with the last of them.
FakeTypeSafe _answering(List<http.Response> responses) {
  var next = 0;
  return FakeTypeSafe(
    respond: (_) => responses[min(next++, responses.length - 1)],
  );
}

/// A fake TypeSafe that answers every Request with [status].
FakeTypeSafe _failingWith(int status, {Map<String, String>? headers}) =>
    _answering([http.Response('{}', status, headers: headers ?? const {})]);

/// A policy without jitter, so that each backoff is exact.
TJevRetryPolicy _exactPolicy({int maxRetries = 2, Duration? budget}) =>
    TJevRetryPolicy(maxRetries: maxRetries, jitter: 0, budget: budget);

/// A call to [TJev.ask] whose response is read under fake time.
final class _Call {
  _Call(
    TJev jev, {
    String state = 'I was charged twice.',
    TJevRetryPolicy? retry,
    Future<void>? abortTrigger,
    Map<String, String>? headers,
  }) {
    jev
        .ask(
          state: state,
          questions: [_billing],
          retry: retry,
          abortTrigger: abortTrigger,
          headers: headers,
        )
        .then((value) => response = value);
  }

  TurboResponse<TJevResult>? response;

  Object? get error => response?.error;
}

TJev _jevFor(http.Client client, {TJevRetryPolicy? retry}) => TJev(
  apiKey: 'ts_key',
  httpClient: client,
  environment: const {},
  retry: retry,
);

void main() {
  group('Given the default retry policy', () {
    test(
      'When TypeSafe answers 503 and then 200, then ask retries after the '
      'backoff and succeeds',
      () {
        fakeAsync((async) {
          final typeSafe = _answering([http.Response('{}', 503), _success]);
          final call = _Call(_jevFor(typeSafe.client));

          async.elapse(const Duration(milliseconds: 374));
          expect(typeSafe.requests, hasLength(1));
          async.elapse(const Duration(milliseconds: 126));
          expect(typeSafe.requests, hasLength(2));
          expect(call.response?.isSuccess, isTrue);
        });
      },
    );

    for (final status in [
      408,
      429,
      for (var status = 500; status < 600; status++) status,
    ]) {
      test(
        'When TypeSafe keeps answering $status, then ask sends the Request '
        'three times and returns its failure',
        () {
          fakeAsync((async) {
            final typeSafe = _failingWith(status);
            final call = _Call(_jevFor(typeSafe.client));

            async.elapse(const Duration(seconds: 2));

            expect(typeSafe.requests, hasLength(3));
            expect(
              call.error,
              isA<TJevHttpFailure>().having((f) => f.status, 'status', status),
            );
          });
        },
      );
    }

    for (final status in [400, 401, 403, 404, 409, 413, 415, 422]) {
      test(
        'When TypeSafe answers $status, then ask sends the Request once',
        () {
          fakeAsync((async) {
            final typeSafe = _failingWith(status);
            final call = _Call(_jevFor(typeSafe.client));

            async.elapse(const Duration(seconds: 30));

            expect(typeSafe.requests, hasLength(1));
            expect(
              call.error,
              isA<TJevHttpFailure>().having((f) => f.status, 'status', status),
            );
          });
        },
      );
    }

    test(
      'When the connection keeps failing, then ask sends the Request three '
      'times and returns a connection failure',
      () {
        fakeAsync((async) {
          var requests = 0;
          final client = MockClient((_) {
            requests++;
            throw http.ClientException('Connection refused');
          });
          final call = _Call(_jevFor(client));

          async.elapse(const Duration(seconds: 2));

          expect(requests, 3);
          expect(call.error, isA<TJevConnectionFailure>());
        });
      },
    );

    test(
      'When every attempt times out, then ask sends the Request three times '
      'and returns a timeout failure',
      () {
        fakeAsync((async) {
          var requests = 0;
          final client = MockClient((_) {
            requests++;
            return Completer<http.Response>().future;
          });
          final call = _Call(_jevFor(client));

          async.elapse(const Duration(seconds: 10));
          expect(requests, 1);
          async.elapse(const Duration(seconds: 12));
          expect(requests, 3);
          expect(call.response, isNull);
          async.elapse(const Duration(seconds: 10));
          expect(call.error, isA<TJevTimeoutFailure>());
        });
      },
    );

    test(
      'When the Request is retried, then each retry carries its number in '
      'X-TypeSafe-Retry-Count and a caller cannot set it',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          _Call(
            _jevFor(typeSafe.client),
            headers: const {'X-TypeSafe-Retry-Count': '7'},
          );

          async.elapse(const Duration(seconds: 2));

          expect(
            typeSafe.requests.map(
              (request) => request.headers['X-TypeSafe-Retry-Count'],
            ),
            [null, '1', '2'],
          );
        });
      },
    );

    test(
      'When a compressed Request is retried, then every attempt sends the '
      'same compressed bytes',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          _Call(_jevFor(typeSafe.client), state: 'a' * 2000);

          async.elapse(const Duration(seconds: 2));

          expect(typeSafe.requests, hasLength(3));
          for (final request in typeSafe.requests) {
            expect(request.headers['Content-Encoding'], 'gzip');
            expect(request.bodyBytes, typeSafe.requests.first.bodyBytes);
          }
        });
      },
    );
  });

  group('Given a backoff without jitter', () {
    test(
      'When TypeSafe keeps answering 503, then each wait doubles from 500 ms '
      'up to 5 s',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          _Call(
            _jevFor(typeSafe.client),
            retry: _exactPolicy(maxRetries: 6),
          );

          // Retries are due at 0.5, 1.5, 3.5, 7.5, 12.5 and 17.5 s.
          for (final (dueAt, requests) in [
            (500, 2),
            (1500, 3),
            (3500, 4),
            (7500, 5),
            (12500, 6),
            (17500, 7),
          ]) {
            final now = async.elapsed.inMilliseconds;
            async.elapse(Duration(milliseconds: dueAt - now - 1));
            expect(typeSafe.requests, hasLength(requests - 1));
            async.elapse(const Duration(milliseconds: 1));
            expect(typeSafe.requests, hasLength(requests));
          }
        });
      },
    );
  });

  group('Given the default jitter of 0.25', () {
    test(
      'When TypeSafe keeps answering 503, then up to a quarter of each '
      'backoff is taken off: the waits lie within 375-500 ms and 750-1000 ms',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          _Call(_jevFor(typeSafe.client));

          /// The fake time in ms at which TypeSafe has [count] Requests.
          int msUntilRequests(int count) {
            while (typeSafe.requests.length < count) {
              async.elapse(const Duration(milliseconds: 1));
            }
            return async.elapsed.inMilliseconds;
          }

          final firstRetryAt = msUntilRequests(2);
          final secondRetryAt = msUntilRequests(3);

          // Each moment is seen within 1 ms after it happens.
          expect(firstRetryAt, inInclusiveRange(375, 500));
          expect(secondRetryAt - firstRetryAt, inInclusiveRange(749, 1001));
        });
      },
    );
  });

  group('Given TypeSafe asks for a delay', () {
    test(
      'When a 503 holds retry-after-ms 1500, then the retry waits 1.5 s',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(
            503,
            headers: {'retry-after-ms': '1500'},
          );
          _Call(_jevFor(typeSafe.client));

          async.elapse(const Duration(milliseconds: 1499));
          expect(typeSafe.requests, hasLength(1));
          async.elapse(const Duration(milliseconds: 1));
          expect(typeSafe.requests, hasLength(2));
        });
      },
    );

    test('When a 429 holds Retry-After 60, then the retry waits 60 s', () {
      fakeAsync((async) {
        final typeSafe = _failingWith(429, headers: {'retry-after': '60'});
        _Call(
          _jevFor(typeSafe.client),
          retry: TJevRetryPolicy(budget: null),
        );

        async.elapse(const Duration(milliseconds: 59999));
        expect(typeSafe.requests, hasLength(1));
        async.elapse(const Duration(milliseconds: 1));
        expect(typeSafe.requests, hasLength(2));
      });
    });

    test(
      'When a 429 holds Retry-After 61, then the delay is over the 60 s cap '
      'and the retry follows the backoff',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(429, headers: {'retry-after': '61'});
          _Call(
            _jevFor(typeSafe.client),
            retry: TJevRetryPolicy(jitter: 0, budget: null),
          );

          async.elapse(const Duration(milliseconds: 500));

          expect(typeSafe.requests, hasLength(2));
        });
      },
    );

    test(
      'When the policy does not respect the delay, then the retry follows '
      'the backoff',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503, headers: {'retry-after': '10'});
          _Call(
            _jevFor(typeSafe.client),
            retry: TJevRetryPolicy(jitter: 0, respectRetryAfter: false),
          );

          async.elapse(const Duration(milliseconds: 500));

          expect(typeSafe.requests, hasLength(2));
        });
      },
    );
  });

  group('Given the total budget', () {
    test(
      'When the next wait would reach the default 30 s, then ask stops and '
      'returns the last failure',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503, headers: {'retry-after': '20'});
          final call = _Call(
            _jevFor(typeSafe.client),
            retry: TJevRetryPolicy(maxRetries: 5),
          );

          async.elapse(const Duration(seconds: 20));
          expect(typeSafe.requests, hasLength(2));
          expect(
            call.error,
            isA<TJevInternalServerFailure>().having(
              (f) => f.status,
              'status',
              503,
            ),
          );
          async.elapse(const Duration(minutes: 5));
          expect(typeSafe.requests, hasLength(2));
        });
      },
    );

    test(
      'When the budget is 1 s, then ask stops before the wait that would '
      'reach it',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          final call = _Call(
            _jevFor(typeSafe.client),
            retry: _exactPolicy(
              maxRetries: 5,
              budget: const Duration(seconds: 1),
            ),
          );

          async.elapse(const Duration(seconds: 10));

          // 0 ms + 500 ms is within 1 s; 500 ms + 1 s reaches it.
          expect(typeSafe.requests, hasLength(2));
          expect(call.error, isA<TJevInternalServerFailure>());
        });
      },
    );

    test('When the budget is off, then ask uses every retry', () {
      fakeAsync((async) {
        final typeSafe = _failingWith(503, headers: {'retry-after': '20'});
        _Call(
          _jevFor(typeSafe.client),
          retry: TJevRetryPolicy(maxRetries: 5, budget: null),
        );

        async.elapse(const Duration(minutes: 5));

        expect(typeSafe.requests, hasLength(6));
      });
    });
  });

  group('Given a predicate', () {
    test(
      'When it returns true for a 400, then the 400 is retried',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(400);
          _Call(
            _jevFor(typeSafe.client),
            retry: TJevRetryPolicy(
              predicate: (failure) => failure is TJevBadRequestFailure,
            ),
          );

          async.elapse(const Duration(seconds: 2));

          expect(typeSafe.requests, hasLength(3));
        });
      },
    );

    test(
      'When it returns false for a 503, then the 503 is still retried by '
      'its status',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          _Call(
            _jevFor(typeSafe.client),
            retry: TJevRetryPolicy(predicate: (_) => false),
          );

          async.elapse(const Duration(seconds: 2));

          expect(typeSafe.requests, hasLength(3));
        });
      },
    );

    test(
      'When it is the only rule, then only the failures it picks are retried',
      () {
        fakeAsync((async) {
          final typeSafe = _answering([
            http.Response('{}', 409),
            http.Response('{}', 503),
          ]);
          final call = _Call(
            _jevFor(typeSafe.client),
            retry: TJevRetryPolicy(
              statuses: const {},
              retryConnectionFailures: false,
              retryTimeouts: false,
              predicate: (failure) =>
                  failure is TJevHttpFailure && failure.status == 409,
            ),
          );

          async.elapse(const Duration(seconds: 2));

          expect(typeSafe.requests, hasLength(2));
          expect(
            call.error,
            isA<TJevHttpFailure>().having((f) => f.status, 'status', 503),
          );
        });
      },
    );
  });

  group('Given a client policy and a call policy', () {
    test(
      'When the client retries nothing and the call retries twice, then the '
      'call policy applies',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          _Call(
            _jevFor(
              typeSafe.client,
              retry: TJevRetryPolicy(maxRetries: 0),
            ),
            retry: TJevRetryPolicy(),
          );

          async.elapse(const Duration(seconds: 2));

          expect(typeSafe.requests, hasLength(3));
        });
      },
    );

    test(
      'When the client retries a 400 by its predicate and the call policy '
      'has none, then the call policy replaces the client policy whole',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(400);
          _Call(
            _jevFor(
              typeSafe.client,
              retry: TJevRetryPolicy(predicate: (_) => true),
            ),
            retry: TJevRetryPolicy(),
          );

          async.elapse(const Duration(seconds: 2));

          expect(typeSafe.requests, hasLength(1));
        });
      },
    );

    test('When the call sets no policy, then the client policy applies', () {
      fakeAsync((async) {
        final typeSafe = _failingWith(503);
        _Call(
          _jevFor(typeSafe.client, retry: TJevRetryPolicy(maxRetries: 0)),
        );

        async.elapse(const Duration(seconds: 2));

        expect(typeSafe.requests, hasLength(1));
      });
    });
  });

  group('Given an abort trigger', () {
    test(
      'When it completes during a Request, then ask returns an aborted '
      'failure at once and sends nothing more',
      () {
        fakeAsync((async) {
          var requests = 0;
          final client = MockClient((_) {
            requests++;
            return Completer<http.Response>().future;
          });
          final abort = Completer<void>();
          final call = _Call(_jevFor(client), abortTrigger: abort.future);

          async.elapse(const Duration(seconds: 1));
          expect(call.response, isNull);
          abort.complete();
          async.flushMicrotasks();

          expect(call.error, isA<TJevAbortedFailure>());
          async.elapse(const Duration(minutes: 1));
          expect(requests, 1);
        });
      },
    );

    test(
      'When it completes during a retry wait, then ask returns an aborted '
      'failure at once and does not retry',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          final abort = Completer<void>();
          final call = _Call(
            _jevFor(typeSafe.client),
            abortTrigger: abort.future,
          );

          async.elapse(const Duration(milliseconds: 200));
          expect(call.response, isNull);
          abort.complete();
          async.flushMicrotasks();

          expect(call.error, isA<TJevAbortedFailure>());
          async.elapse(const Duration(minutes: 1));
          expect(typeSafe.requests, hasLength(1));
        });
      },
    );

    test(
      'When the predicate retries every failure, then an aborted call is '
      'still not retried',
      () {
        fakeAsync((async) {
          var requests = 0;
          final client = MockClient((_) {
            requests++;
            return Completer<http.Response>().future;
          });
          final abort = Completer<void>();
          final call = _Call(
            _jevFor(client, retry: TJevRetryPolicy(predicate: (_) => true)),
            abortTrigger: abort.future,
          );

          async.elapse(const Duration(seconds: 1));
          abort.complete();
          async.elapse(const Duration(minutes: 1));

          expect(call.error, isA<TJevAbortedFailure>());
          expect(requests, 1);
        });
      },
    );

    test(
      'When it completes while models waits to retry, then models returns '
      'an aborted failure',
      () {
        fakeAsync((async) {
          final typeSafe = _failingWith(503);
          final abort = Completer<void>();
          TurboResponse<List<TJevModelCard>>? response;
          _jevFor(typeSafe.client)
              .models(retry: _exactPolicy(), abortTrigger: abort.future)
              .then((value) => response = value);

          async.elapse(const Duration(milliseconds: 499));
          abort.complete();
          async.elapse(const Duration(minutes: 1));

          expect(response?.error, isA<TJevAbortedFailure>());
          expect(typeSafe.requests, hasLength(1));
        });
      },
    );

    test('When it never completes, then the call ends as usual', () {
      fakeAsync((async) {
        final typeSafe = _answering([_success]);
        final call = _Call(
          _jevFor(typeSafe.client),
          abortTrigger: Completer<void>().future,
        );

        async.flushMicrotasks();

        expect(call.response?.isSuccess, isTrue);
      });
    });
  });

  group('Given an invalid retry policy', () {
    final invalidPolicies = <String, TJevRetryPolicy Function()>{
      'negative maxRetries': () => TJevRetryPolicy(maxRetries: -1),
      'negative initialBackoff': () =>
          TJevRetryPolicy(initialBackoff: const Duration(milliseconds: -1)),
      'negative maxBackoff': () =>
          TJevRetryPolicy(maxBackoff: const Duration(milliseconds: -1)),
      'negative maxRetryAfter': () =>
          TJevRetryPolicy(maxRetryAfter: const Duration(milliseconds: -1)),
      'jitter below 0': () => TJevRetryPolicy(jitter: -0.1),
      'jitter above 1': () => TJevRetryPolicy(jitter: 1.1),
      'jitter NaN': () => TJevRetryPolicy(jitter: double.nan),
      'a status below 100': () => TJevRetryPolicy(statuses: const {99}),
      'a status above 999': () => TJevRetryPolicy(statuses: const {1000}),
      'a zero budget': () => TJevRetryPolicy(budget: Duration.zero),
    };
    for (final MapEntry(key: name, value: create) in invalidPolicies.entries) {
      test('When it has $name, then creating it throws', () {
        expect(create, throwsA(isA<TJevInvalidRetryPolicyException>()));
      });
    }
  });
}
