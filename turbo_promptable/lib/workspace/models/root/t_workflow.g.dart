// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_workflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TWorkflow _$TWorkflowFromJson(Map<String, dynamic> json) => TWorkflow(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  steps: (json['steps'] as List<dynamic>)
      .map((e) => TStep.fromJson(e as Map<String, dynamic>))
      .toList(),
  endGoal: TEndGoal.fromJson(json['endGoal'] as Map<String, dynamic>),
  instructions: (json['instructions'] as List<dynamic>?)
      ?.map((e) => TInstruction.fromJson(e as Map<String, dynamic>))
      .toList(),
  tools: (json['tools'] as List<dynamic>?)
      ?.map((e) => TTool.fromJson(e as Map<String, dynamic>))
      .toList(),
  toolSets: (json['toolSets'] as List<dynamic>?)
      ?.map((e) => TToolSet.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TWorkflowToJson(TWorkflow instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
  'steps': instance.steps.map((e) => e.toJson()).toList(),
  'endGoal': instance.endGoal.toJson(),
  'instructions': ?instance.instructions?.map((e) => e.toJson()).toList(),
  'tools': ?instance.tools?.map((e) => e.toJson()).toList(),
  'toolSets': ?instance.toolSets?.map((e) => e.toJson()).toList(),
};
