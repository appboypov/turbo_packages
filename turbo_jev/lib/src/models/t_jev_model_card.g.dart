// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_model_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevModelCard _$TJevModelCardFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TJevModelCard', json, ($checkedConvert) {
      final val = TJevModelCard(
        name: $checkedConvert(
          'name',
          (v) => const TJevModelConverter().fromJson(v as String),
        ),
        description: $checkedConvert('description', (v) => v as String),
        releaseDate: $checkedConvert('release_date', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'releaseDate': 'release_date'});
