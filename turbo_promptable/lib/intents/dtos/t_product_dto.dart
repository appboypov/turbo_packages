import 'package:json_annotation/json_annotation.dart';

part 't_product_dto.g.dart';

/// A product that work is done for.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TProductDto {
  const TProductDto({required this.id, required this.name, this.description});

  /// Unique product id.
  final String id;

  /// Name of the product.
  final String name;

  /// What the product is.
  final String? description;

  factory TProductDto.fromJson(Map<String, dynamic> json) =>
      _$TProductDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TProductDtoToJson(this);
}
