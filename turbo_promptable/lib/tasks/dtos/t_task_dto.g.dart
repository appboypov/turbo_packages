// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTaskDto _$TTaskDtoFromJson(Map<String, dynamic> json) => TTaskDto(
  title: json['title'] as String,
  feedback: json['feedback'] as String,
  file: json['file'] as String,
  line: (json['line'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  result: json['result'] == null
      ? null
      : TResultDto.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TTaskDtoToJson(TTaskDto instance) => <String, dynamic>{
  'title': instance.title,
  'feedback': instance.feedback,
  'file': instance.file,
  'line': instance.line,
  'createdAt': instance.createdAt.toIso8601String(),
  'result': ?instance.result?.toJson(),
};
