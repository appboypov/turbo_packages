// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_system_one_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevSystemOneResponseDto _$TJevSystemOneResponseDtoFromJson(
  Map<String, dynamic> json,
) => TJevSystemOneResponseDto(
  model: json['model'] as String,
  answers: (json['answers'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, e as Map<String, dynamic>),
  ),
  usage: TJevUsage.fromJson(json['usage'] as Map<String, dynamic>),
);
