@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

const _billing = TJevNoul(instructions: 'Is this message about billing?');

void main() {
  late FakeTypeSafe typeSafe;

  setUp(() => typeSafe = FakeTypeSafe());

  Future<void> askWith(TJev jev) =>
      jev.ask(state: 'I was charged twice.', questions: const [_billing]);

  group('Given config and an environment', () {
    const environment = {
      'TYPESAFE_API_KEY': 'ts_env_key',
      'TYPESAFE_BASE_URL': 'https://env-proxy.example.com',
      'TYPESAFE_DEFAULT_MODEL': 'jev-1.13.0',
    };

    test('When both set a value, then the explicit value wins', () async {
      await askWith(
        TJev(
          apiKey: 'ts_explicit_key',
          baseUrl: 'https://proxy.example.com',
          defaultModel: TJevModel.jevPreview,
          httpClient: typeSafe.client,
          environment: environment,
        ),
      );

      final request = typeSafe.lastRequest;
      expect(request.headers['Authorization'], 'Bearer ts_explicit_key');
      expect(request.url, Uri.parse('https://proxy.example.com/v1/systemone'));
      expect(typeSafe.lastBody['model'], 'jev-preview');
    });

    test('When config sets nothing, then the environment is used', () async {
      await askWith(
        TJev(httpClient: typeSafe.client, environment: environment),
      );

      final request = typeSafe.lastRequest;
      expect(request.headers['Authorization'], 'Bearer ts_env_key');
      expect(
        request.url,
        Uri.parse('https://env-proxy.example.com/v1/systemone'),
      );
      expect(typeSafe.lastBody['model'], 'jev-1.13.0');
    });

    test(
      'When the explicit API key is empty, '
      'then it does not fall back to the environment and throws',
      () {
        expect(
          () => TJev(
            apiKey: '',
            httpClient: typeSafe.client,
            environment: environment,
          ),
          throwsA(isA<TJevApiKeyException>()),
        );
      },
    );
  });

  group('Given no config', () {
    test('When the environment holds no API key, then it throws', () {
      expect(
        () => TJev(httpClient: typeSafe.client, environment: const {}),
        throwsA(isA<TJevApiKeyException>()),
      );
    });

    test('When the environment API key is blank, then it throws', () {
      expect(
        () => TJev(
          httpClient: typeSafe.client,
          environment: const {'TYPESAFE_API_KEY': '   '},
        ),
        throwsA(isA<TJevApiKeyException>()),
      );
    });

    test(
      'When the environment holds only a key, '
      'then it asks TypeSafe with jev-latest',
      () async {
        await askWith(
          TJev(
            httpClient: typeSafe.client,
            environment: const {'TYPESAFE_API_KEY': 'ts_env_key'},
          ),
        );

        expect(
          typeSafe.lastRequest.url,
          Uri.parse('https://api.typesafe.ai/v1/systemone'),
        );
        expect(typeSafe.lastBody['model'], 'jev-latest');
      },
    );
  });

  group('Given an API key', () {
    test('When it has surrounding whitespace, then it is trimmed', () async {
      await askWith(
        TJev(
          apiKey: '  ts_key\n',
          httpClient: typeSafe.client,
          environment: const {},
        ),
      );

      expect(typeSafe.lastRequest.headers['Authorization'], 'Bearer ts_key');
    });

    for (final invalidKey in ['ts key', 'ts_kéy', 'ts_\u0007key']) {
      test(
        'When it is "$invalidKey", which is not printable ASCII without '
        'spaces, then it throws',
        () {
          expect(
            () => TJev(
              apiKey: invalidKey,
              httpClient: typeSafe.client,
              environment: const {},
            ),
            throwsA(isA<TJevApiKeyException>()),
          );
        },
      );
    }
  });

  group('Given a base URL with trailing slashes', () {
    test('When it is explicit, then the slashes are stripped', () async {
      await askWith(
        TJev(
          apiKey: 'ts_key',
          baseUrl: 'https://proxy.example.com/typesafe//',
          httpClient: typeSafe.client,
          environment: const {},
        ),
      );

      expect(
        typeSafe.lastRequest.url,
        Uri.parse('https://proxy.example.com/typesafe/v1/systemone'),
      );
    });

    test(
      'When it comes from the environment, then the slashes are stripped',
      () async {
        await askWith(
          TJev(
            httpClient: typeSafe.client,
            environment: const {
              'TYPESAFE_API_KEY': 'ts_key',
              'TYPESAFE_BASE_URL': 'https://proxy.example.com/',
            },
          ),
        );

        expect(
          typeSafe.lastRequest.url,
          Uri.parse('https://proxy.example.com/v1/systemone'),
        );
      },
    );
  });

  group('Given a custom model id', () {
    test('When it is the default model, then Requests use it', () async {
      await askWith(
        TJev(
          apiKey: 'ts_key',
          defaultModel: const TJevModel('jev-1.15.0'),
          httpClient: typeSafe.client,
          environment: const {},
        ),
      );

      expect(typeSafe.lastBody['model'], 'jev-1.15.0');
    });
  });
}
