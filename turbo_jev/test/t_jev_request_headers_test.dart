import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';
import 'support/package_version.dart';

const _billing = TJevNoul(instructions: 'Is this message about billing?');

void main() {
  late FakeTypeSafe typeSafe;

  setUp(() => typeSafe = FakeTypeSafe());

  TJev jevWith({
    Map<String, String>? defaultHeaders,
    bool longContext = false,
  }) => TJev(
    apiKey: 'ts_test_key',
    defaultHeaders: defaultHeaders,
    longContext: longContext,
    httpClient: typeSafe.client,
    environment: const {},
  );

  group('Given default headers and per-call headers', () {
    test(
      'When asked, then both are sent and the per-call value wins',
      () async {
        final jev = jevWith(
          defaultHeaders: {'X-Team': 'billing', 'X-Trace': 'default'},
        );

        await jev.ask(
          state: 'I was charged twice.',
          questions: const [_billing],
          headers: {'X-Trace': 'call', 'X-Call': 'yes'},
        );

        final headers = typeSafe.lastRequest.headers;
        expect(headers['X-Team'], 'billing');
        expect(headers['X-Trace'], 'call');
        expect(headers['X-Call'], 'yes');
      },
    );

    test(
      'When a per-call name differs only in case, '
      'then one header is sent with the per-call value',
      () async {
        final jev = jevWith(defaultHeaders: {'X-Trace': 'default'});

        await jev.ask(
          state: 'I was charged twice.',
          questions: const [_billing],
          headers: {'x-trace': 'call'},
        );

        final traceHeaders = typeSafe.lastRequest.headers.entries.where(
          (header) => header.key.toLowerCase() == 'x-trace',
        );
        expect(traceHeaders.map((header) => header.value), ['call']);
      },
    );
  });

  group('Given headers that name protected headers', () {
    const protected = {
      'authorization': 'Bearer ts_other_key',
      'ACCEPT': 'text/html',
      'content-type': 'text/plain',
      'Content-Encoding': 'br',
      'user-agent': 'other-agent/1.0',
      'x-typesafe-sdk': 'other-sdk/1.0',
      'X-TypeSafe-Runtime': 'other-runtime/1.0',
    };

    test(
      'When asked, then the SDK values are sent instead of the given ones',
      () async {
        final jev = jevWith(defaultHeaders: protected);

        await jev.ask(
          state: 'I was charged twice.',
          questions: const [_billing],
          headers: protected,
        );

        final headers = typeSafe.lastRequest.headers;
        expect(headers['Authorization'], 'Bearer ts_test_key');
        expect(headers['Accept'], 'application/json');
        expect(headers['Content-Type'], 'application/json');
        expect(headers.containsKey('Content-Encoding'), isFalse);
        expect(headers['User-Agent'], 'turbo_jev/$packageVersion');
        expect(headers['X-TypeSafe-SDK'], 'turbo_jev/$packageVersion');
        expect(headers['X-TypeSafe-Runtime'], startsWith('dart/'));
      },
    );
  });

  group('Given the long-context flag', () {
    const longContextHeader = 'TypeSafe-Danger-Zone-Long-Context';

    test('When it is off, then no long-context header is sent', () async {
      await jevWith().ask(
        state: 'I was charged twice.',
        questions: const [_billing],
      );

      expect(
        typeSafe.lastRequest.headers.containsKey(longContextHeader),
        isFalse,
      );
    });

    test(
      'When it is on for the client, then every Request sends it',
      () async {
        await jevWith(longContext: true).ask(
          state: 'I was charged twice.',
          questions: const [_billing],
        );

        expect(typeSafe.lastRequest.headers[longContextHeader], 'true');
      },
    );

    test('When it is on for one call, then that Request sends it', () async {
      final jev = jevWith();

      await jev.ask(
        state: 'I was charged twice.',
        questions: const [_billing],
        longContext: true,
      );
      await jev.ask(state: 'Where is my parcel?', questions: const [_billing]);

      expect(typeSafe.requests.first.headers[longContextHeader], 'true');
      expect(
        typeSafe.requests.last.headers.containsKey(longContextHeader),
        isFalse,
      );
    });
  });
}
