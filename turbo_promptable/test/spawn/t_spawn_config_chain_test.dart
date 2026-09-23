import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

const _developer = TRole(
  id: 'developer',
  name: 'Developer',
  expertise: 'Writing code',
  spawnConfig: TSpawnConfigDto(
    tool: TCliTool.pi,
    model: 'sonnet',
    effort: TEffort.medium,
  ),
);

const _pieter = TAgent(
  'Pieter',
  id: 'pieter',
  identity: _developer,
  spawnConfig: TSpawnConfigDto(model: 'opus'),
);

TTask _task(TSpawnConfigDto? config) => TTask(
  dto: TTaskDto(
    id: 'fix_login',
    title: 'Fix login',
    body: 'Login fails.',
    createdAt: DateTime(2026, 9, 23),
    agentId: 'pieter',
    spawnConfig: config,
  ),
);

void main() {
  group('tSpawnConfigChain', () {
    test('Given an agent config, When chained, Then it overrides its role', () {
      final config = tSpawnConfigChain(agent: _pieter);

      expect(config.model, 'opus');
      expect(config.tool, TCliTool.pi);
      expect(config.effort, TEffort.medium);
    });

    test('Given a task config, When chained, Then it overrides its agent', () {
      final config = tSpawnConfigChain(
        agent: _pieter,
        item: _task(const TSpawnConfigDto(effort: TEffort.high)),
      );

      expect(config.effort, TEffort.high);
      expect(config.model, 'opus');
    });

    test(
      'Given no config sets a system prompt, Then the role prompt is used',
      () {
        final config = tSpawnConfigChain(agent: _pieter);

        expect(config.systemPrompt, _developer.toMd());
      },
    );

    test('Given a task system prompt, Then it replaces the role prompt', () {
      final config = tSpawnConfigChain(
        agent: _pieter,
        item: _task(const TSpawnConfigDto(systemPrompt: 'Only fix login.')),
      );

      expect(config.systemPrompt, 'Only fix login.');
    });

    test('Given a raw command on the task, Then the result is raw', () {
      final config = tSpawnConfigChain(
        agent: _pieter,
        item: _task(const TSpawnConfigDto(command: 'claude --resume abc')),
      );

      expect(config.isRaw, isTrue);
      expect(config.command, 'claude --resume abc');
    });

    test(
      'Given a role spawn without an agent, Then the role config is used',
      () {
        final config = tSpawnConfigChain(role: _developer);

        expect(config.model, 'sonnet');
        expect(config.isRaw, isFalse);
      },
    );
  });

  group('TSpawnConfigDto JSON', () {
    test(
      'Given a full config, When it round-trips JSON, Then no field is lost',
      () {
        const config = TSpawnConfigDto(
          tool: TCliTool.codex,
          model: 'gpt-5',
          systemPrompt: 'Be brief.',
          skills: ['review'],
          effort: TEffort.xhigh,
          workingFolder: '~/Repos/pew',
        );

        final copy = TSpawnConfigDto.fromJson(config.toJson());

        expect(copy.toJson(), config.toJson());
      },
    );
  });
}
