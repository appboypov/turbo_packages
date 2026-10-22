@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/constants/png_bytes.dart';
import 'support/services/fake_type_safe.dart';
import 'support/utils/throws_t_jev_exception.dart';

const _billing = TJevNoul(
  id: 'billing',
  instructions: 'Is this about billing?',
);
const _refund = TJevNoul(
  id: 'refund',
  instructions: 'Does it ask for a refund?',
);

void main() {
  group('Given a misused client', () {
    late TJev jev;

    setUp(() {
      jev = TJev(
        apiKey: 'ts_key',
        httpClient: FakeTypeSafe().client,
        environment: const {},
      );
    });

    test('When it has no API key, then it throws a TJevException', () {
      expect(
        () => TJev(httpClient: FakeTypeSafe().client, environment: const {}),
        throwsTJevException<TJevApiKeyException>(),
      );
    });

    test(
      'When its timeout is not positive, then it throws a TJevException',
      () {
        expect(
          () => TJev(
            apiKey: 'ts_key',
            httpClient: FakeTypeSafe().client,
            environment: const {},
            timeout: Duration.zero,
          ),
          throwsTJevException<TJevInvalidTimeoutException>(),
        );
      },
    );

    test(
      'When a retry policy has an invalid value, then it throws a '
      'TJevException',
      () {
        expect(
          () => TJevRetryPolicy(maxRetries: -1),
          throwsTJevException<TJevInvalidRetryPolicyException>(),
        );
      },
    );

    test('When an Image is no PNG or JPEG, then it throws a TJevException', () {
      expect(
        () => TJevImage(const []),
        throwsTJevException<TJevInvalidImageException>(),
      );
    });

    test('When a Request has no Question, then it throws a TJevException', () {
      expect(
        () => jev.ask(state: 'I was charged twice.', questions: const []),
        throwsTJevException<TJevInvalidQuestionException>(),
      );
    });

    test(
      'When a listed Image is used nowhere, then it throws a TJevException',
      () {
        expect(
          () => jev.ask(
            state: 'I was charged twice.',
            questions: const [_billing],
            images: [TJevImage(pngBytes)],
          ),
          throwsTJevException<TJevImageReferenceException>(),
        );
      },
    );

    test(
      'When a result is read for an unasked Question, then it throws a '
      'TJevException',
      () async {
        final response = await jev.ask(
          state: 'I was charged twice.',
          questions: const [_billing],
        );

        expect(
          () => response.result!.answer(_refund),
          throwsTJevException<TJevUnaskedQuestionException>(),
        );
      },
    );
  });
}
