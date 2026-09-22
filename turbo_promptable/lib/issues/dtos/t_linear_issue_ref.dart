import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_state.dart';

part 't_linear_issue_ref.g.dart';

/// Parent or sub-issue reference of a Linear issue.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearIssueRefDto {
  const TLinearIssueRefDto({
    required this.identifier,
    required this.title,
    required this.state,
  });

  final String identifier;
  final String title;
  final TLinearStateDto state;

  factory TLinearIssueRefDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearIssueRefDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearIssueRefDtoToJson(this);
}
