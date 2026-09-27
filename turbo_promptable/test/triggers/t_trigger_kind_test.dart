import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  group('THerdrTriggerKind', () {
    test('Given no contains, Then the prefix is #', () {
      const kind = THerdrTriggerKind(id: 'herdr', start: '//', end: ';');

      expect(kind.contains, '#');
    });

    test('Given its own contains, Then that prefix is kept', () {
      const kind = THerdrTriggerKind(
        id: 'herdr',
        start: '//',
        contains: '@',
        end: ';',
      );

      expect(kind.contains, '@');
    });
  });
}
