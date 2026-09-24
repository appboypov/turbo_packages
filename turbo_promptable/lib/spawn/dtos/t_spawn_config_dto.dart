import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/spawn/enums/t_cli_tool.dart';
import 'package:turbo_promptable/spawn/enums/t_effort.dart';

part 't_spawn_config_dto.g.dart';

/// How a session is spawned. Every field is optional; an unset field leaves
/// the decision to a less specific config or to the tool's own default.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TSpawnConfigDto {
  const TSpawnConfigDto({
    this.command,
    this.tool,
    this.model,
    this.systemPrompt,
    this.skills,
    this.effort,
    this.workingFolder,
    this.message,
  });

  /// Raw command that runs exactly as written. When set, the helper settings
  /// below are ignored.
  final String? command;

  /// Program that runs the session.
  final TCliTool? tool;

  /// Model id or alias passed to the tool.
  final String? model;

  /// Text added to the tool's system prompt.
  final String? systemPrompt;

  /// Skill names or paths the tool loads.
  final List<String>? skills;

  /// Reasoning effort of the model.
  final TEffort? effort;

  /// Folder the session starts in. `~` is the home folder; a relative path is
  /// read from the root of the package that declares the spawned entity.
  final String? workingFolder;

  /// First message the session starts with.
  final String? message;

  /// Whether this config runs [command] instead of the helper settings.
  bool get isRaw => command != null;

  /// This config with every non-null field of [child] on top.
  TSpawnConfigDto overriddenBy(TSpawnConfigDto? child) {
    if (child == null) return this;
    return TSpawnConfigDto(
      command: child.command ?? command,
      tool: child.tool ?? tool,
      model: child.model ?? model,
      systemPrompt: child.systemPrompt ?? systemPrompt,
      skills: child.skills ?? skills,
      effort: child.effort ?? effort,
      workingFolder: child.workingFolder ?? workingFolder,
      message: child.message ?? message,
    );
  }

  factory TSpawnConfigDto.fromJson(Map<String, dynamic> json) =>
      _$TSpawnConfigDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TSpawnConfigDtoToJson(this);
}
