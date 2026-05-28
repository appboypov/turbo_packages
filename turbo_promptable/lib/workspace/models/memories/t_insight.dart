import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_memory.dart';

part 't_insight.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TInsight extends TMemory {
  const TInsight({
    required super.name,
    super.metaData,
  });

  factory TInsight.fromJson(Map<String, dynamic> json) =>
      _$TInsightFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TInsightToJson(this);
}
