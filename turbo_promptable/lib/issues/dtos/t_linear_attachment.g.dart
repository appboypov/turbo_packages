// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearAttachmentDto _$TLinearAttachmentDtoFromJson(
  Map<String, dynamic> json,
) => TLinearAttachmentDto(
  id: json['id'] as String,
  title: json['title'] as String,
  url: json['url'] as String,
  subtitle: json['subtitle'] as String?,
  sourceType: json['sourceType'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TLinearAttachmentDtoToJson(
  TLinearAttachmentDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'url': instance.url,
  'subtitle': ?instance.subtitle,
  'sourceType': ?instance.sourceType,
  'metadata': instance.metadata,
  'createdAt': instance.createdAt.toIso8601String(),
};
