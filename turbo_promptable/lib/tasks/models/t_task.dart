import 'package:turbo_promptable/turbo_promptable.dart';

/// Local unit of work backed by a [TTaskDto].
class TTask implements TAgentBound {
  const TTask._({required this.dto});

  /// Creates a task in the inbox, created now.
  factory TTask.create({
    required String id,
    required String title,
    required String body,
    TAgent? agent,
    TSpawnConfigDto? spawnConfig,
  }) => TTask._(
    dto: TTaskDto(
      id: id,
      title: title,
      body: body,
      agentId: agent?.id,
      spawnConfig: spawnConfig ?? agent?.spawnConfig,
      createdAt: gNow,
    ),
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

  TTask _to(TTaskStatus status) => _copyWith(dto: dto.copyWith(status: status));

  TTask _copyWith({TTaskDto? dto}) => TTask._(dto: dto ?? this.dto);

  TTask withResult({
    TResult? result,
  }) => _copyWith(
    dto: dto.copyWith(
      result: result?.dto,
    ),
  );
}
