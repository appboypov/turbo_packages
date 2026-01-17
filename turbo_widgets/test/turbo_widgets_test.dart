import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

void main() {
  group('TStringExtension', () {
    group('tNullIfEmpty', () {
      test('returns null for empty string', () {
        expect(''.tNullIfEmpty, isNull);
      });

      test('returns null for whitespace-only string', () {
        expect('   '.tNullIfEmpty, isNull);
      });

      test('returns string for non-empty string', () {
        expect('hello'.tNullIfEmpty, equals('hello'));
      });
    });

    group('tTrimIsEmpty', () {
      test('returns true for empty string', () {
        expect(''.tTrimIsEmpty, isTrue);
      });

      test('returns true for whitespace-only string', () {
        expect('   '.tTrimIsEmpty, isTrue);
      });

      test('returns false for non-empty string', () {
        expect('hello'.tTrimIsEmpty, isFalse);
      });
    });

    group('tNaked', () {
      test('removes spaces and lowercases', () {
        expect('Hello World'.tNaked, equals('helloworld'));
      });

      test('handles already naked string', () {
        expect('test'.tNaked, equals('test'));
      });
    });

    group('tTryAsDouble', () {
      test('parses valid double', () {
        expect('3.14'.tTryAsDouble, equals(3.14));
      });

      test('returns null for invalid double', () {
        expect('abc'.tTryAsDouble, isNull);
      });
    });

    group('tTryAsInt', () {
      test('parses valid int', () {
        expect('42'.tTryAsInt, equals(42));
      });

      test('returns null for invalid int', () {
        expect('abc'.tTryAsInt, isNull);
      });
    });

    group('tCapitalized', () {
      test('capitalizes first letter', () {
        expect('hello'.tCapitalized, equals('Hello'));
      });

      test('handles empty string', () {
        expect(''.tCapitalized, equals(''));
      });

      test('handles already capitalized', () {
        expect('Hello'.tCapitalized, equals('Hello'));
      });
    });

    group('tCapitalize', () {
      test('capitalizes without forcing lowercase', () {
        expect('hELLO'.tCapitalize(), equals('HELLO'));
      });

      test('capitalizes with forcing lowercase', () {
        expect('hELLO'.tCapitalize(forceLowercase: true), equals('Hello'));
      });

      test('handles empty string', () {
        expect(''.tCapitalize(), equals(''));
      });
    });

    group('tNormalized', () {
      test('normalizes multiple spaces', () {
        expect('hello   world'.tNormalized, equals('hello world'));
      });

      test('trims and normalizes', () {
        expect('  hello   world  '.tNormalized, equals('hello world'));
      });
    });

    group('tContainsAny', () {
      test('returns true when contains one value', () {
        expect('hello world'.tContainsAny(['world', 'foo']), isTrue);
      });

      test('returns false when contains none', () {
        expect('hello world'.tContainsAny(['foo', 'bar']), isFalse);
      });
    });
  });

  group('TNumExtension', () {
    group('tHasDecimals', () {
      test('returns true for number with decimals', () {
        expect(3.14.tHasDecimals, isTrue);
      });

      test('returns false for whole number', () {
        expect(5.0.tHasDecimals, isFalse);
      });
    });

    group('tToFormattedString', () {
      test('formats whole number without decimals', () {
        expect(5.0.tToFormattedString(), equals('5'));
      });

      test('formats decimal with one place', () {
        expect(3.14.tToFormattedString(), equals('3.1'));
      });
    });

    group('tMinimum', () {
      test('returns this when this is greater', () {
        expect(10.tMinimum(5), equals(10));
      });

      test('returns other when other is greater', () {
        expect(3.tMinimum(5), equals(5));
      });
    });

    group('tMaximum', () {
      test('returns this when this is less', () {
        expect(3.tMaximum(5), equals(3));
      });

      test('returns other when other is less', () {
        expect(10.tMaximum(5), equals(5));
      });
    });

    group('tDecimals', () {
      test('returns 0 for whole number', () {
        expect(5.tDecimals, equals(0));
      });

      test('returns count of decimal places', () {
        expect(3.14.tDecimals, equals(2));
      });
    });
  });

  group('TDurationExtension', () {
    group('tAdd', () {
      test('adds duration', () {
        const d1 = Duration(seconds: 5);
        const d2 = Duration(seconds: 3);
        expect(d1.tAdd(d2), equals(const Duration(seconds: 8)));
      });

      test('handles null duration', () {
        const d1 = Duration(seconds: 5);
        expect(d1.tAdd(null), equals(const Duration(seconds: 5)));
      });
    });
  });

  group('TScaleExtension', () {
    group('tScaledPerWidth', () {
      test('scales proportionally to width', () {
        final result = 100.0.tScaledPerWidth(
          currentWidth: 800,
          widthInDesign: 400,
        );
        expect(result, equals(200.0));
      });

      test('scales with speed factor', () {
        final result = 100.0.tScaledPerWidth(
          currentWidth: 800,
          widthInDesign: 400,
          speed: 0.5,
        );
        expect(result, closeTo(141.42, 0.01));
      });
    });

    group('tScaledPerHeight', () {
      test('scales proportionally to height', () {
        final result = 100.0.tScaledPerHeight(
          currentHeight: 1200,
          heightInDesign: 600,
        );
        expect(result, equals(200.0));
      });
    });

    group('tScaledPerWidthAndHeight', () {
      test('uses minimum scale', () {
        final result = 100.0.tScaledPerWidthAndHeight(
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
    group('tButWhen', () {
      test('returns value when condition is true', () {
        const Object? value = 'hello';
        expect(value.tButWhen(true, () => 'world'), equals('world'));
      });

      test('returns this when condition is false', () {
        const Object? value = 'hello';
        expect(value.tButWhen(false, () => 'world'), equals('hello'));
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
