// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TReference _$TReferenceFromJson(Map<String, dynamic> json) => TReference(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TReferenceToJson(TReference instance) =>
    <String, dynamic>{
      'name': instance.name,
      'metaData': ?instance.metaData?.toJson(),
    };
