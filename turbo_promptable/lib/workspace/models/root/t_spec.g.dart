// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TSpec _$TSpecFromJson(Map<String, dynamic> json) => TSpec(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TSpecToJson(TSpec instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
