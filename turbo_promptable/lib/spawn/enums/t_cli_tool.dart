import 'dart:convert';

import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';
import 'package:turbo_promptable/spawn/enums/t_effort.dart';
import 'package:turbo_promptable/spawn/exceptions/t_unsupported_spawn_setting_exception.dart';

/// Program that runs a spawned agent session.
///
/// Each tool owns its own flag words. A fragment method returns null when the
/// tool has no way to express that setting.
enum TCliTool {
  pi,
  claude,
  codex,
  cursor,
  ;

  /// Executable name resolved through PATH.
  String get executable => switch (this) {
    TCliTool.pi => 'pi',
    TCliTool.claude => 'claude',
    TCliTool.codex => 'codex',
    TCliTool.cursor => 'cursor-agent',
  };

  List<String> modelArgs(String model) => switch (this) {
    TCliTool.codex => ['-m', model],
    TCliTool.pi || TCliTool.claude || TCliTool.cursor => ['--model', model],
  };

  List<String>? effortArgs(TEffort effort) => switch (this) {
    TCliTool.pi => ['--thinking', effort.name],
    TCliTool.claude => ['--effort', effort.name],
    TCliTool.codex =>
      effort == TEffort.max
          ? null
          : ['-c', 'model_reasoning_effort="${effort.name}"'],
    TCliTool.cursor => null,
  };

  List<String>? systemPromptArgs(String systemPrompt) => switch (this) {
    TCliTool.pi || TCliTool.claude => ['--append-system-prompt', systemPrompt],
    TCliTool.codex => [
      '-c',
      'developer_instructions=${jsonEncode(systemPrompt)}',
    ],
    TCliTool.cursor => null,
  };

  List<String>? skillArgs(List<String> skills) => switch (this) {
    TCliTool.pi => [
      for (final skill in skills) ...['--skill', skill],
    ],
    TCliTool.claude || TCliTool.codex || TCliTool.cursor => null,
  };

  /// Full argv for [config]'s helper settings, with its first message last.
  ///
  /// Throws [TUnsupportedSpawnSettingException] when [config] sets a setting
  /// this tool cannot express. Empty strings and lists count as not set.
  List<String> argv({required TSpawnConfigDto config}) {
    List<String> require(String setting, List<String>? args) =>
        args ??
        (throw TUnsupportedSpawnSettingException(tool: this, setting: setting));

    final model = config.model;
    final effort = config.effort;
    final systemPrompt = config.systemPrompt;
    final skills = config.skills;
    final firstMessage = config.firstMessage;
    return [
      executable,
      if (model != null && model.isNotEmpty) ...modelArgs(model),
      if (effort != null) ...require('effort', effortArgs(effort)),
      if (systemPrompt != null && systemPrompt.isNotEmpty)
        ...require('systemPrompt', systemPromptArgs(systemPrompt)),
      if (skills != null && skills.isNotEmpty)
        ...require('skills', skillArgs(skills)),
      if (firstMessage != null && firstMessage.isNotEmpty) firstMessage,
    ];
  }
}
