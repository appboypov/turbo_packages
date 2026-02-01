import 'package:test/test.dart';
import 'package:turbo_response/turbo_response.dart';

void main() {
  group('DefaultResult', () {
    test('empty success result should equal true', () {
      const response = TurboResponse<dynamic>.successAsBool();
      expect(response.result == true, isTrue);
    });

    test('empty fail error should be TurboException', () {
      const response = TurboResponse<dynamic>.failAsBool();
      expect(response.error, isA<TurboException>());
      expect(
        response.error.toString(),
        equals('TurboException: Operation failed'),
      );
    });

    test('empty success result should equal another empty success', () {
      const response1 = TurboResponse<dynamic>.successAsBool();
      const response2 = TurboResponse<dynamic>.successAsBool();
      expect(response1.result == response2.result, isTrue);
    });

    test('empty success result should not equal false', () {
      const response = TurboResponse<dynamic>.successAsBool();
      expect(response.result == false, isFalse);
    });

    test('empty success result should not equal other objects', () {
      const response = TurboResponse<dynamic>.successAsBool();
      expect(response.result == 'true', isFalse);
      expect(response.result == 1, isFalse);
      expect(response.result == null, isFalse);
    });

    test('empty success result toString should be descriptive', () {
      const response = TurboResponse<dynamic>.successAsBool();
      expect(response.result.toString(), equals('Operation succeeded'));
    });

    test('empty fail error should have descriptive message', () {
      const response = TurboResponse<dynamic>.failAsBool();
      expect(
        (response.error as TurboException).error,
        equals('Operation failed'),
      );
    });
  });
}
