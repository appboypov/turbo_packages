// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_score_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevScoreAnswerDto _$TJevScoreAnswerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TJevScoreAnswerDto', json, ($checkedConvert) {
      final val = TJevScoreAnswerDto(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$TJevQuestionTypeEnumMap, v),
        ),
        score: $checkedConvert('score', (v) => (v as num).toDouble()),
        confidence: $checkedConvert('confidence', (v) => (v as num).toDouble()),
        legend: $checkedConvert('legend', (v) => v as Map<String, dynamic>),
        probabilities: $checkedConvert(
          'probabilities',
          (v) => (v as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
        ),
      );
      return val;
    });

const _$TJevQuestionTypeEnumMap = {
  TJevQuestionType.noul: 'noul',
  TJevQuestionType.choice: 'choice',
  TJevQuestionType.score: 'score',
  TJevQuestionType.box: 'box',
};
