import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/intents/dtos/t_body_dto.dart';

part 't_reference_dto.g.dart';

/// Material that something points to: a file, a link or content kept in place.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TReferenceDto {
  const TReferenceDto({required this.name, required this.body});

  /// Short name of the material.
  final String name;

  /// The content of the material.
  final TBodyDto body;

  factory TReferenceDto.fromJson(Map<String, dynamic> json) =>
      _$TReferenceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TReferenceDtoToJson(this);
}
