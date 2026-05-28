// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TFeature _$TFeatureFromJson(Map<String, dynamic> json) => TFeature(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  projectIds: (json['projectIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TFeatureToJson(TFeature instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'projectIds': instance.projectIds,
};
