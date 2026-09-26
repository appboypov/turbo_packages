// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TQuestionDto _$TQuestionDtoFromJson(Map<String, dynamic> json) => TQuestionDto(
  question: json['question'] as String,
  answer: json['answer'] as String?,
);

Map<String, dynamic> _$TQuestionDtoToJson(TQuestionDto instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': ?instance.answer,
    };
