// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TStep _$TStepFromJson(Map<String, dynamic> json) => TStep(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  input: TInput.fromJson(json['input'] as Map<String, dynamic>),
  instructions: json['instructions'] as String?,
  output: TOutput.fromJson(json['output'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TStepToJson(TStep instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'input': instance.input.toJson(),
  'instructions': ?instance.instructions,
  'output': instance.output.toJson(),
};
