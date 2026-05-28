// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_prototype.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TPrototype _$TPrototypeFromJson(Map<String, dynamic> json) => TPrototype(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  featureIds: (json['featureIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  moduleIds: (json['moduleIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  abilityIds: (json['abilityIds'] as List<dynamic>?)
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
  mockupIds: (json['mockupIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TPrototypeToJson(TPrototype instance) =>
    <String, dynamic>{
      'name': instance.name,
      'metaData': ?instance.metaData?.toJson(),
      'featureIds': ?instance.featureIds,
      'moduleIds': ?instance.moduleIds,
      'abilityIds': ?instance.abilityIds,
      'journeyIds': ?instance.journeyIds,
      'scenarioIds': ?instance.scenarioIds,
      'issueIds': ?instance.issueIds,
      'prdIds': ?instance.prdIds,
      'mockupIds': ?instance.mockupIds,
    };
