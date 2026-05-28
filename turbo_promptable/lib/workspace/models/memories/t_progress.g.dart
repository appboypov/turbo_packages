// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TProgress _$TProgressFromJson(Map<String, dynamic> json) => TProgress(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TProgressToJson(TProgress instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
