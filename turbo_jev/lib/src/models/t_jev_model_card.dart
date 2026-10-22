import 'package:meta/meta.dart';

import '../responses/t_jev_model_card_dto.dart';
import '../types/t_jev_model.dart';

/// A model the account can ask, as `TJev.models` lists it.
final class TJevModelCard {
  const TJevModelCard({
    required this.name,
    required this.description,
    required this.releaseDate,
  });

  /// The model card of [dto].
  @internal
  factory TJevModelCard.fromDto(TJevModelCardDto dto) => TJevModelCard(
    name: dto.name,
    description: dto.description,
    releaseDate: dto.releaseDate,
  );

  // 🎩 STATE

  /// The model id a Request can name, usually a Model Alias.
  final TJevModel name;

  /// What the model is for and what it can do.
  final String description;

  /// The release date as TypeSafe formats it, such as `2026-09-15`.
  final String releaseDate;
}
