// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_ability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TAbility _$TAbilityFromJson(Map<String, dynamic> json) => TAbility(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  featureIds: (json['featureIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  moduleIds: (json['moduleIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TAbilityToJson(TAbility instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'featureIds': instance.featureIds,
  'moduleIds': instance.moduleIds,
};
