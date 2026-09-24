import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  const contents = TTriggerContents(
    kind: 'task',
    hits: [
      TTriggerHitDto(
        file: '/abs/a.dart',
        line: 12,
        text: '// #TASK fix the button;',
        trigger: '// #TASK fix the button;',
      ),
      TTriggerHitDto(
        file: '/abs/b.dart',
        line: 4,
        text: '// #TASK rename this',
      ),
    ],
    context: '<relevant_context>tree and codemaps</relevant_context>',
  );

  group('TTriggerContents.toString', () {
    test(
      'Given a finished and an open hit, Then the text is one trigger element '
      'with both hits, the open one marked, and the context after the hits',
      () {
        expect(
          contents.toString(),
          "<trigger kind='task'>\n"
          '<hits>\n'
          "<hit file='/abs/a.dart' line='12'>// #TASK fix the button;</hit>\n"
          "<hit file='/abs/b.dart' line='4' open='true'>"
          '// #TASK rename this</hit>\n'
          '</hits>\n'
          '<relevant_context>tree and codemaps</relevant_context>\n'
          '</trigger>',
        );
      },
    );

    test('Given an empty context, Then the hits close the trigger', () {
      const bare = TTriggerContents(
        kind: 'note',
        hits: [
          TTriggerHitDto(file: '/abs/n.md', line: 1, text: 'x;', trigger: 'x;'),
        ],
      );

      expect(bare.toString(), endsWith('</hits>\n</trigger>'));
    });
  });

  group('TTriggerContents json', () {
    test('Given contents, Then a JSON round trip gives the same text', () {
      final json = contents.toJson();
      final copy = TTriggerContents.fromJson(json);

      expect(copy.toString(), contents.toString());
      expect(copy.hits.last.isOpen, isTrue);
    });
  });
}
