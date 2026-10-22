// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_models_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevModelsResponseDto _$TJevModelsResponseDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TJevModelsResponseDto', json, ($checkedConvert) {
  final val = TJevModelsResponseDto(
    models: $checkedConvert(
      'models',
      (v) => (v as List<dynamic>)
          .map((e) => TJevModelCardDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});
