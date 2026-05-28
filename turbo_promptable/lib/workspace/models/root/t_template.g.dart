// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTemplate _$TTemplateFromJson(Map<String, dynamic> json) => TTemplate(
  json['name'] as String,
  value: json['value'] as String?,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TTemplateToJson(TTemplate instance) => <String, dynamic>{
  'name': instance.name,
  'value': ?instance.value,
  'metaData': ?instance.metaData?.toJson(),
};
