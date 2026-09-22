// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearDocumentDto _$TLinearDocumentDtoFromJson(Map<String, dynamic> json) =>
    TLinearDocumentDto(
      id: json['id'] as String,
      title: json['title'] as String,
      slugId: json['slugId'] as String,
      url: json['url'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TLinearDocumentDtoToJson(TLinearDocumentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slugId': instance.slugId,
      'url': instance.url,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
