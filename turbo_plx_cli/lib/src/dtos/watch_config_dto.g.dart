// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchConfigDto _$WatchConfigDtoFromJson(Map<String, dynamic> json) =>
    WatchConfigDto(
      throttleMs: (json['throttle_ms'] as num?)?.toInt() ?? 1000,
      extensions: (json['extensions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['.md'],
      ignoreFolders: (json['ignore_folders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['.git', 'node_modules', 'build', '.dart_tool', '.plx'],
    );

Map<String, dynamic> _$WatchConfigDtoToJson(WatchConfigDto instance) =>
    <String, dynamic>{
      'throttle_ms': instance.throttleMs,
      'extensions': instance.extensions,
      'ignore_folders': instance.ignoreFolders,
    };
