// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_trigger_contents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTriggerContents _$TTriggerContentsFromJson(Map<String, dynamic> json) =>
    TTriggerContents(
      kind: json['kind'] as String,
      hits: (json['hits'] as List<dynamic>)
          .map((e) => TTriggerHitDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      context: json['context'] as String? ?? '',
    );

Map<String, dynamic> _$TTriggerContentsToJson(TTriggerContents instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'hits': instance.hits.map((e) => e.toJson()).toList(),
      'context': instance.context,
    };
