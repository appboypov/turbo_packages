import 'package:test/test.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

void main() {
  group('XmlLayoutParser', () {
    const parser = XmlLayoutParser();

    group('empty and basic documents', () {
      test('parses empty string', () {
        final result = parser.parse('');
        expect(result.data, isEmpty);
        expect(result.keyMeta, isNull);
      });

      test('parses simple element with text', () {
        final result = parser.parse('<root>Hello World</root>');
        expect(result.data['root'], 'Hello World');
      });

      test('parses element with numeric text', () {
        final result = parser.parse('<count>42</count>');
        expect(result.data['count'], 42);
      });

      test('parses element with boolean true', () {
        final result = parser.parse('<active>true</active>');
        expect(result.data['active'], true);
      });

      test('parses element with boolean false', () {
        final result = parser.parse('<deleted>false</deleted>');
        expect(result.data['deleted'], false);
      });

      test('parses element with double value', () {
        final result = parser.parse('<price>9.99</price>');
        expect(result.data['price'], 9.99);
      });

      test('parses empty element as null', () {
        final result = parser.parse('<empty></empty>');
        expect(result.data['empty'], isNull);
      });
    });

    group('attributes', () {
      test('extracts single attribute', () {
        final result = parser.parse('<user id="123">John</user>');
        expect(result.data['user'], 'John');
        expect(result.keyMeta, isNotNull);
        final userMeta = result.keyMeta!['user'] as Map<String, dynamic>;
        final xmlMeta = userMeta['xmlMeta'] as Map<String, dynamic>;
        final attributes = xmlMeta['attributes'] as Map<String, dynamic>;
        expect(attributes['id'], '123');
      });

      test('extracts multiple attributes', () {
        final result = parser.parse('<user id="123" active="true">John</user>');
        expect(result.data['user'], 'John');
        final userMeta = result.keyMeta!['user'] as Map<String, dynamic>;
        final xmlMeta = userMeta['xmlMeta'] as Map<String, dynamic>;
        final attributes = xmlMeta['attributes'] as Map<String, dynamic>;
        expect(attributes['id'], '123');
        expect(attributes['active'], 'true');
      });

      test('attributes on nested elements', () {
        final result = parser.parse('''
          <root>
            <user role="admin">
              <name>John</name>
            </user>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        final userData = rootData['user'] as Map<String, dynamic>;
        expect(userData['name'], 'John');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final children = rootMeta['children'] as Map<String, dynamic>;
        final userMeta = children['user'] as Map<String, dynamic>;
        final xmlMeta = userMeta['xmlMeta'] as Map<String, dynamic>;
        final attributes = xmlMeta['attributes'] as Map<String, dynamic>;
        expect(attributes['role'], 'admin');
      });

      test('attributes with special characters in values', () {
        final result =
            parser.parse('<item data-value="test&amp;value">Content</item>');
        expect(result.data['item'], 'Content');
        final itemMeta = result.keyMeta!['item'] as Map<String, dynamic>;
        final xmlMeta = itemMeta['xmlMeta'] as Map<String, dynamic>;
        final attributes = xmlMeta['attributes'] as Map<String, dynamic>;
        expect(attributes['data-value'], 'test&value');
      });
    });

    group('CDATA sections', () {
      test('parses CDATA content', () {
        final result =
            parser.parse('<bio><![CDATA[Special <characters> allowed]]></bio>');
        expect(result.data['bio'], 'Special <characters> allowed');
        final bioMeta = result.keyMeta!['bio'] as Map<String, dynamic>;
        final xmlMeta = bioMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['isCdata'], true);
      });

      test('parses CDATA with XML-like content', () {
        final result =
            parser.parse('<code><![CDATA[<div>HTML content</div>]]></code>');
        expect(result.data['code'], '<div>HTML content</div>');
        final codeMeta = result.keyMeta!['code'] as Map<String, dynamic>;
        final xmlMeta = codeMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['isCdata'], true);
      });

      test('parses CDATA with multiple sections', () {
        final result = parser
            .parse('<content><![CDATA[Part 1]]><![CDATA[ Part 2]]></content>');
        expect(result.data['content'], 'Part 1 Part 2');
        final contentMeta = result.keyMeta!['content'] as Map<String, dynamic>;
        final xmlMeta = contentMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['isCdata'], true);
      });

      test('nested element with CDATA', () {
        final result = parser.parse('''
          <root>
            <description><![CDATA[Some <special> content]]></description>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['description'], 'Some <special> content');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final children = rootMeta['children'] as Map<String, dynamic>;
        final descriptionMeta = children['description'] as Map<String, dynamic>;
        final xmlMeta = descriptionMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['isCdata'], true);
      });
    });

    group('comments', () {
      test('captures preceding comment', () {
        final result = parser.parse('''
          <root>
            <!-- User preferences -->
            <preferences>dark</preferences>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['preferences'], 'dark');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final children = rootMeta['children'] as Map<String, dynamic>;
        final preferencesMeta = children['preferences'] as Map<String, dynamic>;
        final xmlMeta = preferencesMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['comment'], 'User preferences');
      });

      test('captures comment before nested element', () {
        final result = parser.parse('''
          <root>
            <!-- Important section -->
            <section>
              <title>Main</title>
            </section>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        final sectionData = rootData['section'] as Map<String, dynamic>;
        expect(sectionData['title'], 'Main');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final children = rootMeta['children'] as Map<String, dynamic>;
        final sectionMeta = children['section'] as Map<String, dynamic>;
        final xmlMeta = sectionMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['comment'], 'Important section');
      });

      test('ignores comments not immediately before element', () {
        final result = parser.parse('''
          <root>
            <!-- First comment -->
            <other>value</other>
            <!-- Second comment is for target -->
            <target>content</target>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['target'], 'content');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final children = rootMeta['children'] as Map<String, dynamic>;
        final targetMeta = children['target'] as Map<String, dynamic>;
        final xmlMeta = targetMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['comment'], 'Second comment is for target');
      });
    });

    group('namespaces', () {
      test('captures namespace URI', () {
        final result = parser.parse(
            '<root xmlns="http://example.com"><item>value</item></root>',);
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['item'], 'value');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final xmlMeta = rootMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['namespace'], 'http://example.com');
      });

      test('captures namespace prefix', () {
        final result = parser.parse(
            '<app:root xmlns:app="http://example.com/app"><app:item>value</app:item></app:root>',);
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['item'], 'value');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final xmlMeta = rootMeta['xmlMeta'] as Map<String, dynamic>;
        expect(xmlMeta['prefix'], 'app');
        expect(xmlMeta['namespace'], 'http://example.com/app');
      });

      test('nested elements with different namespaces', () {
        final result = parser.parse('''
          <root xmlns:app="http://example.com/app" xmlns:data="http://example.com/data">
            <app:section>
              <data:value>content</data:value>
            </app:section>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        final sectionData = rootData['section'] as Map<String, dynamic>;
        expect(sectionData['value'], 'content');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final rootChildren = rootMeta['children'] as Map<String, dynamic>;
        final sectionMeta = rootChildren['section'] as Map<String, dynamic>;
        final sectionXmlMeta = sectionMeta['xmlMeta'] as Map<String, dynamic>;
        expect(sectionXmlMeta['prefix'], 'app');
        final sectionChildren = sectionMeta['children'] as Map<String, dynamic>;
        final valueMeta = sectionChildren['value'] as Map<String, dynamic>;
        final valueXmlMeta = valueMeta['xmlMeta'] as Map<String, dynamic>;
        expect(valueXmlMeta['prefix'], 'data');
      });
    });

    group('nested structures', () {
      test('parses nested elements', () {
        final result = parser.parse('''
          <user>
            <name>John Doe</name>
            <email>john@example.com</email>
          </user>
        ''');
        final userData = result.data['user'] as Map<String, dynamic>;
        expect(userData['name'], 'John Doe');
        expect(userData['email'], 'john@example.com');
      });

      test('parses deeply nested elements', () {
        final result = parser.parse('''
          <root>
            <level1>
              <level2>
                <level3>deep value</level3>
              </level2>
            </level1>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        final level1Data = rootData['level1'] as Map<String, dynamic>;
        final level2Data = level1Data['level2'] as Map<String, dynamic>;
        expect(level2Data['level3'], 'deep value');
      });

      test('parses sibling elements', () {
        final result = parser.parse('''
          <root>
            <first>1</first>
            <second>2</second>
            <third>3</third>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['first'], 1);
        expect(rootData['second'], 2);
        expect(rootData['third'], 3);
      });
    });

    group('lists (repeated elements)', () {
      test('parses repeated elements as list', () {
        final result = parser.parse('''
          <root>
            <item>a</item>
            <item>b</item>
            <item>c</item>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['item'], ['a', 'b', 'c']);
      });

      test('parses repeated elements with numeric values', () {
        final result = parser.parse('''
          <root>
            <number>1</number>
            <number>2</number>
            <number>3</number>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['number'], [1, 2, 3]);
      });

      test('parses repeated complex elements', () {
        final result = parser.parse('''
          <root>
            <user>
              <name>John</name>
            </user>
            <user>
              <name>Jane</name>
            </user>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['user'], [
          {'name': 'John'},
          {'name': 'Jane'},
        ]);
      });

      test('preserves metadata for list items', () {
        final result = parser.parse('''
          <root>
            <item id="1">first</item>
            <item id="2">second</item>
          </root>
        ''');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['item'], ['first', 'second']);
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final rootChildren = rootMeta['children'] as Map<String, dynamic>;
        final item0Meta = rootChildren['item.0'] as Map<String, dynamic>;
        final item0XmlMeta = item0Meta['xmlMeta'] as Map<String, dynamic>;
        final item0Attributes = item0XmlMeta['attributes'] as Map<String, dynamic>;
        expect(item0Attributes['id'], '1');
        final item1Meta = rootChildren['item.1'] as Map<String, dynamic>;
        final item1XmlMeta = item1Meta['xmlMeta'] as Map<String, dynamic>;
        final item1Attributes = item1XmlMeta['attributes'] as Map<String, dynamic>;
        expect(item1Attributes['id'], '2');
      });
    });

    group('mixed content', () {
      test('handles text with elements', () {
        final result =
            parser.parse('<root>Some text <child>nested</child></root>');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['_text'], 'Some text');
        expect(rootData['child'], 'nested');
      });

      test('handles multiple text nodes', () {
        final result =
            parser.parse('<root>Start <middle>value</middle> End</root>');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['_text'], 'Start End');
        expect(rootData['middle'], 'value');
      });
    });

    group('error handling', () {
      test('throws FormatException on invalid XML', () {
        expect(
          () => parser.parse('<invalid>'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException on mismatched tags', () {
        expect(
          () => parser.parse('<open>content</close>'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException on malformed XML', () {
        expect(
          () => parser.parse('not xml at all'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('complex documents', () {
      test('parses document with attributes, CDATA, comments, and namespaces',
          () {
        const xml = '''
          <user id="123" active="true">
            <name>John Doe</name>
            <bio><![CDATA[Special <characters> allowed]]></bio>
            <!-- User preferences -->
            <preferences xmlns:app="http://example.com">
              <app:theme>dark</app:theme>
            </preferences>
          </user>
        ''';
        final result = parser.parse(xml);

        // Data extraction
        final userData = result.data['user'] as Map<String, dynamic>;
        expect(userData['name'], 'John Doe');
        expect(userData['bio'], 'Special <characters> allowed');
        final preferencesData = userData['preferences'] as Map<String, dynamic>;
        expect(preferencesData['theme'], 'dark');

        // Metadata extraction
        final userMeta = result.keyMeta!['user'] as Map<String, dynamic>;
        final userXmlMeta = userMeta['xmlMeta'] as Map<String, dynamic>;
        final userAttributes = userXmlMeta['attributes'] as Map<String, dynamic>;
        expect(userAttributes['id'], '123');
        expect(userAttributes['active'], 'true');
        final userChildren = userMeta['children'] as Map<String, dynamic>;
        final bioMeta = userChildren['bio'] as Map<String, dynamic>;
        final bioXmlMeta = bioMeta['xmlMeta'] as Map<String, dynamic>;
        expect(bioXmlMeta['isCdata'], true);
        final preferencesMeta = userChildren['preferences'] as Map<String, dynamic>;
        final preferencesXmlMeta = preferencesMeta['xmlMeta'] as Map<String, dynamic>;
        expect(preferencesXmlMeta['comment'], 'User preferences');
        final preferencesChildren = preferencesMeta['children'] as Map<String, dynamic>;
        final themeMeta = preferencesChildren['theme'] as Map<String, dynamic>;
        final themeXmlMeta = themeMeta['xmlMeta'] as Map<String, dynamic>;
        expect(themeXmlMeta['prefix'], 'app');
      });

      test('parses document with multiple lists', () {
        const xml = '''
          <catalog>
            <book>
              <title>Book One</title>
              <author>Author A</author>
            </book>
            <book>
              <title>Book Two</title>
              <author>Author B</author>
            </book>
            <category>Fiction</category>
            <category>Drama</category>
          </catalog>
        ''';
        final result = parser.parse(xml);

        final catalogData = result.data['catalog'] as Map<String, dynamic>;
        expect(catalogData['book'], [
          {'title': 'Book One', 'author': 'Author A'},
          {'title': 'Book Two', 'author': 'Author B'},
        ]);
        expect(catalogData['category'], ['Fiction', 'Drama']);
      });
    });

    group('edge cases', () {
      test('handles whitespace-only text content', () {
        final result = parser.parse('<root>   </root>');
        expect(result.data['root'], isNull);
      });

      test('handles self-closing tags', () {
        final result = parser.parse('<root><empty/></root>');
        final rootData = result.data['root'] as Map<String, dynamic>;
        expect(rootData['empty'], isNull);
      });

      test('handles special characters in text', () {
        final result =
            parser.parse('<root>&lt;script&gt;alert()&lt;/script&gt;</root>');
        expect(result.data['root'], '<script>alert()</script>');
      });

      test('handles unicode content', () {
        final result = parser.parse('<root>日本語テスト</root>');
        expect(result.data['root'], '日本語テスト');
      });

      test('handles emoji content', () {
        final result = parser.parse('<root>Hello 🎉</root>');
        expect(result.data['root'], 'Hello 🎉');
      });

      test('handles attributes with colons', () {
        final result = parser.parse('<root xml:lang="en">Content</root>');
        expect(result.data['root'], 'Content');
        final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
        final xmlMeta = rootMeta['xmlMeta'] as Map<String, dynamic>;
        final attributes = xmlMeta['attributes'] as Map<String, dynamic>;
        expect(attributes['xml:lang'], 'en');
      });
    });
  });

  group('xmlToJson with preserveLayout', () {
    test('returns Map when preserveLayout is false', () {
      final result = xmlToJson('<root><name>test</name></root>');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('returns LayoutAwareParseResult when preserveLayout is true', () {
      final result =
          xmlToJson('<root><name>test</name></root>', preserveLayout: true);
      expect(result, isA<LayoutAwareParseResult>());
    });

    test('backward compatibility - basic XML parsing', () {
      final result = xmlToJson('<root><name>John</name><age>30</age></root>')
          as Map<String, dynamic>;
      expect(result['name'], 'John');
      expect(result['age'], 30);
    });

    test('backward compatibility - nested structures', () {
      final result = xmlToJson('<root><user><name>John</name></user></root>')
          as Map<String, dynamic>;
      final userData = result['user'] as Map<String, dynamic>;
      expect(userData['name'], 'John');
    });

    test('backward compatibility - repeated elements as list', () {
      final result = xmlToJson('<root><item>a</item><item>b</item></root>')
          as Map<String, dynamic>;
      expect(result['item'], ['a', 'b']);
    });

    test('preserveLayout extracts attribute metadata', () {
      final result =
          xmlToJson('<user id="123">John</user>', preserveLayout: true)
              as LayoutAwareParseResult;
      expect(result.data['user'], 'John');
      final userMeta = result.keyMeta!['user'] as Map<String, dynamic>;
      final xmlMeta = userMeta['xmlMeta'] as Map<String, dynamic>;
      final attributes = xmlMeta['attributes'] as Map<String, dynamic>;
      expect(attributes['id'], '123');
    });

    test('preserveLayout extracts CDATA metadata', () {
      final result =
          xmlToJson('<bio><![CDATA[Content]]></bio>', preserveLayout: true)
              as LayoutAwareParseResult;
      expect(result.data['bio'], 'Content');
      final bioMeta = result.keyMeta!['bio'] as Map<String, dynamic>;
      final xmlMeta = bioMeta['xmlMeta'] as Map<String, dynamic>;
      expect(xmlMeta['isCdata'], true);
    });

    test('preserveLayout extracts namespace metadata', () {
      final result = xmlToJson(
          '<root xmlns="http://example.com"><item>value</item></root>',
          preserveLayout: true,) as LayoutAwareParseResult;
      final rootData = result.data['root'] as Map<String, dynamic>;
      expect(rootData['item'], 'value');
      final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
      final xmlMeta = rootMeta['xmlMeta'] as Map<String, dynamic>;
      expect(xmlMeta['namespace'], 'http://example.com');
    });

    test('preserveLayout extracts comment metadata', () {
      final result = xmlToJson(
          '<root><!-- comment --><item>value</item></root>',
          preserveLayout: true,) as LayoutAwareParseResult;
      final rootData = result.data['root'] as Map<String, dynamic>;
      expect(rootData['item'], 'value');
      final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
      final rootChildren = rootMeta['children'] as Map<String, dynamic>;
      final itemMeta = rootChildren['item'] as Map<String, dynamic>;
      final xmlMeta = itemMeta['xmlMeta'] as Map<String, dynamic>;
      expect(xmlMeta['comment'], 'comment');
    });
  });

  group('round-trip tests', () {
    test('attributes round-trip', () {
      const original = '<user id="123" active="true">John</user>';
      final result =
          xmlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      final userMeta = result.keyMeta!['user'] as Map<String, dynamic>;
      final xmlMeta = userMeta['xmlMeta'] as Map<String, dynamic>;
      final attributes = xmlMeta['attributes'] as Map<String, dynamic>;
      expect(attributes['id'], '123');
      expect(attributes['active'], 'true');
    });

    test('CDATA round-trip', () {
      const original = '<bio><![CDATA[Special <content>]]></bio>';
      final result =
          xmlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      final bioMeta = result.keyMeta!['bio'] as Map<String, dynamic>;
      final xmlMeta = bioMeta['xmlMeta'] as Map<String, dynamic>;
      expect(xmlMeta['isCdata'], true);
    });

    test('namespace round-trip', () {
      const original =
          '<app:root xmlns:app="http://example.com/app"><app:item>value</app:item></app:root>';
      final result =
          xmlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
      final xmlMeta = rootMeta['xmlMeta'] as Map<String, dynamic>;
      expect(xmlMeta['prefix'], 'app');
      expect(xmlMeta['namespace'], 'http://example.com/app');
    });

    test('comment round-trip', () {
      const original = '<root><!-- Important --><item>value</item></root>';
      final result =
          xmlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      final rootMeta = result.keyMeta!['root'] as Map<String, dynamic>;
      final rootChildren = rootMeta['children'] as Map<String, dynamic>;
      final itemMeta = rootChildren['item'] as Map<String, dynamic>;
      final xmlMeta = itemMeta['xmlMeta'] as Map<String, dynamic>;
      expect(xmlMeta['comment'], 'Important');
    });

    test('complex document round-trip', () {
      const original = '''
        <user id="123">
          <name>John Doe</name>
          <bio><![CDATA[Bio with <special> chars]]></bio>
          <!-- Preferences section -->
          <preferences xmlns:app="http://example.com">
            <app:theme>dark</app:theme>
          </preferences>
        </user>
      ''';
      final result =
          xmlToJson(original, preserveLayout: true) as LayoutAwareParseResult;

      // Verify all metadata is captured
      final userMeta = result.keyMeta!['user'] as Map<String, dynamic>;
      final userXmlMeta = userMeta['xmlMeta'] as Map<String, dynamic>;
      final userAttributes = userXmlMeta['attributes'] as Map<String, dynamic>;
      expect(userAttributes['id'], '123');
      final userChildren = userMeta['children'] as Map<String, dynamic>;
      final bioMeta = userChildren['bio'] as Map<String, dynamic>;
      final bioXmlMeta = bioMeta['xmlMeta'] as Map<String, dynamic>;
      expect(bioXmlMeta['isCdata'], true);
      final preferencesMeta = userChildren['preferences'] as Map<String, dynamic>;
      final preferencesXmlMeta = preferencesMeta['xmlMeta'] as Map<String, dynamic>;
      expect(preferencesXmlMeta['comment'], 'Preferences section');
      final preferencesChildren = preferencesMeta['children'] as Map<String, dynamic>;
      final themeMeta = preferencesChildren['theme'] as Map<String, dynamic>;
      final themeXmlMeta = themeMeta['xmlMeta'] as Map<String, dynamic>;
      expect(themeXmlMeta['prefix'], 'app');
    });
  });
}
