// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_noul_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevNoulAnswerDto _$TJevNoulAnswerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TJevNoulAnswerDto', json, ($checkedConvert) {
      final val = TJevNoulAnswerDto(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$TJevQuestionTypeEnumMap, v),
        ),
        noul: $checkedConvert('noul', (v) => (v as num).toDouble()),
      );
      return val;
    });

const _$TJevQuestionTypeEnumMap = {
  TJevQuestionType.noul: 'noul',
  TJevQuestionType.choice: 'choice',
  TJevQuestionType.score: 'score',
  TJevQuestionType.box: 'box',
};
