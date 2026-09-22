import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_active_cycle.dart';

part 't_linear_team.g.dart';

/// Team of a Linear issue, carrying its active cycle.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearTeamDto {
  const TLinearTeamDto({
    this.activeCycle,
  });

  final TLinearActiveCycleDto? activeCycle;

  factory TLinearTeamDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearTeamDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearTeamDtoToJson(this);
}
