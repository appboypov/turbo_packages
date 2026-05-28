// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_end_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TEndGoal _$TEndGoalFromJson(Map<String, dynamic> json) => TEndGoal(
  json['value'] as String,
  name: json['name'] as String,
  acceptanceCriteria: json['acceptanceCriteria'] == null
      ? null
      : TAcceptanceCriteria.fromJson(
          json['acceptanceCriteria'] as Map<String, dynamic>,
        ),
  constraints: json['constraints'] == null
      ? null
      : TConstraints.fromJson(json['constraints'] as Map<String, dynamic>),
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TEndGoalToJson(TEndGoal instance) => <String, dynamic>{
  'name': instance.name,
  'value': ?instance.value,
  'metaData': ?instance.metaData?.toJson(),
  'acceptanceCriteria': ?instance.acceptanceCriteria?.toJson(),
  'constraints': ?instance.constraints?.toJson(),
};
