import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_features.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_modules.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_ability.g.dart';

/// A discrete capability that a system provides, linked to features and modules.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TAbility extends TSpec implements TOfFeatures, TOfModules {
  /// Creates an ability scoped to the given [featureIds] and [moduleIds].
  const TAbility({
    required super.name,
    super.metaData,
    required this.featureIds,
    required this.moduleIds,
  });

  /// TFeature identifiers linked to this ability.
  @override
  final List<String> featureIds;

  /// TModule identifiers linked to this ability.
  @override
  final List<String> moduleIds;

  /// Deserializes an [TAbility] from [json].
  factory TAbility.fromJson(Map<String, dynamic> json) =>
      _$TAbilityFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TAbilityToJson(this);
}
