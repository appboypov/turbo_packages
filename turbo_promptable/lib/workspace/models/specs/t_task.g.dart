// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTask _$TTaskFromJson(Map<String, dynamic> json) => TTask(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  issueIds: (json['issueIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  prdIds: (json['prdIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
  mockupIds: (json['mockupIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  prototypeIds: (json['prototypeIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TTaskToJson(TTask instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'issueIds': ?instance.issueIds,
  'prdIds': ?instance.prdIds,
  'mockupIds': ?instance.mockupIds,
  'prototypeIds': ?instance.prototypeIds,
};
