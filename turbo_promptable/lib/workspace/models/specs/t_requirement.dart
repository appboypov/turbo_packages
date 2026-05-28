import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_abilities.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_journeys.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_scenarios.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

export 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_requirement.g.dart';

/// Base class for requirements that reference abilities, journeys, and scenarios.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TRequirement extends TSpec
    implements TOfAbilities, TOfJourneys, TOfScenarios {
  const TRequirement({
    required super.name,
    super.metaData,
    required this.abilityIds,
    required this.journeyIds,
    required this.scenarioIds,
  });

  @override
  final List<String>? abilityIds;
  @override
  final List<String>? journeyIds;
  @override
  final List<String>? scenarioIds;

  factory TRequirement.fromJson(Map<String, dynamic> json) =>
      _$TRequirementFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TRequirementToJson(this);
}
