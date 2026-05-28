// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TMemory _$TMemoryFromJson(Map<String, dynamic> json) => TMemory(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TMemoryToJson(TMemory instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
