import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_active_cycle.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_team.dart';

part 't_organisation_dto.g.dart';

/// An organisation, used wherever a Linear team is expected.
///
/// JSON does not record that a team is an organisation, so one read back from
/// JSON is a [TLinearTeamDto].
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TOrganisationDto extends TLinearTeamDto {
  const TOrganisationDto({
    required super.id,
    required super.name,
    required super.key,
    super.activeCycle,
    super.children,
  });

  factory TOrganisationDto.fromJson(Map<String, dynamic> json) =>
      _$TOrganisationDtoFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TOrganisationDtoToJson(this);
}
