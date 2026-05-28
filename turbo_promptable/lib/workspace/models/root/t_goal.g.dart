// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TGoal _$TGoalFromJson(Map<String, dynamic> json) => TGoal(
  json['value'] as String,
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TGoalToJson(TGoal instance) => <String, dynamic>{
  'name': instance.name,
  'value': ?instance.value,
  'metaData': ?instance.metaData?.toJson(),
};
