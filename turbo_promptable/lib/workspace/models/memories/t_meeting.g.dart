// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TMeeting _$TMeetingFromJson(Map<String, dynamic> json) => TMeeting(
  name: json['name'] as String,
  metaData: json['metaData'] == null
      ? null
      : TMetaData.fromJson(json['metaData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TMeetingToJson(TMeeting instance) => <String, dynamic>{
  'name': instance.name,
  'metaData': ?instance.metaData?.toJson(),
};
