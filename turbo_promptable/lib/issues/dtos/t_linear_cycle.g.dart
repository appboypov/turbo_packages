// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_cycle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearCycleDto _$TLinearCycleDtoFromJson(Map<String, dynamic> json) =>
    TLinearCycleDto(
      id: json['id'] as String,
      number: (json['number'] as num).toInt(),
      name: json['name'] as String?,
      isActive: json['isActive'] as bool,
      isNext: json['isNext'] as bool,
      isPrevious: json['isPrevious'] as bool,
      isFuture: json['isFuture'] as bool,
      isPast: json['isPast'] as bool,
    );

Map<String, dynamic> _$TLinearCycleDtoToJson(TLinearCycleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'name': ?instance.name,
      'isActive': instance.isActive,
      'isNext': instance.isNext,
      'isPrevious': instance.isPrevious,
      'isFuture': instance.isFuture,
      'isPast': instance.isPast,
    };
