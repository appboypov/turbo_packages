// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTaskDto _$TTaskDtoFromJson(Map<String, dynamic> json) => TTaskDto(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  status:
      $enumDecodeNullable(_$TTaskStatusEnumMap, json['status']) ??
      TTaskStatus.inbox,
  result: json['result'] == null
      ? null
      : TResultDto.fromJson(json['result'] as Map<String, dynamic>),
  agentId: json['agentId'] as String?,
  spawnConfig: json['spawnConfig'] == null
      ? null
      : TSpawnConfigDto.fromJson(json['spawnConfig'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TTaskDtoToJson(TTaskDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'createdAt': instance.createdAt.toIso8601String(),
  'status': _$TTaskStatusEnumMap[instance.status]!,
  'result': ?instance.result?.toJson(),
  'agentId': ?instance.agentId,
  'spawnConfig': ?instance.spawnConfig?.toJson(),
};

const _$TTaskStatusEnumMap = {
  TTaskStatus.inbox: 'inbox',
  TTaskStatus.backlog: 'backlog',
  TTaskStatus.pending: 'pending',
  TTaskStatus.ready: 'ready',
  TTaskStatus.inProgress: 'inProgress',
  TTaskStatus.done: 'done',
  TTaskStatus.verified: 'verified',
  TTaskStatus.canceled: 'canceled',
  TTaskStatus.duplicate: 'duplicate',
};
