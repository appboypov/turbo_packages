// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_resolved_spawn_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TResolvedSpawnDto _$TResolvedSpawnDtoFromJson(Map<String, dynamic> json) =>
    TResolvedSpawnDto(
      concept: $enumDecode(_$TSpawnConceptEnumMap, json['concept']),
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      config: TSpawnConfigDto.fromJson(json['config'] as Map<String, dynamic>),
      sessionApp: $enumDecode(_$TSessionAppEnumMap, json['sessionApp']),
      agentId: json['agentId'] as String?,
    );

Map<String, dynamic> _$TResolvedSpawnDtoToJson(TResolvedSpawnDto instance) =>
    <String, dynamic>{
      'concept': _$TSpawnConceptEnumMap[instance.concept]!,
      'id': instance.id,
      'filePath': instance.filePath,
      'config': instance.config.toJson(),
      'sessionApp': _$TSessionAppEnumMap[instance.sessionApp]!,
      'agentId': ?instance.agentId,
    };

const _$TSpawnConceptEnumMap = {
  TSpawnConcept.agent: 'agent',
  TSpawnConcept.role: 'role',
  TSpawnConcept.task: 'task',
  TSpawnConcept.issue: 'issue',
};

const _$TSessionAppEnumMap = {TSessionApp.herdr: 'herdr'};
