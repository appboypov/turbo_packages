import 'package:test/test.dart';
import 'package:tool/utils/case_converter.dart';

void main() {
  group('CaseConverter', () {
    group('snakeToCamel', () {
      test('converts simple snake_case', () {
        expect(CaseConverter.snakeToCamel('my_app'), equals('myApp'));
      });

      test('converts multi-word snake_case', () {
        expect(
          CaseConverter.snakeToCamel('my_awesome_app'),
          equals('myAwesomeApp'),
        );
      });

      test('handles single word', () {
        expect(CaseConverter.snakeToCamel('app'), equals('app'));
      });

      test('handles empty string', () {
        expect(CaseConverter.snakeToCamel(''), equals(''));
      });

      test('handles consecutive underscores', () {
        expect(CaseConverter.snakeToCamel('my__app'), equals('myApp'));
      });

      test('handles trailing underscore', () {
        expect(CaseConverter.snakeToCamel('my_app_'), equals('myApp'));
      });
    });

    group('snakeToTitle', () {
      test('converts simple snake_case', () {
        expect(CaseConverter.snakeToTitle('my_app'), equals('My App'));
      });

      test('converts multi-word snake_case', () {
        expect(
          CaseConverter.snakeToTitle('my_awesome_app'),
          equals('My Awesome App'),
        );
      });

      test('handles single word', () {
        expect(CaseConverter.snakeToTitle('app'), equals('App'));
      });

      test('handles empty string', () {
        expect(CaseConverter.snakeToTitle(''), equals(''));
      });

      test('converts turbo_flutter_template correctly', () {
        expect(
          CaseConverter.snakeToTitle('turbo_flutter_template'),
          equals('Turbo Flutter Template'),
        );
      });
    });

    group('camelToSnake', () {
      test('converts simple camelCase', () {
        expect(CaseConverter.camelToSnake('myApp'), equals('my_app'));
      });

      test('converts multi-word camelCase', () {
        expect(
          CaseConverter.camelToSnake('myAwesomeApp'),
          equals('my_awesome_app'),
        );
      });

      test('handles single word', () {
        expect(CaseConverter.camelToSnake('app'), equals('app'));
      });

      test('handles empty string', () {
        expect(CaseConverter.camelToSnake(''), equals(''));
      });

      test('handles consecutive capitals', () {
        expect(CaseConverter.camelToSnake('myAPIApp'), equals('my_a_p_i_app'));
      });
    });

    group('titleToSnake', () {
      test('converts simple Title Case', () {
        expect(CaseConverter.titleToSnake('My App'), equals('my_app'));
      });

      test('converts multi-word Title Case', () {
        expect(
          CaseConverter.titleToSnake('My Awesome App'),
          equals('my_awesome_app'),
        );
      });

      test('handles single word', () {
        expect(CaseConverter.titleToSnake('App'), equals('app'));
      });

      test('handles empty string', () {
        expect(CaseConverter.titleToSnake(''), equals(''));
      });
    });

    group('isValidSnakeCase', () {
      test('accepts valid snake_case', () {
        expect(CaseConverter.isValidSnakeCase('my_app'), isTrue);
        expect(CaseConverter.isValidSnakeCase('my_awesome_app'), isTrue);
        expect(CaseConverter.isValidSnakeCase('app'), isTrue);
        expect(CaseConverter.isValidSnakeCase('app2'), isTrue);
        expect(CaseConverter.isValidSnakeCase('my_app_2'), isTrue);
      });

      test('rejects invalid snake_case', () {
        expect(CaseConverter.isValidSnakeCase(''), isFalse);
        expect(CaseConverter.isValidSnakeCase('_my_app'), isFalse);
        expect(CaseConverter.isValidSnakeCase('my_app_'), isFalse);
        expect(CaseConverter.isValidSnakeCase('my__app'), isFalse);
        expect(CaseConverter.isValidSnakeCase('MyApp'), isFalse);
        expect(CaseConverter.isValidSnakeCase('my-app'), isFalse);
        expect(CaseConverter.isValidSnakeCase('2app'), isFalse);
      });
    });

    group('isValidReverseDomain', () {
      test('accepts valid reverse domains', () {
        expect(CaseConverter.isValidReverseDomain('app.apewpew'), isTrue);
        expect(CaseConverter.isValidReverseDomain('io.mycompany'), isTrue);
        expect(CaseConverter.isValidReverseDomain('com.my.company'), isTrue);
        expect(CaseConverter.isValidReverseDomain('nl.codaveto'), isTrue);
      });

      test('rejects invalid reverse domains', () {
        expect(CaseConverter.isValidReverseDomain(''), isFalse);
        expect(CaseConverter.isValidReverseDomain('com'), isFalse);
        expect(CaseConverter.isValidReverseDomain('com.'), isFalse);
        expect(CaseConverter.isValidReverseDomain('.example'), isFalse);
        expect(CaseConverter.isValidReverseDomain('com.Example'), isFalse);
        expect(CaseConverter.isValidReverseDomain('com.my-company'), isFalse);
        expect(CaseConverter.isValidReverseDomain('com.2company'), isFalse);
      });
    });

    group('round-trip conversions', () {
      test('snake -> camel -> snake preserves value', () {
        const original = 'my_awesome_app';
        final camel = CaseConverter.snakeToCamel(original);
        final back = CaseConverter.camelToSnake(camel);
        expect(back, equals(original));
      });

      test('snake -> title -> snake preserves value', () {
        const original = 'my_awesome_app';
        final title = CaseConverter.snakeToTitle(original);
        final back = CaseConverter.titleToSnake(title);
        expect(back, equals(original));
      });
    });
  });
}
