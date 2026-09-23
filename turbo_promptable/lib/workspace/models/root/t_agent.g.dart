// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_agent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TAgent<IDENTITY> _$TAgentFromJson<IDENTITY extends TRole>(
  Map<String, dynamic> json,
  IDENTITY Function(Object? json) fromJsonIDENTITY,
) => TAgent<IDENTITY>(
  json['name'] as String,
  id: json['id'] as String,
  identity: fromJsonIDENTITY(json['identity']),
  spawnConfig: json['spawnConfig'] == null
      ? null
      : TSpawnConfigDto.fromJson(json['spawnConfig'] as Map<String, dynamic>),
  workflow: json['workflow'] == null
      ? null
      : TWorkflow.fromJson(json['workflow'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TAgentToJson<IDENTITY extends TRole>(
  TAgent<IDENTITY> instance,
  Object? Function(IDENTITY value) toJsonIDENTITY,
) => <String, dynamic>{
  'name': instance.name,
  'id': instance.id,
  'identity': toJsonIDENTITY(instance.identity),
  'workflow': ?instance.workflow?.toJson(),
};
