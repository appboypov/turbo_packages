// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_system_one_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevSystemOneResponseDto _$TJevSystemOneResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TJevSystemOneResponseDto', json, ($checkedConvert) {
  final val = TJevSystemOneResponseDto(
    model: $checkedConvert(
      'model',
      (v) => const TJevModelConverter().fromJson(v as String),
    ),
    answers: $checkedConvert(
      'answers',
      (v) => (v as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
    ),
    usage: $checkedConvert(
      'usage',
      (v) => TJevUsageDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});
