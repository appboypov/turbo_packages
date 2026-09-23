import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_active_cycle.dart';

part 't_linear_team.g.dart';

/// Linear team, carrying its active cycle and sub teams.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearTeamDto {
  const TLinearTeamDto({
    required this.id,
    required this.name,
    required this.key,
    this.activeCycle,
    this.children = const [],
  });

  final String id;
  final String name;
  final String key;
  final TLinearActiveCycleDto? activeCycle;
  final List<TLinearTeamDto> children;

  factory TLinearTeamDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearTeamDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearTeamDtoToJson(this);
}
