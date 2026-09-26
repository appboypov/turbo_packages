// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_reference_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TReferenceDto _$TReferenceDtoFromJson(Map<String, dynamic> json) =>
    TReferenceDto(
      name: json['name'] as String,
      body: TBodyDto.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TReferenceDtoToJson(TReferenceDto instance) =>
    <String, dynamic>{'name': instance.name, 'body': instance.body.toJson()};
