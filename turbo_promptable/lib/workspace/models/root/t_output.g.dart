// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TOutput _$TOutputFromJson(Map<String, dynamic> json) => TOutput(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  criteria: json['criteria'] == null
      ? null
      : TChecklist.fromJson(json['criteria'] as Map<String, dynamic>),
  constraints: json['constraints'] == null
      ? null
      : TChecklist.fromJson(json['constraints'] as Map<String, dynamic>),
  schema: json['schema'] as String,
);

Map<String, dynamic> _$TOutputToJson(TOutput instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'criteria': ?instance.criteria?.toJson(),
  'constraints': ?instance.constraints?.toJson(),
  'schema': instance.schema,
};
