// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_noul_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevNoulAnswerDto _$TJevNoulAnswerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TJevNoulAnswerDto', json, ($checkedConvert) {
      final val = TJevNoulAnswerDto(
        type: $checkedConvert('type', (v) => v as String),
        noul: $checkedConvert('noul', (v) => (v as num).toDouble()),
      );
      return val;
    });
