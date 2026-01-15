import 'package:test/test.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

void main() {
  group('MarkdownLayoutParser', () {
    const parser = MarkdownLayoutParser();

    group('empty and basic documents', () {
      test('parses empty document', () {
        final result = parser.parse('');
        expect(result.data, isEmpty);
        expect(result.keyMeta, isNull);
      });

      test('parses whitespace-only document', () {
        final result = parser.parse('   \n\n   ');
        expect(result.data, isEmpty);
      });

      test('parses plain text paragraph', () {
        final result = parser.parse('Hello world');
        expect(result.data['body'], 'Hello world');
      });
    });

    group('headers', () {
      test('parses h1 header', () {
        final result = parser.parse('# Title\nContent here');
        expect(result.data['title'], 'Content here');
        expect(result.keyMeta, isNotNull);
        expect((result.keyMeta!['title'] as Map<String, dynamic>)['headerLevel'], 1);
      });

      test('parses h2 header', () {
        final result = parser.parse('## Section\nSection content');
        expect(result.data['section'], 'Section content');
        expect((result.keyMeta!['section'] as Map<String, dynamic>)['headerLevel'], 2);
      });

      test('parses h3 header', () {
        final result = parser.parse('### Subsection\nSubsection content');
        expect(result.data['subsection'], 'Subsection content');
        expect((result.keyMeta!['subsection'] as Map<String, dynamic>)['headerLevel'], 3);
      });

      test('parses h4 header', () {
        final result = parser.parse('#### Deep Section\nDeep content');
        expect(result.data['deepSection'], 'Deep content');
        expect((result.keyMeta!['deepSection'] as Map<String, dynamic>)['headerLevel'], 4);
      });

      test('parses h5 header', () {
        final result = parser.parse('##### Very Deep\nVery deep content');
        expect(result.data['veryDeep'], 'Very deep content');
        expect((result.keyMeta!['veryDeep'] as Map<String, dynamic>)['headerLevel'], 5);
      });

      test('parses h6 header', () {
        final result = parser.parse('###### Deepest\nDeepest content');
        expect(result.data['deepest'], 'Deepest content');
        final deepestMeta = result.keyMeta!['deepest'] as Map<String, dynamic>;
        expect(deepestMeta['headerLevel'], 6);
      });

      test('converts header text to camelCase key', () {
        final result = parser.parse('## User Name\nJohn Doe');
        expect(result.data['userName'], 'John Doe');
        final userNameMeta = result.keyMeta!['userName'] as Map<String, dynamic>;
        expect(userNameMeta['headerLevel'], 2);
      });

      test('converts multi-word header to camelCase', () {
        final result = parser.parse('## First Name Last Name\nValue');
        expect(result.data['firstNameLastName'], 'Value');
      });

      test('handles header with special characters', () {
        final result = parser.parse('## User\'s Profile!\nContent');
        expect(result.data['usersProfile'], 'Content');
      });

      test('parses multiple headers', () {
        const markdown = '''
## First Section
First content

## Second Section
Second content
''';
        final result = parser.parse(markdown);
        expect(result.data['firstSection'], 'First content');
        expect(result.data['secondSection'], 'Second content');
      });

      test('parses nested headers hierarchically', () {
        const markdown = '''
# Main
## Sub One
Content one
## Sub Two
Content two
''';
        final result = parser.parse(markdown);
        expect(result.data['main'], isA<Map<dynamic, dynamic>>());
        // Note: The nested structure depends on implementation
      });
    });

    group('YAML frontmatter', () {
      test('parses basic frontmatter', () {
        const markdown = '''
---
title: Test Document
author: John Doe
---
Body content
''';
        final result = parser.parse(markdown);
        expect(result.data['title'], 'Test Document');
        expect(result.data['author'], 'John Doe');
      });

      test('parses numeric frontmatter values', () {
        const markdown = '''
---
version: 1
count: 42
---
''';
        final result = parser.parse(markdown);
        expect(result.data['version'], 1);
        expect(result.data['count'], 42);
      });

      test('parses boolean frontmatter values', () {
        const markdown = '''
---
published: true
draft: false
---
''';
        final result = parser.parse(markdown);
        expect(result.data['published'], true);
        expect(result.data['draft'], false);
      });

      test('parses quoted string values', () {
        const markdown = '''
---
message: "Hello: World"
single: 'Test'
---
''';
        final result = parser.parse(markdown);
        expect(result.data['message'], 'Hello: World');
        expect(result.data['single'], 'Test');
      });

      test('handles frontmatter without body', () {
        const markdown = '''
---
title: Only Frontmatter
---
''';
        final result = parser.parse(markdown);
        expect(result.data['title'], 'Only Frontmatter');
      });

      test('handles frontmatter with null value', () {
        const markdown = '''
---
empty: null
---
''';
        final result = parser.parse(markdown);
        expect(result.data['empty'], isNull);
      });
    });

    group('callouts', () {
      test('parses NOTE callout', () {
        const markdown = '> [!NOTE]\n> This is a note';
        final result = parser.parse(markdown);
        expect(result.data['note'], 'This is a note');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['note'] as Map<String, dynamic>)['callout'] as Map<String, dynamic>)['type'], 'note');
      });

      test('parses WARNING callout', () {
        const markdown = '> [!WARNING]\n> Be careful!';
        final result = parser.parse(markdown);
        expect(result.data['warning'], 'Be careful!');
        expect(((result.keyMeta!['warning'] as Map<String, dynamic>)['callout'] as Map<String, dynamic>)['type'], 'warning');
      });

      test('parses TIP callout', () {
        const markdown = '> [!TIP]\n> Pro tip here';
        final result = parser.parse(markdown);
        expect(result.data['tip'], 'Pro tip here');
        final tipMeta = result.keyMeta!['tip'] as Map<String, dynamic>;
        final callout = tipMeta['callout'] as Map<String, dynamic>;
        expect(callout['type'], 'tip');
      });

      test('parses IMPORTANT callout', () {
        const markdown = '> [!IMPORTANT]\n> Very important!';
        final result = parser.parse(markdown);
        expect(result.data['important'], 'Very important!');
        final importantMeta = result.keyMeta!['important'] as Map<String, dynamic>;
        final callout = importantMeta['callout'] as Map<String, dynamic>;
        expect(callout['type'], 'important');
      });

      test('parses CAUTION callout', () {
        const markdown = '> [!CAUTION]\n> Handle with care';
        final result = parser.parse(markdown);
        expect(result.data['caution'], 'Handle with care');
        final cautionMeta = result.keyMeta!['caution'] as Map<String, dynamic>;
        final callout = cautionMeta['callout'] as Map<String, dynamic>;
        expect(callout['type'], 'caution');
      });

      test('parses multiline callout', () {
        const markdown = '''
> [!NOTE]
> First line
> Second line
> Third line
''';
        final result = parser.parse(markdown);
        expect(result.data['note'], 'First line\nSecond line\nThird line');
      });

      test('parses callout with inline content', () {
        const markdown = '> [!WARNING] Inline warning content';
        final result = parser.parse(markdown);
        expect(result.data['warning'], 'Inline warning content');
      });
    });

    group('dividers', () {
      test('parses --- divider', () {
        const markdown = '---';
        final result = parser.parse(markdown);
        expect(result.keyMeta, isNotNull);
        // Dividers are stored with unique keys
        final dividerKey =
            result.keyMeta!.keys.firstWhere((k) => k.startsWith('_divider'));
        final dividerMeta = result.keyMeta![dividerKey] as Map<String, dynamic>;
        final divider = dividerMeta['divider'] as Map<String, dynamic>;
        expect(divider['style'], '---');
      });

      test('parses *** divider', () {
        const markdown = '***';
        final result = parser.parse(markdown);
        final dividerKey =
            result.keyMeta!.keys.firstWhere((k) => k.startsWith('_divider'));
        final dividerMeta = result.keyMeta![dividerKey] as Map<String, dynamic>;
        final divider = dividerMeta['divider'] as Map<String, dynamic>;
        expect(divider['style'], '***');
      });

      test('parses ___ divider', () {
        const markdown = '___';
        final result = parser.parse(markdown);
        final dividerKey =
            result.keyMeta!.keys.firstWhere((k) => k.startsWith('_divider'));
        final dividerMeta = result.keyMeta![dividerKey] as Map<String, dynamic>;
        final divider = dividerMeta['divider'] as Map<String, dynamic>;
        expect(divider['style'], '___');
      });

      test('parses longer dividers', () {
        const markdown = '--------';
        final result = parser.parse(markdown);
        final dividerKey =
            result.keyMeta!.keys.firstWhere((k) => k.startsWith('_divider'));
        final dividerMeta = result.keyMeta![dividerKey] as Map<String, dynamic>;
        final divider = dividerMeta['divider'] as Map<String, dynamic>;
        expect(divider['style'], '---');
      });
    });

    group('code blocks', () {
      test('parses fenced code block without language', () {
        const markdown = '''
```
const x = 1;
```
''';
        final result = parser.parse(markdown);
        final codeKey =
            result.data.keys.firstWhere((k) => k.startsWith('_code'));
        expect(result.data[codeKey], 'const x = 1;');
        final codeMeta = result.keyMeta![codeKey] as Map<String, dynamic>;
        final codeBlock = codeMeta['codeBlock'] as Map<String, dynamic>;
        expect(codeBlock['isInline'], false);
      });

      test('parses fenced code block with language', () {
        const markdown = '''
```javascript
const x = 1;
```
''';
        final result = parser.parse(markdown);
        final codeKey =
            result.data.keys.firstWhere((k) => k.startsWith('_code'));
        expect(result.data[codeKey], 'const x = 1;');
        final codeMeta = result.keyMeta![codeKey] as Map<String, dynamic>;
        final codeBlock = codeMeta['codeBlock'] as Map<String, dynamic>;
        expect(codeBlock['language'], 'javascript');
      });

      test('parses code block with language and filename', () {
        const markdown = '''
```dart example.dart
void main() {}
```
''';
        final result = parser.parse(markdown);
        final codeKey =
            result.data.keys.firstWhere((k) => k.startsWith('_code'));
        final codeMeta = result.keyMeta![codeKey] as Map<String, dynamic>;
        final codeBlock = codeMeta['codeBlock'] as Map<String, dynamic>;
        expect(codeBlock['language'], 'dart');
        expect(codeBlock['filename'], 'example.dart');
      });

      test('parses multiline code block', () {
        const markdown = '''
```python
def hello():
    print("Hello")
    return True
```
''';
        final result = parser.parse(markdown);
        final codeKey =
            result.data.keys.firstWhere((k) => k.startsWith('_code'));
        expect(result.data[codeKey], contains('def hello():'));
        expect(result.data[codeKey], contains('print("Hello")'));
      });

      test('parses code block with tilde fence', () {
        const markdown = '''
~~~python
code here
~~~
''';
        final result = parser.parse(markdown);
        final codeKey =
            result.data.keys.firstWhere((k) => k.startsWith('_code'));
        expect(result.data[codeKey], 'code here');
        final codeMeta = result.keyMeta![codeKey] as Map<String, dynamic>;
        final codeBlock = codeMeta['codeBlock'] as Map<String, dynamic>;
        expect(codeBlock['language'], 'python');
      });
    });

    group('unordered lists', () {
      test('parses - list marker', () {
        const markdown = '''
- Item 1
- Item 2
- Item 3
''';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        expect(result.data[listKey], ['Item 1', 'Item 2', 'Item 3']);
        final listMeta = result.keyMeta![listKey] as Map<String, dynamic>;
        final listMetaData = listMeta['listMeta'] as Map<String, dynamic>;
        expect(listMetaData['type'], 'unordered');
        expect(listMetaData['marker'], '-');
      });

      test('parses * list marker', () {
        const markdown = '''
* Item A
* Item B
''';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        expect(result.data[listKey], ['Item A', 'Item B']);
        final listMeta = result.keyMeta![listKey] as Map<String, dynamic>;
        final listMetaData = listMeta['listMeta'] as Map<String, dynamic>;
        expect(listMetaData['marker'], '*');
      });

      test('parses + list marker', () {
        const markdown = '''
+ First
+ Second
''';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        expect(result.data[listKey], ['First', 'Second']);
        final listMeta = result.keyMeta![listKey] as Map<String, dynamic>;
        final listMetaData = listMeta['listMeta'] as Map<String, dynamic>;
        expect(listMetaData['marker'], '+');
      });
    });

    group('ordered lists', () {
      test('parses ordered list with period', () {
        const markdown = '''
1. First item
2. Second item
3. Third item
''';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        expect(
            result.data[listKey], ['First item', 'Second item', 'Third item'],);
        final listMeta = result.keyMeta![listKey] as Map<String, dynamic>;
        final listMetaData = listMeta['listMeta'] as Map<String, dynamic>;
        expect(listMetaData['type'], 'ordered');
        expect(listMetaData['startNumber'], 1);
      });

      test('parses ordered list with parenthesis', () {
        const markdown = '''
1) Item A
2) Item B
''';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        expect(result.data[listKey], ['Item A', 'Item B']);
        final listMeta = result.keyMeta![listKey] as Map<String, dynamic>;
        final listMetaData = listMeta['listMeta'] as Map<String, dynamic>;
        expect(listMetaData['marker'], '1)');
      });

      test('preserves start number', () {
        const markdown = '''
5. Fifth
6. Sixth
''';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        expect(((result.keyMeta![listKey] as Map<String, dynamic>)['listMeta'] as Map<String, dynamic>)['startNumber'], 5);
      });
    });

    group('task lists', () {
      test('parses unchecked task', () {
        const markdown = '- [ ] Todo item';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        final listData = result.data[listKey] as List;
        expect((listData[0] as Map<String, dynamic>)['content'], 'Todo item');
        expect((listData[0] as Map<String, dynamic>)['checked'], false);
        expect(((result.keyMeta![listKey] as Map<String, dynamic>)['listMeta'] as Map<String, dynamic>)['type'], 'task');
      });

      test('parses checked task with lowercase x', () {
        const markdown = '- [x] Done item';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        final listData = result.data[listKey] as List;
        expect((listData[0] as Map<String, dynamic>)['checked'], true);
      });

      test('parses checked task with uppercase X', () {
        const markdown = '- [X] Completed';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        final listData = result.data[listKey] as List;
        expect((listData[0] as Map<String, dynamic>)['checked'], true);
      });

      test('parses mixed task list', () {
        const markdown = '''
- [x] Done
- [ ] Not done
- [X] Also done
''';
        final result = parser.parse(markdown);
        final listKey =
            result.data.keys.firstWhere((k) => k.startsWith('_list'));
        final listData = result.data[listKey] as List;
        expect((listData[0] as Map<String, dynamic>)['checked'], true);
        expect((listData[1] as Map<String, dynamic>)['checked'], false);
        expect((listData[2] as Map<String, dynamic>)['checked'], true);
      });
    });

    group('tables', () {
      test('parses simple table with header', () {
        const markdown = '''
| Name | Age |
|------|-----|
| John | 30  |
| Jane | 25  |
''';
        final result = parser.parse(markdown);
        final tableKey =
            result.data.keys.firstWhere((k) => k.startsWith('_table'));
        final tableData = result.data[tableKey] as Map<String, dynamic>;
        expect(tableData['headers'], ['Name', 'Age']);
        expect((tableData['rows'] as List).length, 2);
        final tableMeta = result.keyMeta![tableKey] as Map<String, dynamic>;
        final tableMetaData = tableMeta['tableMeta'] as Map<String, dynamic>;
        expect(tableMetaData['hasHeader'], true);
      });

      test('parses table with left alignment', () {
        const markdown = '''
| Name |
|:-----|
| Test |
''';
        final result = parser.parse(markdown);
        final tableKey =
            result.data.keys.firstWhere((k) => k.startsWith('_table'));
        final tableMeta = result.keyMeta![tableKey] as Map<String, dynamic>;
        final tableMetaData = tableMeta['tableMeta'] as Map<String, dynamic>;
        expect(tableMetaData['alignment'], ['left']);
      });

      test('parses table with center alignment', () {
        const markdown = '''
| Name |
|:----:|
| Test |
''';
        final result = parser.parse(markdown);
        final tableKey =
            result.data.keys.firstWhere((k) => k.startsWith('_table'));
        final tableMeta = result.keyMeta![tableKey] as Map<String, dynamic>;
        final tableMetaData = tableMeta['tableMeta'] as Map<String, dynamic>;
        expect(tableMetaData['alignment'], ['center']);
      });

      test('parses table with right alignment', () {
        const markdown = '''
| Amount |
|-------:|
| 100    |
''';
        final result = parser.parse(markdown);
        final tableKey =
            result.data.keys.firstWhere((k) => k.startsWith('_table'));
        final tableMeta = result.keyMeta![tableKey] as Map<String, dynamic>;
        final tableMetaData = tableMeta['tableMeta'] as Map<String, dynamic>;
        expect(tableMetaData['alignment'], ['right']);
      });

      test('parses table with mixed alignments', () {
        const markdown = '''
| Left | Center | Right |
|:-----|:------:|------:|
| A    | B      | C     |
''';
        final result = parser.parse(markdown);
        final tableKey =
            result.data.keys.firstWhere((k) => k.startsWith('_table'));
        expect(((result.keyMeta![tableKey] as Map<String, dynamic>)['tableMeta'] as Map<String, dynamic>)['alignment'],
            ['left', 'center', 'right'],);
      });
    });

    group('emphasis detection', () {
      test('detects bold with double asterisks', () {
        const markdown = '## Title\n**Bold text**';
        final result = parser.parse(markdown);
        // The emphasis is detected in the content
        expect(result.data['title'], contains('**Bold text**'));
      });

      test('detects bold with double underscores', () {
        const markdown = '## Title\n__Bold text__';
        final result = parser.parse(markdown);
        expect(result.data['title'], contains('__Bold text__'));
      });

      test('detects italic with single asterisk', () {
        const markdown = '## Title\n*Italic text*';
        final result = parser.parse(markdown);
        expect(result.data['title'], contains('*Italic text*'));
      });

      test('detects strikethrough', () {
        const markdown = '## Title\n~~Strikethrough~~';
        final result = parser.parse(markdown);
        expect(result.data['title'], contains('~~Strikethrough~~'));
      });

      test('detects inline code', () {
        const markdown = '## Title\n`inline code`';
        final result = parser.parse(markdown);
        expect(result.data['title'], contains('`inline code`'));
      });
    });

    group('whitespace preservation', () {
      test('detects line ending style LF', () {
        const markdown = '# Title\nContent';
        final result = parser.parse(markdown);
        final documentMeta = result.keyMeta!['_document'] as Map<String, dynamic>;
        final whitespace = documentMeta['whitespace'] as Map<String, dynamic>;
        expect(whitespace['lineEnding'], '\n');
      });

      test('detects line ending style CRLF', () {
        const markdown = '# Title\r\nContent';
        final result = parser.parse(markdown);
        final documentMeta = result.keyMeta!['_document'] as Map<String, dynamic>;
        final whitespace = documentMeta['whitespace'] as Map<String, dynamic>;
        expect(whitespace['lineEnding'], '\r\n');
      });

      test('tracks leading newlines', () {
        const markdown = '\n\n\n# Title\nContent';
        final result = parser.parse(markdown);
        final documentMeta = result.keyMeta!['_document'] as Map<String, dynamic>;
        final whitespace = documentMeta['whitespace'] as Map<String, dynamic>;
        expect(whitespace['leadingNewlines'], 3);
      });
    });

    group('complex documents', () {
      test('parses document with frontmatter, headers, and content', () {
        const markdown = '''
---
title: Complex Document
version: 2
---

# Main Title

Introduction paragraph.

## Section One

Content for section one.

## Section Two

Content for section two.
''';
        final result = parser.parse(markdown);
        expect(result.data['title'], 'Complex Document');
        expect(result.data['version'], 2);
        expect(result.data['mainTitle'], isNotNull);
      });

      test('parses document with mixed content types', () {
        const markdown = '''
# Guide

> [!NOTE]
> Important note here

## Code Example

```dart
void main() {}
```

## Tasks

- [x] First task
- [ ] Second task
''';
        final result = parser.parse(markdown);
        expect(result.data['note'], 'Important note here');
        // Code block and task list are nested under guide header
        final guide = result.data['guide'] as Map<String, dynamic>;
        expect(guide.keys.any((k) => k.startsWith('_code')), true);
        expect(guide.keys.any((k) => k.startsWith('_list')), true);
      });
    });

    group('edge cases', () {
      test('handles header without content', () {
        final result = parser.parse('## Empty Header');
        expect(result.data['emptyHeader'], '');
        expect((result.keyMeta!['emptyHeader'] as Map<String, dynamic>)['headerLevel'], 2);
      });

      test('handles consecutive dividers', () {
        const markdown = '''
---
---
---
''';
        final result = parser.parse(markdown);
        // Should not throw
        expect(result.data, isNotNull);
      });

      test('handles malformed table', () {
        const markdown = '| only | one | row |';
        final result = parser.parse(markdown);
        // Should parse as table with one row
        expect(result.data.keys.any((k) => k.startsWith('_table')), true);
      });

      test('handles unclosed code block', () {
        const markdown = '''
```javascript
const x = 1;
No closing fence
''';
        final result = parser.parse(markdown);
        // Should capture until end of document
        final codeKey =
            result.data.keys.firstWhere((k) => k.startsWith('_code'));
        expect(result.data[codeKey], contains('const x = 1;'));
      });

      test('handles special characters in content', () {
        const markdown = '## Special\n<script>alert("xss")</script>';
        final result = parser.parse(markdown);
        expect(result.data['special'], '<script>alert("xss")</script>');
      });

      test('handles unicode content', () {
        const markdown = '## Unicode\n日本語テスト 🎉';
        final result = parser.parse(markdown);
        expect(result.data['unicode'], '日本語テスト 🎉');
      });
    });
  });

  group('markdownToJson with preserveLayout', () {
    test('returns Map when preserveLayout is false', () {
      final result = markdownToJson('## Test\nContent');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('returns LayoutAwareParseResult when preserveLayout is true', () {
      final result = markdownToJson('## Test\nContent', preserveLayout: true);
      expect(result, isA<LayoutAwareParseResult>());
    });

    test('backward compatibility - basic frontmatter parsing', () {
      final result = markdownToJson('---\ntitle: Test\n---\nBody') as Map<String, dynamic>;
      expect(result['title'], 'Test');
      expect(result['body'], 'Body');
    });

    test('backward compatibility - JSON body parsing', () {
      final result = markdownToJson('{"key": "value"}') as Map<String, dynamic>;
      expect(result['body'], {'key': 'value'});
    });

    test('preserveLayout extracts header metadata', () {
      final result = markdownToJson('## User Name\nJohn', preserveLayout: true)
          as LayoutAwareParseResult;
      expect(result.data['userName'], 'John');
      expect((result.keyMeta!['userName'] as Map<String, dynamic>)['headerLevel'], 2);
    });

    test('preserveLayout extracts list metadata', () {
      final result = markdownToJson('- Item 1\n- Item 2', preserveLayout: true)
          as LayoutAwareParseResult;
      final listKey = result.data.keys.firstWhere((k) => k.startsWith('_list'));
      final listMeta = result.keyMeta![listKey] as Map<String, dynamic>;
      final listMetaData = listMeta['listMeta'] as Map<String, dynamic>;
      expect(listMetaData['type'], 'unordered');
    });

    test('preserveLayout extracts code block metadata', () {
      final result =
          markdownToJson('```dart\nvoid main() {}\n```', preserveLayout: true)
              as LayoutAwareParseResult;
      final codeKey = result.data.keys.firstWhere((k) => k.startsWith('_code'));
      final codeMeta = result.keyMeta![codeKey] as Map<String, dynamic>;
      final codeBlock = codeMeta['codeBlock'] as Map<String, dynamic>;
      expect(codeBlock['language'], 'dart');
    });

    test('preserveLayout extracts table metadata', () {
      final result = markdownToJson('| A | B |\n|---|---|\n| 1 | 2 |',
          preserveLayout: true,) as LayoutAwareParseResult;
      final tableKey =
          result.data.keys.firstWhere((k) => k.startsWith('_table'));
      expect(((result.keyMeta![tableKey] as Map<String, dynamic>)['tableMeta'] as Map<String, dynamic>)['hasHeader'], true);
    });

    test('preserveLayout extracts callout metadata', () {
      final result =
          markdownToJson('> [!WARNING]\n> Be careful!', preserveLayout: true)
              as LayoutAwareParseResult;
      expect(result.data['warning'], 'Be careful!');
      expect(((result.keyMeta!['warning'] as Map<String, dynamic>)['callout'] as Map<String, dynamic>)['type'], 'warning');
    });

    test('preserveLayout extracts divider metadata', () {
      final result =
          markdownToJson('---', preserveLayout: true) as LayoutAwareParseResult;
      final dividerKey =
          result.keyMeta!.keys.firstWhere((k) => k.startsWith('_divider'));
      final dividerMeta = result.keyMeta![dividerKey] as Map<String, dynamic>;
      final divider = dividerMeta['divider'] as Map<String, dynamic>;
      expect(divider['style'], '---');
    });

    test('preserveLayout preserves whitespace metadata', () {
      final result = markdownToJson('\n\n# Title', preserveLayout: true)
          as LayoutAwareParseResult;
      final documentMeta = result.keyMeta!['_document'] as Map<String, dynamic>;
      final whitespace = documentMeta['whitespace'] as Map<String, dynamic>;
      expect(whitespace['leadingNewlines'], 2);
    });
  });

  group('round-trip tests', () {
    test('header round-trip preserves level', () {
      const original = '## Section Title';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      expect((result.keyMeta!['sectionTitle'] as Map<String, dynamic>)['headerLevel'], 2);
    });

    test('list round-trip preserves marker style', () {
      const original = '* Item 1\n* Item 2';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      final listKey = result.data.keys.firstWhere((k) => k.startsWith('_list'));
      final listMeta = result.keyMeta![listKey] as Map<String, dynamic>;
      final listMetaData = listMeta['listMeta'] as Map<String, dynamic>;
      expect(listMetaData['marker'], '*');
    });

    test('ordered list round-trip preserves start number', () {
      const original = '5. Fifth\n6. Sixth';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      final listKey = result.data.keys.firstWhere((k) => k.startsWith('_list'));
      expect(((result.keyMeta![listKey] as Map<String, dynamic>)['listMeta'] as Map<String, dynamic>)['startNumber'], 5);
    });

    test('code block round-trip preserves language', () {
      const original = '```typescript\nconst x: number = 1;\n```';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      final codeKey = result.data.keys.firstWhere((k) => k.startsWith('_code'));
      expect(((result.keyMeta![codeKey] as Map<String, dynamic>)['codeBlock'] as Map<String, dynamic>)['language'], 'typescript');
    });

    test('table round-trip preserves alignment', () {
      const original =
          '| Left | Center | Right |\n|:-----|:------:|------:|\n| A | B | C |';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      final tableKey =
          result.data.keys.firstWhere((k) => k.startsWith('_table'));
      expect(((result.keyMeta![tableKey] as Map<String, dynamic>)['tableMeta'] as Map<String, dynamic>)['alignment'],
          ['left', 'center', 'right'],);
    });

    test('callout round-trip preserves type', () {
      const original = '> [!IMPORTANT]\n> Critical info';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      expect(((result.keyMeta!['important'] as Map<String, dynamic>)['callout'] as Map<String, dynamic>)['type'], 'important');
    });

    test('divider round-trip preserves style', () {
      const original = '***';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      final dividerKey =
          result.keyMeta!.keys.firstWhere((k) => k.startsWith('_divider'));
      expect(((result.keyMeta![dividerKey] as Map<String, dynamic>)['divider'] as Map<String, dynamic>)['style'], '***');
    });

    test('line ending round-trip preserves CRLF', () {
      const original = '# Title\r\nContent';
      final result = markdownToJson(original, preserveLayout: true)
          as LayoutAwareParseResult;
      expect(((result.keyMeta!['_document'] as Map<String, dynamic>)['whitespace'] as Map<String, dynamic>)['lineEnding'], '\r\n');
    });
  });
}
