import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_context.dart';

part 't_stakeholder.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TStakeholder extends TContext {
  const TStakeholder({
    required super.name,
  });

  factory TStakeholder.fromJson(Map<String, dynamic> json) =>
      _$TStakeholderFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TStakeholderToJson(this);
}
