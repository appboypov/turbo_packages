// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_system_one_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TJevSystemOneRequestDtoToJson(
  TJevSystemOneRequestDto instance,
) => <String, dynamic>{
  'model': const TJevModelConverter().toJson(instance.model),
  'state': instance.state,
  'questions': instance.questions.map((k, e) => MapEntry(k, e.toJson())),
};
