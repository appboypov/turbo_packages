import 'package:json_annotation/json_annotation.dart';

part 't_linear_label.g.dart';

/// Label on a Linear issue.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearLabelDto {
  const TLinearLabelDto({
    required this.id,
    required this.name,
    required this.color,
  });

  final String id;
  final String name;
  final String color;

  factory TLinearLabelDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearLabelDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearLabelDtoToJson(this);
}
