import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

void main() {
  group('TStringExtension', () {
    group('nullIfEmpty', () {
      test('returns null for empty string', () {
        expect(''.nullIfEmpty, isNull);
      });

      test('returns null for whitespace-only string', () {
        expect('   '.nullIfEmpty, isNull);
      });

      test('returns string for non-empty string', () {
        expect('hello'.nullIfEmpty, equals('hello'));
      });
    });

    group('trimIsEmpty', () {
      test('returns true for empty string', () {
        expect(''.trimIsEmpty, isTrue);
      });

      test('returns true for whitespace-only string', () {
        expect('   '.trimIsEmpty, isTrue);
      });

      test('returns false for non-empty string', () {
        expect('hello'.trimIsEmpty, isFalse);
      });
    });

    group('naked', () {
      test('removes spaces and lowercases', () {
        expect('Hello World'.naked, equals('helloworld'));
      });

      test('handles already naked string', () {
        expect('test'.naked, equals('test'));
      });
    });

    group('tryAsDouble', () {
      test('parses valid double', () {
        expect('3.14'.tryAsDouble, equals(3.14));
      });

      test('returns null for invalid double', () {
        expect('abc'.tryAsDouble, isNull);
      });
    });

    group('tryAsInt', () {
      test('parses valid int', () {
        expect('42'.tryAsInt, equals(42));
      });

      test('returns null for invalid int', () {
        expect('abc'.tryAsInt, isNull);
      });
    });

    group('capitalized', () {
      test('capitalizes first letter', () {
        expect('hello'.capitalized, equals('Hello'));
      });

      test('handles empty string', () {
        expect(''.capitalized, equals(''));
      });

      test('handles already capitalized', () {
        expect('Hello'.capitalized, equals('Hello'));
      });
    });

    group('capitalize', () {
      test('capitalizes without forcing lowercase', () {
        expect('hELLO'.capitalize(), equals('HELLO'));
      });

      test('capitalizes with forcing lowercase', () {
        expect('hELLO'.capitalize(forceLowercase: true), equals('Hello'));
      });

      test('handles empty string', () {
        expect(''.capitalize(), equals(''));
      });
    });

    group('normalized', () {
      test('normalizes multiple spaces', () {
        expect('hello   world'.normalized, equals('hello world'));
      });

      test('trims and normalizes', () {
        expect('  hello   world  '.normalized, equals('hello world'));
      });
    });

    group('containsAny', () {
      test('returns true when contains one value', () {
        expect('hello world'.containsAny(['world', 'foo']), isTrue);
      });

      test('returns false when contains none', () {
        expect('hello world'.containsAny(['foo', 'bar']), isFalse);
      });
    });
  });

  group('TNumExtension', () {
    group('tHasDecimals', () {
      test('returns true for number with decimals', () {
        expect(3.14.hasDecimals, isTrue);
      });

      test('returns false for whole number', () {
        expect(5.0.hasDecimals, isFalse);
      });
    });

    group('tToFormattedString', () {
      test('formats whole number without decimals', () {
        expect(5.0.toFormattedString(), equals('5'));
      });

      test('formats decimal with one place', () {
        expect(3.14.toFormattedString(), equals('3.1'));
      });
    });

    group('tMinimum', () {
      test('returns this when this is greater', () {
        expect(10.minimum(5), equals(10));
      });

      test('returns other when other is greater', () {
        expect(3.minimum(5), equals(5));
      });
    });

    group('tMaximum', () {
      test('returns this when this is less', () {
        expect(3.maximum(5), equals(3));
      });

      test('returns other when other is less', () {
        expect(10.maximum(5), equals(5));
      });
    });

    group('tDecimals', () {
      test('returns 0 for whole number', () {
        expect(5.decimals, equals(0));
      });

      test('returns count of decimal places', () {
        expect(3.14.decimals, equals(2));
      });
    });
  });

  group('TDurationExtension', () {
    group('add', () {
      test('adds duration', () {
        const d1 = Duration(seconds: 5);
        const d2 = Duration(seconds: 3);
        expect(d1.add(d2), equals(const Duration(seconds: 8)));
      });

      test('handles null duration', () {
        const d1 = Duration(seconds: 5);
        expect(d1.add(null), equals(const Duration(seconds: 5)));
      });
    });
  });

  group('TScaleExtension', () {
    group('scaledPerWidth', () {
      test('scales proportionally to width', () {
        final result = 100.0.scaledPerWidth(
          currentWidth: 800,
          widthInDesign: 400,
        );
        expect(result, equals(200.0));
      });

      test('scales with speed factor', () {
        final result = 100.0.scaledPerWidth(
          currentWidth: 800,
          widthInDesign: 400,
          speed: 0.5,
        );
        expect(result, closeTo(141.42, 0.01));
      });
    });

    group('scaledPerHeight', () {
      test('scales proportionally to height', () {
        final result = 100.0.scaledPerHeight(
          currentHeight: 1200,
          heightInDesign: 600,
        );
        expect(result, equals(200.0));
      });
    });

    group('scaledPerWidthAndHeight', () {
      test('uses minimum scale', () {
        final result = 100.0.scaledPerWidthAndHeight(
          currentWidth: 800,
          currentHeight: 1000,
          widthInDesign: 400,
          heightInDesign: 800,
        );
        expect(result, equals(125.0));
      });
    });
  });

  group('TObjectExtension', () {
    group('butWhen', () {
      test('returns value when condition is true', () {
        const Object? value = 'hello';
        expect(value.butWhen(true, () => 'world'), equals('world'));
      });

      test('returns this when condition is false', () {
        const Object? value = 'hello';
        expect(value.butWhen(false, () => 'world'), equals('hello'));
      });
    });
  });

  group('TPadding', () {
    test('TPadding.all creates correct padding', () {
      const padding = TPadding.all(10.0);
      expect(padding.left, equals(10.0));
      expect(padding.right, equals(10.0));
      expect(padding.top, equals(10.0));
      expect(padding.bottom, equals(10.0));
    });

    test('TPadding.app creates default 16.0 padding', () {
      const padding = TPadding.app();
      expect(padding.left, equals(16.0));
    });

    test('TPadding.button creates horizontal-only padding', () {
      const padding = TPadding.button();
      expect(padding.left, equals(16.0));
      expect(padding.top, equals(0.0));
    });

    test('TPadding.card creates 12.0 padding', () {
      const padding = TPadding.card();
      expect(padding.left, equals(12.0));
    });
  });

  group('Constants', () {
    test('tDurationsAnimation is 225ms', () {
      expect(tDurationsAnimation, equals(const Duration(milliseconds: 225)));
    });

    test('tDurationsAnimationX2 is 450ms', () {
      expect(
        tDurationsAnimationX2,
        equals(const Duration(milliseconds: 450)),
      );
    });
  });
}
