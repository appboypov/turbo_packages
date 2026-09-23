// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TIssue _$TIssueFromJson(Map<String, dynamic> json) => TIssue(
  id: json['id'] as String,
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  agentId: json['agentId'] as String?,
  spawnConfig: json['spawnConfig'] == null
      ? null
      : TSpawnConfigDto.fromJson(json['spawnConfig'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TIssueToJson(TIssue instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'id': instance.id,
  'agentId': ?instance.agentId,
};
