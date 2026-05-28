import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/specs/t_requirement.dart';

part 't_fr.g.dart';

/// A functional requirement linked to abilities, journeys, and scenarios.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TFR extends TRequirement {
  TFR({
    required super.name,
    super.metaData,
    super.abilityIds,
    super.journeyIds,
    super.scenarioIds,
  });

  factory TFR.fromJson(Map<String, dynamic> json) => _$TFRFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TFRToJson(this);
}
