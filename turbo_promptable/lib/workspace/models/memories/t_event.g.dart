// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TEvent _$TEventFromJson(Map<String, dynamic> json) => TEvent(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TEventToJson(TEvent instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
