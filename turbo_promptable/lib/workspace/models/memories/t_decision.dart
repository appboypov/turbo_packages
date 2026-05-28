import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_memory.dart';

part 't_decision.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TDecision extends TMemory {
  const TDecision({
    required super.name,
    super.metaData,
  });

  factory TDecision.fromJson(Map<String, dynamic> json) =>
      _$TDecisionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TDecisionToJson(this);
}
