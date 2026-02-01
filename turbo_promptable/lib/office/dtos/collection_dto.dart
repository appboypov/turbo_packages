import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'collection_dto.g.dart';

/// Represents a collection of items in the Pew Pew Plaza hierarchy.
///
/// Collections are lists of items such as tools, glossaries, or any
/// grouped content that belongs to a role.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class CollectionDto extends TurboPromptable {
  /// Creates a [CollectionDto] with the given properties.
  CollectionDto({
    required this.items,
  });

  /// The items within this collection.
  ///
  /// A list of string items representing the collection contents.
  final List<String> items;

  static const fromJsonFactory = _$CollectionDtoFromJson;
  factory CollectionDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionDtoFromJson(json);
  static const toJsonFactory = _$CollectionDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$CollectionDtoToJson(this);

  @override
  String toString() => 'CollectionDto{items: $items}';

  CollectionDto copyWith({
    List<String>? items,
  }) =>
      CollectionDto(
        items: items ?? this.items,
      );
}
