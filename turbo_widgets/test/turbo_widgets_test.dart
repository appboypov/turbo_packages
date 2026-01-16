import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

void main() {
  group('TurboStringExtension', () {
    group('turboNullIfEmpty', () {
      test('returns null for empty string', () {
        expect(''.turboNullIfEmpty, isNull);
      });

      test('returns null for whitespace-only string', () {
        expect('   '.turboNullIfEmpty, isNull);
      });

      test('returns string for non-empty string', () {
        expect('hello'.turboNullIfEmpty, equals('hello'));
      });
    });

    group('turboTrimIsEmpty', () {
      test('returns true for empty string', () {
        expect(''.turboTrimIsEmpty, isTrue);
      });

      test('returns true for whitespace-only string', () {
        expect('   '.turboTrimIsEmpty, isTrue);
      });

      test('returns false for non-empty string', () {
        expect('hello'.turboTrimIsEmpty, isFalse);
      });
    });

    group('turboNaked', () {
      test('removes spaces and lowercases', () {
        expect('Hello World'.turboNaked, equals('helloworld'));
      });

      test('handles already naked string', () {
        expect('test'.turboNaked, equals('test'));
      });
    });

    group('turboTryAsDouble', () {
      test('parses valid double', () {
        expect('3.14'.turboTryAsDouble, equals(3.14));
      });

      test('returns null for invalid double', () {
        expect('abc'.turboTryAsDouble, isNull);
      });
    });

    group('turboTryAsInt', () {
      test('parses valid int', () {
        expect('42'.turboTryAsInt, equals(42));
      });

      test('returns null for invalid int', () {
        expect('abc'.turboTryAsInt, isNull);
      });
    });

    group('turboCapitalized', () {
      test('capitalizes first letter', () {
        expect('hello'.turboCapitalized, equals('Hello'));
      });

      test('handles empty string', () {
        expect(''.turboCapitalized, equals(''));
      });

      test('handles already capitalized', () {
        expect('Hello'.turboCapitalized, equals('Hello'));
      });
    });

    group('turboCapitalize', () {
      test('capitalizes without forcing lowercase', () {
        expect('hELLO'.turboCapitalize(), equals('HELLO'));
      });

      test('capitalizes with forcing lowercase', () {
        expect('hELLO'.turboCapitalize(forceLowercase: true), equals('Hello'));
      });

      test('handles empty string', () {
        expect(''.turboCapitalize(), equals(''));
      });
    });

    group('turboNormalized', () {
      test('normalizes multiple spaces', () {
        expect('hello   world'.turboNormalized, equals('hello world'));
      });

      test('trims and normalizes', () {
        expect('  hello   world  '.turboNormalized, equals('hello world'));
      });
    });

    group('turboContainsAny', () {
      test('returns true when contains one value', () {
        expect('hello world'.turboContainsAny(['world', 'foo']), isTrue);
      });

      test('returns false when contains none', () {
        expect('hello world'.turboContainsAny(['foo', 'bar']), isFalse);
      });
    });
  });

  group('TurboNumExtension', () {
    group('turboHasDecimals', () {
      test('returns true for number with decimals', () {
        expect(3.14.turboHasDecimals, isTrue);
      });

      test('returns false for whole number', () {
        expect(5.0.turboHasDecimals, isFalse);
      });
    });

    group('turboToFormattedString', () {
      test('formats whole number without decimals', () {
        expect(5.0.turboToFormattedString(), equals('5'));
      });

      test('formats decimal with one place', () {
        expect(3.14.turboToFormattedString(), equals('3.1'));
      });
    });

    group('turboMinimum', () {
      test('returns this when this is greater', () {
        expect(10.turboMinimum(5), equals(10));
      });

      test('returns other when other is greater', () {
        expect(3.turboMinimum(5), equals(5));
      });
    });

    group('turboMaximum', () {
      test('returns this when this is less', () {
        expect(3.turboMaximum(5), equals(3));
      });

      test('returns other when other is less', () {
        expect(10.turboMaximum(5), equals(5));
      });
    });

    group('turboDecimals', () {
      test('returns 0 for whole number', () {
        expect(5.turboDecimals, equals(0));
      });

      test('returns count of decimal places', () {
        expect(3.14.turboDecimals, equals(2));
      });
    });
  });

  group('TurboDurationExtension', () {
    group('turboAdd', () {
      test('adds duration', () {
        const d1 = Duration(seconds: 5);
        const d2 = Duration(seconds: 3);
        expect(d1.turboAdd(d2), equals(const Duration(seconds: 8)));
      });

      test('handles null duration', () {
        const d1 = Duration(seconds: 5);
        expect(d1.turboAdd(null), equals(const Duration(seconds: 5)));
      });
    });
  });

  group('TurboScaleExtension', () {
    group('turboScaledPerWidth', () {
      test('scales proportionally to width', () {
        final result = 100.0.turboScaledPerWidth(
          currentWidth: 800,
          widthInDesign: 400,
        );
        expect(result, equals(200.0));
      });

      test('scales with speed factor', () {
        final result = 100.0.turboScaledPerWidth(
          currentWidth: 800,
          widthInDesign: 400,
          speed: 0.5,
        );
        expect(result, closeTo(141.42, 0.01));
      });
    });

    group('turboScaledPerHeight', () {
      test('scales proportionally to height', () {
        final result = 100.0.turboScaledPerHeight(
          currentHeight: 1200,
          heightInDesign: 600,
        );
        expect(result, equals(200.0));
      });
    });

    group('turboScaledPerWidthAndHeight', () {
      test('uses minimum scale', () {
        final result = 100.0.turboScaledPerWidthAndHeight(
          currentWidth: 800,
          currentHeight: 1000,
          widthInDesign: 400,
          heightInDesign: 800,
        );
        expect(result, equals(125.0));
      });
    });
  });

  group('TurboObjectExtension', () {
    group('turboButWhen', () {
      test('returns value when condition is true', () {
        const Object? value = 'hello';
        expect(value.turboButWhen(true, () => 'world'), equals('world'));
      });

      test('returns this when condition is false', () {
        const Object? value = 'hello';
        expect(value.turboButWhen(false, () => 'world'), equals('hello'));
      });
    });
  });

  group('TurboPadding', () {
    test('TurboPadding.all creates correct padding', () {
      const padding = TurboPadding.all(10.0);
      expect(padding.left, equals(10.0));
      expect(padding.right, equals(10.0));
      expect(padding.top, equals(10.0));
      expect(padding.bottom, equals(10.0));
    });

    test('TurboPadding.app creates default 16.0 padding', () {
      const padding = TurboPadding.app();
      expect(padding.left, equals(16.0));
    });

    test('TurboPadding.button creates horizontal-only padding', () {
      const padding = TurboPadding.button();
      expect(padding.left, equals(16.0));
      expect(padding.top, equals(0.0));
    });

    test('TurboPadding.card creates 12.0 padding', () {
      const padding = TurboPadding.card();
      expect(padding.left, equals(12.0));
    });
  });

  group('Constants', () {
    test('turboDurationsAnimation is 225ms', () {
      expect(turboDurationsAnimation, equals(const Duration(milliseconds: 225)));
    });

    test('turboDurationsAnimationX2 is 450ms', () {
      expect(
        turboDurationsAnimationX2,
        equals(const Duration(milliseconds: 450)),
      );
    });
  });
}
