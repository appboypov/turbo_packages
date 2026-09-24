import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  group('TCliTool.argv', () {
    test('Given pi with every setting, Then each becomes a pi flag', () {
      final argv = TCliTool.pi.argv(
        config: const TSpawnConfigDto(
          model: 'opus',
          effort: TEffort.high,
          systemPrompt: 'You are Skuddy.',
          skills: ['a', 'b'],
          firstMessage: 'Fix login',
        ),
      );

      expect(argv, [
        'pi',
        '--model',
        'opus',
        '--thinking',
        'high',
        '--append-system-prompt',
        'You are Skuddy.',
        '--skill',
        'a',
        '--skill',
        'b',
        'Fix login',
      ]);
    });

    test(
      'Given claude with model, effort and prompt, Then claude flags are used',
      () {
        final argv = TCliTool.claude.argv(
          config: const TSpawnConfigDto(
            model: 'opus',
            effort: TEffort.max,
            systemPrompt: 'Be brief.',
          ),
        );

        expect(argv, [
          'claude',
          '--model',
          'opus',
          '--effort',
          'max',
          '--append-system-prompt',
          'Be brief.',
        ]);
      },
    );

    test(
      'Given codex with effort and prompt, Then they become config overrides',
      () {
        final argv = TCliTool.codex.argv(
          config: const TSpawnConfigDto(
            model: 'gpt-5',
            effort: TEffort.low,
            systemPrompt: 'Say "hi".',
          ),
        );

        expect(argv, [
          'codex',
          '-m',
          'gpt-5',
          '-c',
          'model_reasoning_effort="low"',
          '-c',
          r'developer_instructions="Say \"hi\"."',
        ]);
      },
    );

    test('Given cursor, Then the executable is cursor-agent', () {
      expect(TCliTool.cursor.argv(config: const TSpawnConfigDto()), [
        'cursor-agent',
      ]);
    });

    test('Given empty prompt and skills, Then they count as not set', () {
      final argv = TCliTool.claude.argv(
        config: const TSpawnConfigDto(systemPrompt: '', skills: []),
      );

      expect(argv, ['claude']);
    });

    for (final (tool, config, setting) in [
      (TCliTool.claude, const TSpawnConfigDto(skills: ['a']), 'skills'),
      (TCliTool.codex, const TSpawnConfigDto(effort: TEffort.max), 'effort'),
      (
        TCliTool.cursor,
        const TSpawnConfigDto(systemPrompt: 'x'),
        'systemPrompt',
      ),
    ]) {
      test(
        'Given ${tool.name} with $setting it cannot express, Then it throws',
        () {
          expect(
            () => tool.argv(config: config),
            throwsA(
              isA<TUnsupportedSpawnSettingException>()
                  .having((e) => e.tool, 'tool', tool)
                  .having((e) => e.setting, 'setting', setting),
            ),
          );
        },
      );
    }
  });
}
