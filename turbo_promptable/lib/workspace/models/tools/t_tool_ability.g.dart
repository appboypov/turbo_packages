// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_tool_ability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TToolAbility _$TToolAbilityFromJson(Map<String, dynamic> json) => TToolAbility(
  name: json['name'] as String,
  description: json['description'] as String?,
  input: TInput.fromJson(json['input'] as Map<String, dynamic>),
  output: TOutput.fromJson(json['output'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TToolAbilityToJson(TToolAbility instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': ?instance.description,
      'input': instance.input.toJson(),
      'output': instance.output.toJson(),
    };
