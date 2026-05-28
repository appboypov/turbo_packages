// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_persona.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TPersona _$TPersonaFromJson(Map<String, dynamic> json) => TPersona(
  name: json['name'] as String,
  expertise: json['expertise'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  instructions: (json['instructions'] as List<dynamic>?)
      ?.map((e) => TInstruction.fromJson(e as Map<String, dynamic>))
      .toList(),
  tools: (json['tools'] as List<dynamic>?)
      ?.map((e) => TTool.fromJson(e as Map<String, dynamic>))
      .toList(),
  identity: json['identity'] as String?,
);

Map<String, dynamic> _$TPersonaToJson(TPersona instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'instructions': ?instance.instructions?.map((e) => e.toJson()).toList(),
  'tools': ?instance.tools?.map((e) => e.toJson()).toList(),
  'expertise': instance.expertise,
  'identity': ?instance.identity,
};
