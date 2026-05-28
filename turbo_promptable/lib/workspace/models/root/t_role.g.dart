// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TRole _$TRoleFromJson(Map<String, dynamic> json) => TRole(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  expertise: json['expertise'] as String,
  instructions: (json['instructions'] as List<dynamic>?)
      ?.map((e) => TInstruction.fromJson(e as Map<String, dynamic>))
      .toList(),
  tools: (json['tools'] as List<dynamic>?)
      ?.map((e) => TTool.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TRoleToJson(TRole instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'instructions': ?instance.instructions?.map((e) => e.toJson()).toList(),
  'tools': ?instance.tools?.map((e) => e.toJson()).toList(),
  'expertise': instance.expertise,
};
