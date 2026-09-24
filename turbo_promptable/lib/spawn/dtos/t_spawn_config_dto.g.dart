// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_spawn_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TSpawnConfigDto _$TSpawnConfigDtoFromJson(Map<String, dynamic> json) =>
    TSpawnConfigDto(
      command: json['command'] as String?,
      tool: $enumDecodeNullable(_$TCliToolEnumMap, json['tool']),
      model: json['model'] as String?,
      systemPrompt: json['systemPrompt'] as String?,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      effort: $enumDecodeNullable(_$TEffortEnumMap, json['effort']),
      workingFolder: json['workingFolder'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$TSpawnConfigDtoToJson(TSpawnConfigDto instance) =>
    <String, dynamic>{
      'command': ?instance.command,
      'tool': ?_$TCliToolEnumMap[instance.tool],
      'model': ?instance.model,
      'systemPrompt': ?instance.systemPrompt,
      'skills': ?instance.skills,
      'effort': ?_$TEffortEnumMap[instance.effort],
      'workingFolder': ?instance.workingFolder,
      'message': ?instance.message,
    };

const _$TCliToolEnumMap = {
  TCliTool.pi: 'pi',
  TCliTool.claude: 'claude',
  TCliTool.codex: 'codex',
  TCliTool.cursor: 'cursor',
};

const _$TEffortEnumMap = {
  TEffort.low: 'low',
  TEffort.medium: 'medium',
  TEffort.high: 'high',
  TEffort.xhigh: 'xhigh',
  TEffort.max: 'max',
};
