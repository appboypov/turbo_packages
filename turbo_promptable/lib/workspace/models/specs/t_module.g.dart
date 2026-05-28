// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TModule _$TModuleFromJson(Map<String, dynamic> json) => TModule(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  projectIds: (json['projectIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TModuleToJson(TModule instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'projectIds': instance.projectIds,
};
