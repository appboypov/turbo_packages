// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_noul_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TJevNoulQuestionDtoToJson(
  TJevNoulQuestionDto instance,
) => <String, dynamic>{
  'type': _$TJevQuestionTypeEnumMap[instance.type]!,
  'instructions': ?instance.instructions,
  'criteria': ?instance.criteria?.toJson(),
};

const _$TJevQuestionTypeEnumMap = {
  TJevQuestionType.noul: 'noul',
  TJevQuestionType.choice: 'choice',
  TJevQuestionType.score: 'score',
  TJevQuestionType.box: 'box',
};
