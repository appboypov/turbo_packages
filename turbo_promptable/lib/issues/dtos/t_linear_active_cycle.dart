import 'package:json_annotation/json_annotation.dart';

part 't_linear_active_cycle.g.dart';

/// Active cycle of a Linear team.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearActiveCycleDto {
  const TLinearActiveCycleDto({
    required this.number,
  });

  final int number;

  factory TLinearActiveCycleDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearActiveCycleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearActiveCycleDtoToJson(this);
}
