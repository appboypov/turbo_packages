// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearTeamDto _$TLinearTeamDtoFromJson(Map<String, dynamic> json) =>
    TLinearTeamDto(
      id: json['id'] as String,
      name: json['name'] as String,
      key: json['key'] as String,
      activeCycle: json['activeCycle'] == null
          ? null
          : TLinearActiveCycleDto.fromJson(
              json['activeCycle'] as Map<String, dynamic>,
            ),
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => TLinearTeamDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TLinearTeamDtoToJson(TLinearTeamDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'key': instance.key,
      'activeCycle': ?instance.activeCycle?.toJson(),
      'children': instance.children.map((e) => e.toJson()).toList(),
    };
