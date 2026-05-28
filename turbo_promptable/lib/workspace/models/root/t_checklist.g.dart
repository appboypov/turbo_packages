// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_checklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TChecklist _$TChecklistFromJson(Map<String, dynamic> json) => TChecklist(
  name: json['name'] as String,
  items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$TChecklistToJson(TChecklist instance) =>
    <String, dynamic>{'name': instance.name, 'items': instance.items};
