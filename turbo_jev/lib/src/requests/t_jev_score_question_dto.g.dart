// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_score_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TJevScoreQuestionDtoToJson(
  TJevScoreQuestionDto instance,
) => <String, dynamic>{
  'type': _$TJevQuestionTypeEnumMap[instance.type]!,
  'instructions': ?instance.instructions,
  'criteria': instance.criteria,
};

const _$TJevQuestionTypeEnumMap = {
  TJevQuestionType.noul: 'noul',
  TJevQuestionType.choice: 'choice',
  TJevQuestionType.score: 'score',
  TJevQuestionType.box: 'box',
};
