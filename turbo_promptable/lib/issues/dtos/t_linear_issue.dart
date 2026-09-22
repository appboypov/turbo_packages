import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_attachment.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_comment.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_connection.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_cycle.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_document.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_issue_ref.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_label.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_project.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_project_milestone.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_state.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_team.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_user.dart';

part 't_linear_issue.g.dart';

/// Linear issue as returned by `linear issue view --json`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearIssueDto {
  const TLinearIssueDto({
    required this.identifier,
    required this.title,
    this.description,
    required this.url,
    required this.branchName,
    required this.state,
    this.assignee,
    required this.priority,
    this.project,
    this.projectMilestone,
    this.cycle,
    required this.team,
    required this.labels,
    this.parent,
    required this.children,
    this.comments,
    required this.attachments,
    required this.documents,
  });

  final String identifier;
  final String title;
  final String? description;
  final String url;
  final String branchName;
  final TLinearStateDto state;
  final TLinearUserDto? assignee;
  final int priority;
  final TLinearProjectDto? project;
  final TLinearProjectMilestoneDto? projectMilestone;
  final TLinearCycleDto? cycle;
  final TLinearTeamDto team;
  final TLinearConnectionDto<TLinearLabelDto> labels;
  final TLinearIssueRefDto? parent;
  final TLinearConnectionDto<TLinearIssueRefDto> children;
  final TLinearConnectionDto<TLinearCommentDto>? comments;
  final TLinearConnectionDto<TLinearAttachmentDto> attachments;
  final TLinearConnectionDto<TLinearDocumentDto> documents;

  factory TLinearIssueDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearIssueDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearIssueDtoToJson(this);
}
