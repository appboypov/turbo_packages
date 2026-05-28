import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_acceptance_criteria.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TAcceptanceCriteria extends TChecklist {
  const TAcceptanceCriteria(List<String> items)
    : super(
        name: 'Acceptance Criteria',
        items: items,
      );

  factory TAcceptanceCriteria.fromJson(Map<String, dynamic> json) =>
      _$TAcceptanceCriteriaFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TAcceptanceCriteriaToJson(this);
}
