// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_choice_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevChoiceAnswerDto _$TJevChoiceAnswerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TJevChoiceAnswerDto', json, ($checkedConvert) {
      final val = TJevChoiceAnswerDto(
        type: $checkedConvert('type', (v) => v as String),
        choice: $checkedConvert('choice', (v) => v as String),
        confidence: $checkedConvert('confidence', (v) => (v as num).toDouble()),
        probabilities: $checkedConvert(
          'probabilities',
          (v) => (v as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
        ),
      );
      return val;
    });
