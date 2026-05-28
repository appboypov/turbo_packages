import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_context.dart';

part 't_concept.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TConcept extends TContext {
  const TConcept({
    required super.name,
  });

  factory TConcept.fromJson(Map<String, dynamic> json) =>
      _$TConceptFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TConceptToJson(this);
}
