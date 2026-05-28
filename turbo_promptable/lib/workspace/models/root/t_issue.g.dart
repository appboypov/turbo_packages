// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TIssue _$TIssueFromJson(Map<String, dynamic> json) => TIssue(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TIssueToJson(TIssue instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
