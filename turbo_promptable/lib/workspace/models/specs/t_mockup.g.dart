// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_mockup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TMockup _$TMockupFromJson(Map<String, dynamic> json) => TMockup(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  abilityIds: (json['abilityIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  featureIds: (json['featureIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  moduleIds: (json['moduleIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  journeyIds: (json['journeyIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  scenarioIds: (json['scenarioIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  issueIds: (json['issueIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  prdIds: (json['prdIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$TMockupToJson(TMockup instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'abilityIds': ?instance.abilityIds,
  'featureIds': ?instance.featureIds,
  'moduleIds': ?instance.moduleIds,
  'journeyIds': ?instance.journeyIds,
  'scenarioIds': ?instance.scenarioIds,
  'issueIds': ?instance.issueIds,
  'prdIds': ?instance.prdIds,
};
