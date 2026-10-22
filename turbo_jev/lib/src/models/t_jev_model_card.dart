import 'package:json_annotation/json_annotation.dart';

import '../converters/t_jev_model_converter.dart';
import 't_jev_model.dart';

part 't_jev_model_card.g.dart';

/// A model the account can ask, as `TJev.models` lists it.
@JsonSerializable(
  checked: true,
  createToJson: false,
  fieldRename: FieldRename.snake,
)
final class TJevModelCard {
  const TJevModelCard({
    required this.name,
    required this.description,
    required this.releaseDate,
  });

  factory TJevModelCard.fromJson(Map<String, dynamic> json) =>
      _$TJevModelCardFromJson(json);

  /// The model id a Request can name, usually a Model Alias.
  @TJevModelConverter()
  final TJevModel name;

  /// What the model is for and what it can do.
  final String description;

  /// The release date as TypeSafe formats it, such as `2026-09-15`.
  final String releaseDate;
}
