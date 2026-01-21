import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_flutter_template/core/environment/enums/environment.dart';

void main() {
  group('Environment', () {
    test('default environment is prod', () {
      expect(Environment.current, equals(EnvironmentType.prod));
    });

    test('environment helpers return correct values', () {
      expect(Environment.isProd, isTrue);
      expect(Environment.isStaging, isFalse);
      expect(Environment.isEmulators, isFalse);
    });
  });
}
