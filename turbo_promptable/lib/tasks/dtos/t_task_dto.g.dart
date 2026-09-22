// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTaskDto _$TTaskDtoFromJson(Map<String, dynamic> json) => TTaskDto(
  title: json['title'] as String,
  description: json['description'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  result: json['result'] == null
      ? null
      : TResultDto.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TTaskDtoToJson(TTaskDto instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
  'result': ?instance.result?.toJson(),
};
