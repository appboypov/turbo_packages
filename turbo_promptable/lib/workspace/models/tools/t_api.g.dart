// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TApi _$TApiFromJson(Map<String, dynamic> json) => TApi(
  name: json['name'] as String,
  description: json['description'] as String?,
  abilities: (json['abilities'] as List<dynamic>?)
      ?.map((e) => TToolAbility.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TApiToJson(TApi instance) => <String, dynamic>{
  'name': instance.name,
  'description': ?instance.description,
  'abilities': ?instance.abilities?.map((e) => e.toJson()).toList(),
};
