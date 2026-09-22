// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearTeamDto _$TLinearTeamDtoFromJson(Map<String, dynamic> json) =>
    TLinearTeamDto(
      activeCycle: json['activeCycle'] == null
          ? null
          : TLinearActiveCycleDto.fromJson(
              json['activeCycle'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TLinearTeamDtoToJson(TLinearTeamDto instance) =>
    <String, dynamic>{'activeCycle': ?instance.activeCycle?.toJson()};
