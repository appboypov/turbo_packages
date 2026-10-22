// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_box_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TJevBoxQuestionDtoToJson(TJevBoxQuestionDto instance) =>
    <String, dynamic>{
      'type': _$TJevQuestionTypeEnumMap[instance.type]!,
      'instructions': ?instance.instructions,
    };

const _$TJevQuestionTypeEnumMap = {
  TJevQuestionType.noul: 'noul',
  TJevQuestionType.choice: 'choice',
  TJevQuestionType.score: 'score',
  TJevQuestionType.box: 'box',
};
