import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_notifiers/t_notifier.dart';

void main() {
  group('TNotifier', () {
    group('Initialization', () {
      test('should initialize with initial value', () {
        final notifier = TNotifier<int>(42);
        expect(notifier.value, equals(42));
        expect(notifier.data, equals(42));
      });

      test('should initialize with forceUpdate false by default', () {
        final notifier = TNotifier<int>(0);
        notifier.update(0); // Same value
        // Should not notify when value doesn't change and forceUpdate is false
        expect(notifier.value, equals(0));
      });

      test('should initialize with forceUpdate true when specified', () {
        final notifier = TNotifier<int>(0, forceUpdate: true);
        expect(notifier.value, equals(0));
      });
    });

    group('Value getters and setters', () {
      test('value getter should return current value', () {
        final notifier = TNotifier<String>('initial');
        expect(notifier.value, equals('initial'));
      });

      test('value setter should update value and notify listeners', () {
        final notifier = TNotifier<String>('initial');
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.value = 'updated';
        expect(notifier.value, equals('updated'));
        expect(notified, isTrue);
      });

      test('data getter should return current value', () {
        final notifier = TNotifier<int>(100);
        expect(notifier.data, equals(100));
      });

      test('data setter should update value and notify listeners', () {
        final notifier = TNotifier<int>(100);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.data = 200;
        expect(notifier.data, equals(200));
        expect(notified, isTrue);
      });
    });

    group('update() method', () {
      test('should update value when different', () {
        final notifier = TNotifier<int>(0);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.update(1);
        expect(notifier.value, equals(1));
        expect(notified, isTrue);
      });

      test(
        'should not update or notify when value is same and forceUpdate is false',
        () {
          final notifier = TNotifier<int>(5);
          var notified = false;
          notifier.addListener(() {
            notified = true;
          });

          notifier.update(5);
          expect(notifier.value, equals(5));
          expect(notified, isFalse);
        },
      );

      test(
        'should update and notify when value is same but forceUpdate is true',
        () {
          final notifier = TNotifier<int>(5, forceUpdate: true);
          var notified = false;
          notifier.addListener(() {
            notified = true;
          });

          notifier.update(5);
          expect(notifier.value, equals(5));
          expect(notified, isTrue);
        },
      );

      test('should not notify when doNotifyListeners is false', () {
        final notifier = TNotifier<int>(0);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.update(1, doNotifyListeners: false);
        expect(notifier.value, equals(1));
        expect(notified, isFalse);
      });

      test('should update value even when doNotifyListeners is false', () {
        final notifier = TNotifier<String>('old');
        notifier.update('new', doNotifyListeners: false);
        expect(notifier.value, equals('new'));
      });
    });

    group('updateCurrent() method', () {
      test('should update value using function', () {
        final notifier = TNotifier<int>(10);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.updateCurrent((current) => current * 2);
        expect(notifier.value, equals(20));
        expect(notified, isTrue);
      });

      test(
        'should not update or notify when function returns same value and forceUpdate is false',
        () {
          final notifier = TNotifier<int>(5);
          var notified = false;
          notifier.addListener(() {
            notified = true;
          });

          notifier.updateCurrent((current) => current);
          expect(notifier.value, equals(5));
          expect(notified, isFalse);
        },
      );

      test(
        'should update and notify when function returns same value but forceUpdate is true',
        () {
          final notifier = TNotifier<int>(5, forceUpdate: true);
          var notified = false;
          notifier.addListener(() {
            notified = true;
          });

          notifier.updateCurrent((current) => current);
          expect(notifier.value, equals(5));
          expect(notified, isTrue);
        },
      );

      test('should not notify when doNotifyListeners is false', () {
        final notifier = TNotifier<int>(10);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.updateCurrent(
          (current) => current + 5,
          doNotifyListeners: false,
        );
        expect(notifier.value, equals(15));
        expect(notified, isFalse);
      });

      test('should work with complex transformations', () {
        final notifier = TNotifier<List<int>>([1, 2, 3]);
        notifier.updateCurrent((current) => current..add(4));
        expect(notifier.value, equals([1, 2, 3, 4]));
      });
    });

    group('silentUpdate() method', () {
      test('should update value without notifying listeners', () {
        final notifier = TNotifier<int>(0);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.silentUpdate(10);
        expect(notifier.value, equals(10));
        expect(notified, isFalse);
      });

      test('should still respect forceUpdate flag', () {
        final notifier = TNotifier<int>(5, forceUpdate: true);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        // Even with forceUpdate, silentUpdate should not notify
        notifier.silentUpdate(5);
        expect(notifier.value, equals(5));
        expect(notified, isFalse);
      });
    });

    group('silentUpdateCurrent() method', () {
      test('should update value without notifying listeners', () {
        final notifier = TNotifier<int>(10);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        notifier.silentUpdateCurrent((current) => current * 2);
        expect(notifier.value, equals(20));
        expect(notified, isFalse);
      });

      test('should still respect forceUpdate flag', () {
        final notifier = TNotifier<int>(5, forceUpdate: true);
        var notified = false;
        notifier.addListener(() {
          notified = true;
        });

        // Even with forceUpdate, silentUpdateCurrent should not notify
        notifier.silentUpdateCurrent((current) => current);
        expect(notifier.value, equals(5));
        expect(notified, isFalse);
      });
    });

    group('Listener notifications', () {
      test('should notify single listener on value change', () {
        final notifier = TNotifier<String>('initial');
        var callCount = 0;
        notifier.addListener(() {
          callCount++;
        });

        notifier.update('updated');
        expect(callCount, equals(1));
      });

      test('should notify multiple listeners on value change', () {
        final notifier = TNotifier<int>(0);
        var callCount1 = 0;
        var callCount2 = 0;

        notifier.addListener(() {
          callCount1++;
        });
        notifier.addListener(() {
          callCount2++;
        });

        notifier.update(1);
        expect(callCount1, equals(1));
        expect(callCount2, equals(1));
      });

      test('should not notify when value does not change', () {
        final notifier = TNotifier<int>(5);
        var callCount = 0;
        notifier.addListener(() {
          callCount++;
        });

        notifier.update(5);
        expect(callCount, equals(0));
      });

      test(
        'should notify when value changes even if same reference (with forceUpdate)',
        () {
          final list = [1, 2, 3];
          final notifier = TNotifier<List<int>>(list, forceUpdate: true);
          var callCount = 0;
          notifier.addListener(() {
            callCount++;
          });

          // Even though it's the same list reference, forceUpdate should trigger notification
          notifier.update(list);
          expect(callCount, equals(1));
        },
      );
    });

    group('toString()', () {
      test('should return correct string representation', () {
        final notifier = TNotifier<int>(42, forceUpdate: false);
        final str = notifier.toString();
        expect(str, contains('TNotifier'));
        expect(str, contains('_value: 42'));
        expect(str, contains('_forceUpdate: false'));
      });

      test('should include forceUpdate flag in string representation', () {
        final notifier = TNotifier<String>('test', forceUpdate: true);
        final str = notifier.toString();
        expect(str, contains('_forceUpdate: true'));
      });
    });

    group('ValueListenable interface', () {
      test('should implement ValueListenable', () {
        final notifier = TNotifier<int>(0);
        expect(notifier, isA<ValueListenable<int>>());
      });

      test('should work with ValueListenableBuilder pattern', () {
        final notifier = TNotifier<String>('initial');
        expect(notifier.value, equals('initial'));

        notifier.value = 'updated';
        expect(notifier.value, equals('updated'));
      });
    });

    group('rebuild() from TurboChangeNotifier', () {
      test('should notify listeners when rebuild is called', () {
        final notifier = TNotifier<int>(0);
        var callCount = 0;
        notifier.addListener(() {
          callCount++;
        });

        notifier.rebuild();
        expect(callCount, equals(1));
      });
    });

    group('Edge cases', () {
      test('should handle null values', () {
        final notifier = TNotifier<String?>('initial');
        notifier.update(null);
        expect(notifier.value, isNull);
      });

      test('should handle empty collections', () {
        final notifier = TNotifier<List<int>>([]);
        expect(notifier.value, isEmpty);
        notifier.update([1, 2, 3]);
        expect(notifier.value, hasLength(3));
      });

      test('should handle removing listeners', () {
        final notifier = TNotifier<int>(0);
        var callCount = 0;
        void listener() {
          callCount++;
        }

        notifier.addListener(listener);
        notifier.update(1);
        expect(callCount, equals(1));

        notifier.removeListener(listener);
        notifier.update(2);
        expect(callCount, equals(1)); // Should not increment
      });

      test('should handle dispose', () {
        final notifier = TNotifier<int>(0);
        var callCount = 0;
        notifier.addListener(() {
          callCount++;
        });

        // Update before dispose should work
        notifier.update(1);
        expect(callCount, equals(1));

        // Dispose should work without throwing
        expect(() => notifier.dispose(), returnsNormally);
      });
    });
  });
}
