import 'package:json_annotation/json_annotation.dart';

import '../converters/t_jev_model_converter.dart';
import '../types/t_jev_model.dart';

part 't_jev_model_card_dto.g.dart';

/// The wire form of one model in the models list.
@JsonSerializable(
  checked: true,
  createToJson: false,
  fieldRename: FieldRename.snake,
)
final class TJevModelCardDto {
  const TJevModelCardDto({
    required this.name,
    required this.description,
    required this.releaseDate,
  });

  factory TJevModelCardDto.fromJson(Map<String, dynamic> json) =>
      _$TJevModelCardDtoFromJson(json);

  // 🎩 STATE

  @TJevModelConverter()
  final TJevModel name;

  final String description;

  final String releaseDate;
}
