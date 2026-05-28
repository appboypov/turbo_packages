import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_abilities.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_features.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_issues.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_journeys.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_modules.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_prds.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_scenarios.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_mockup.g.dart';

/// A visual mockup linked to abilities, features, modules, journeys, scenarios, issues, and PRDs.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TMockup extends TSpec
    implements
        TOfAbilities,
        TOfFeatures,
        TOfModules,
        TOfJourneys,
        TOfScenarios,
        TOfIssues,
        TOfPrds {
  const TMockup({
    required super.name,
    super.metaData,
    this.abilityIds,
    this.featureIds,
    this.moduleIds,
    this.journeyIds,
    this.scenarioIds,
    this.issueIds,
    this.prdIds,
  });

  @override
  final List<String>? abilityIds;
  @override
  final List<String>? featureIds;
  @override
  final List<String>? moduleIds;
  @override
  final List<String>? journeyIds;
  @override
  final List<String>? scenarioIds;
  @override
  final List<String>? issueIds;
  @override
  final List<String>? prdIds;

  factory TMockup.fromJson(Map<String, dynamic> json) =>
      _$TMockupFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TMockupToJson(this);
}
