import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

part 't_output.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TOutput extends TPromptable {
  const TOutput({
    required super.name,
    super.metaData,
    this.criteria,
    this.constraints,
    required this.schema,
  });

  final TChecklist? criteria;
  final TChecklist? constraints;
  final String schema;

  factory TOutput.fromJson(Map<String, dynamic> json) =>
      _$TOutputFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TOutputToJson(this);
}
