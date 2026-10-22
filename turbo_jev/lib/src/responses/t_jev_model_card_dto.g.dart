// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_model_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevModelCardDto _$TJevModelCardDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TJevModelCardDto', json, ($checkedConvert) {
      final val = TJevModelCardDto(
        name: $checkedConvert(
          'name',
          (v) => const TJevModelConverter().fromJson(v as String),
        ),
        description: $checkedConvert('description', (v) => v as String),
        releaseDate: $checkedConvert('release_date', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'releaseDate': 'release_date'});
