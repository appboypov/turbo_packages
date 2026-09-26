// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_body_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TBodyDto _$TBodyDtoFromJson(Map<String, dynamic> json) => TBodyDto(
  bodySource: $enumDecode(_$TBodySourceEnumMap, json['bodySource']),
  contentType: $enumDecode(_$TContentTypeEnumMap, json['contentType']),
  body: json['body'] as String,
);

Map<String, dynamic> _$TBodyDtoToJson(TBodyDto instance) => <String, dynamic>{
  'bodySource': _$TBodySourceEnumMap[instance.bodySource]!,
  'contentType': _$TContentTypeEnumMap[instance.contentType]!,
  'body': instance.body,
};

const _$TBodySourceEnumMap = {
  TBodySource.content: 'content',
  TBodySource.path: 'path',
  TBodySource.url: 'url',
};

const _$TContentTypeEnumMap = {
  TContentType.json: 'json',
  TContentType.yaml: 'yaml',
  TContentType.md: 'md',
  TContentType.html: 'html',
  TContentType.mdx: 'mdx',
  TContentType.text: 'text',
  TContentType.pdf: 'pdf',
  TContentType.url: 'url',
  TContentType.image: 'image',
  TContentType.audio: 'audio',
  TContentType.video: 'video',
  TContentType.file: 'file',
};
