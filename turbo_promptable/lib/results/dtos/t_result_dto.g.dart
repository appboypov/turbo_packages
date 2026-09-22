// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TResultDto _$TResultDtoFromJson(Map<String, dynamic> json) => TResultDto(
  summary: json['summary'] as String,
  completedAt: DateTime.parse(json['completedAt'] as String),
  values:
      (json['values'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$TResultDtoToJson(TResultDto instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'completedAt': instance.completedAt.toIso8601String(),
      'values': instance.values,
    };
