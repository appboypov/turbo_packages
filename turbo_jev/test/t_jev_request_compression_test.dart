import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

import 'support/fake_type_safe.dart';

const _billing = TJevNoul(instructions: 'Is this message about billing?');

/// The body of a Request that asks [_billing] about [state].
Map<String, Object?> _bodyWith(String state) => {
  'model': 'jev-latest',
  'state': state,
  'questions': {
    'q0': {'type': 'noul', 'instructions': 'Is this message about billing?'},
  },
};

/// A State that makes the JSON body exactly [bodyBytes] bytes long.
String _stateForBodyOf(int bodyBytes) =>
    'a' * (bodyBytes - utf8.encode(jsonEncode(_bodyWith(''))).length);

void main() {
  group('Given a Request body on the Dart VM', () {
    late FakeTypeSafe typeSafe;
    late TJev jev;

    setUp(() {
      typeSafe = FakeTypeSafe();
      jev = TJev(
        apiKey: 'ts_test_key',
        httpClient: typeSafe.client,
        environment: const {},
      );
    });

    test('When it is 1023 bytes, then it is sent uncompressed', () async {
      final state = _stateForBodyOf(1023);

      await jev.ask(state: state, questions: const [_billing]);

      final request = typeSafe.lastRequest;
      expect(request.headers.containsKey('Content-Encoding'), isFalse);
      expect(request.bodyBytes, hasLength(1023));
      expect(jsonDecode(utf8.decode(request.bodyBytes)), _bodyWith(state));
    });

    test(
      'When it is 1024 bytes, then it is sent gzip compressed',
      () async {
        final state = _stateForBodyOf(1024);

        await jev.ask(state: state, questions: const [_billing]);

        final request = typeSafe.lastRequest;
        expect(request.headers['Content-Encoding'], 'gzip');
        expect(request.headers['Content-Type'], 'application/json');
        final body = gzip.decode(request.bodyBytes);
        expect(body, hasLength(1024));
        expect(jsonDecode(utf8.decode(body)), _bodyWith(state));
      },
    );
  });
}
