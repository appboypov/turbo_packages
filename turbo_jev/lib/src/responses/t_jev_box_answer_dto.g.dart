// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_box_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevBoxAnswerDto _$TJevBoxAnswerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TJevBoxAnswerDto', json, ($checkedConvert) {
      final val = TJevBoxAnswerDto(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$TJevQuestionTypeEnumMap, v),
        ),
        box: $checkedConvert(
          'box',
          (v) => TJevBoxCoordinatesDto.fromJson(v as Map<String, dynamic>),
        ),
        confidence: $checkedConvert(
          'confidence',
          (v) => (v as num?)?.toDouble(),
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
