// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_trigger_kind_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTriggerKindDto _$TTriggerKindDtoFromJson(Map<String, dynamic> json) =>
    TTriggerKindDto(
      name: json['name'] as String,
      start: json['start'] as String,
      contains: json['contains'] as String?,
      end: json['end'] as String,
      command: json['command'] as String?,
    );

Map<String, dynamic> _$TTriggerKindDtoToJson(TTriggerKindDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'start': instance.start,
      'contains': ?instance.contains,
      'end': instance.end,
      'command': ?instance.command,
    };
