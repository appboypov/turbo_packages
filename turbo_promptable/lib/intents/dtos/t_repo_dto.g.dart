// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_repo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TRepoDto _$TRepoDtoFromJson(Map<String, dynamic> json) => TRepoDto(
  id: json['id'] as String,
  name: json['name'] as String,
  path: json['path'] as String,
  url: json['url'] as String?,
);

Map<String, dynamic> _$TRepoDtoToJson(TRepoDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'path': instance.path,
  'url': ?instance.url,
};
