import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/results/dtos/t_result_dto.dart';
import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';
import 'package:turbo_promptable/tasks/enums/t_task_status.dart';

part 't_task_dto.g.dart';

/// Local unit of work.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TTaskDto {
  const TTaskDto({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.status = TTaskStatus.inbox,
    this.result,
    this.agentId,
    this.spawnConfig,
  });

  /// Unique task id, used by `plx spawn task --id <id>`.
  final String id;

  /// Verb-first summary of the work.
  final String title;

  /// What the work requires.
  final String body;

  /// When the task was created.
  final DateTime createdAt;

  /// Where the task is in its workflow.
  final TTaskStatus status;

  /// Set once the task is finished.
  final TResultDto? result;

  /// Agent that runs the task; the default agent runs it when null.
  final String? agentId;

  /// How the task's session is spawned; overrides its agent's config.
  final TSpawnConfigDto? spawnConfig;

  factory TTaskDto.fromJson(Map<String, dynamic> json) =>
      _$TTaskDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TTaskDtoToJson(this);

  TTaskDto copyWith({
    String? title,
    String? body,
    TTaskStatus? status,
    TResultDto? result,
  }) {
    return TTaskDto(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt,
      status: status ?? this.status,
      result: result ?? this.result,
      agentId: agentId,
      spawnConfig: spawnConfig,
    );
  }
}
