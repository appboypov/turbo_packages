// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TProductDto _$TProductDtoFromJson(Map<String, dynamic> json) => TProductDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$TProductDtoToJson(TProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': ?instance.description,
    };
