// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TInsight _$TInsightFromJson(Map<String, dynamic> json) => TInsight(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TInsightToJson(TInsight instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
