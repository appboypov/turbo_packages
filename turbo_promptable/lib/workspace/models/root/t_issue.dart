import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_issue.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TIssue extends TPromptable {
  const TIssue({
    required super.name,
    super.metaData,
  });

  factory TIssue.fromJson(Map<String, dynamic> json) => _$TIssueFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TIssueToJson(this);
}
