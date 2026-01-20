// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileDto _$FileDtoFromJson(Map<String, dynamic> json) => FileDto(
      path: json['path'] as String,
      content: json['content'] as String?,
      lastModified: (json['lastModified'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FileDtoToJson(FileDto instance) => <String, dynamic>{
      'path': instance.path,
      'content': instance.content,
      'lastModified': instance.lastModified,
    };
