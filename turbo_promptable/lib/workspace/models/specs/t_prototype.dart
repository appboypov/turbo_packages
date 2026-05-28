import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_abilities.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_features.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_issues.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_journeys.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_mockups.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_modules.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_prds.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_scenarios.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_prototype.g.dart';

/// An interactive prototype linked to features, modules, abilities, journeys, scenarios, issues, PRDs, and mockups.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TPrototype extends TSpec
    implements
        TOfAbilities,
        TOfFeatures,
        TOfModules,
        TOfJourneys,
        TOfScenarios,
        TOfIssues,
        TOfPrds,
        TOfMockups {
  const TPrototype({
    required super.name,
    super.metaData,
    this.featureIds,
    this.moduleIds,
    this.abilityIds,
    this.journeyIds,
    this.scenarioIds,
    this.issueIds,
    this.prdIds,
    this.mockupIds,
  });

  @override
  final List<String>? featureIds;
  @override
  final List<String>? moduleIds;
  @override
  final List<String>? abilityIds;
  @override
  final List<String>? journeyIds;
  @override
  final List<String>? scenarioIds;
  @override
  final List<String>? issueIds;
  @override
  final List<String>? prdIds;
  @override
  final List<String>? mockupIds;

  factory TPrototype.fromJson(Map<String, dynamic> json) =>
      _$TPrototypeFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TPrototypeToJson(this);
}
