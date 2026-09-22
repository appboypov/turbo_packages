import 'package:json_annotation/json_annotation.dart';

part 't_linear_state.g.dart';

/// Workflow state of a Linear issue.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearStateDto {
  const TLinearStateDto({
    required this.name,
    required this.color,
  });

  final String name;
  final String color;

  factory TLinearStateDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearStateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearStateDtoToJson(this);
}
