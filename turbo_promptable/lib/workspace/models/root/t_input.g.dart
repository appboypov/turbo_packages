// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TInput _$TInputFromJson(Map<String, dynamic> json) => TInput(
  name: json['name'] as String,
  context: (json['context'] as List<dynamic>?)
      ?.map((e) => TContext.fromJson(e as Map<String, dynamic>))
      .toList(),
  goals: (json['goals'] as List<dynamic>?)
      ?.map((e) => TEndGoal.fromJson(e as Map<String, dynamic>))
      .toList(),
  issues: (json['issues'] as List<dynamic>?)
      ?.map((e) => TIssue.fromJson(e as Map<String, dynamic>))
      .toList(),
  specs: (json['specs'] as List<dynamic>?)
      ?.map((e) => TSpec.fromJson(e as Map<String, dynamic>))
      .toList(),
  parameters: (json['parameters'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  ),
);

Map<String, dynamic> _$TInputToJson(TInput instance) => <String, dynamic>{
  'name': instance.name,
  'context': ?instance.context?.map((e) => e.toJson()).toList(),
  'goals': ?instance.goals?.map((e) => e.toJson()).toList(),
  'issues': ?instance.issues?.map((e) => e.toJson()).toList(),
  'specs': ?instance.specs?.map((e) => e.toJson()).toList(),
  'parameters': ?instance.parameters,
};
