import 'package:turbo_promptable/core/annotations/plxecutable.dart';
import 'package:turbo_promptable/core/globals/g_now.dart';
import 'package:turbo_promptable/spawn/abstracts/t_agent_bound.dart';
import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';
import 'package:turbo_promptable/tasks/dtos/t_task_dto.dart';
import 'package:turbo_promptable/tasks/enums/t_task_status.dart';

/// Local unit of work backed by a [TTaskDto].
class TTask implements TAgentBound {
  const TTask({required this.dto});

  /// Creates a task in the inbox, created now.
  factory TTask.create({
    required String id,
    required String title,
    required String body,
  }) => TTask(
    dto: TTaskDto(id: id, title: title, body: body, createdAt: gNow),
  );

  final TTaskDto dto;

  @override
  String get id => dto.id;

  @override
  String? get agentId => dto.agentId;

  @override
  TSpawnConfigDto? get spawnConfig => dto.spawnConfig;

  @Plxecutable()
  TTask toInbox() => _to(TTaskStatus.inbox);

  @Plxecutable()
  TTask toBacklog() => _to(TTaskStatus.backlog);

  @Plxecutable()
  TTask toPending() => _to(TTaskStatus.pending);

  @Plxecutable()
  TTask toReady() => _to(TTaskStatus.ready);

  @Plxecutable()
  TTask toInProgress() => _to(TTaskStatus.inProgress);

  @Plxecutable()
  TTask toDone() => _to(TTaskStatus.done);

  @Plxecutable()
  TTask toVerified() => _to(TTaskStatus.verified);

  @Plxecutable()
  TTask toCanceled() => _to(TTaskStatus.canceled);

  @Plxecutable()
  TTask toDuplicate() => _to(TTaskStatus.duplicate);

  TTask _to(TTaskStatus status) => copyWith(dto: dto.copyWith(status: status));

  TTask copyWith({TTaskDto? dto}) => TTask(dto: dto ?? this.dto);
}
