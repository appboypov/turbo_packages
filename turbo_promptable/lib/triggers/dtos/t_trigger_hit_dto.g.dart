// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_trigger_hit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTriggerHitDto _$TTriggerHitDtoFromJson(Map<String, dynamic> json) =>
    TTriggerHitDto(
      file: json['file'] as String,
      line: (json['line'] as num).toInt(),
      text: json['text'] as String,
      trigger: json['trigger'] as String?,
    );

Map<String, dynamic> _$TTriggerHitDtoToJson(TTriggerHitDto instance) =>
    <String, dynamic>{
      'file': instance.file,
      'line': instance.line,
      'text': instance.text,
      'trigger': ?instance.trigger,
    };
