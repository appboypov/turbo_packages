// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_decision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TDecision _$TDecisionFromJson(Map<String, dynamic> json) => TDecision(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TDecisionToJson(TDecision instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
