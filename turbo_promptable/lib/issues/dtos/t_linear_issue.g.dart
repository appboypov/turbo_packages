// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearIssueDto _$TLinearIssueDtoFromJson(Map<String, dynamic> json) =>
    TLinearIssueDto(
      identifier: json['identifier'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      branchName: json['branchName'] as String,
      state: TLinearStateDto.fromJson(json['state'] as Map<String, dynamic>),
      assignee: json['assignee'] == null
          ? null
          : TLinearUserDto.fromJson(json['assignee'] as Map<String, dynamic>),
      priority: (json['priority'] as num).toInt(),
      project: json['project'] == null
          ? null
          : TLinearProjectDto.fromJson(json['project'] as Map<String, dynamic>),
      projectMilestone: json['projectMilestone'] == null
          ? null
          : TLinearProjectMilestoneDto.fromJson(
              json['projectMilestone'] as Map<String, dynamic>,
            ),
      cycle: json['cycle'] == null
          ? null
          : TLinearCycleDto.fromJson(json['cycle'] as Map<String, dynamic>),
      team: TLinearTeamDto.fromJson(json['team'] as Map<String, dynamic>),
      labels: TLinearConnectionDto<TLinearLabelDto>.fromJson(
        json['labels'] as Map<String, dynamic>,
        (value) => TLinearLabelDto.fromJson(value as Map<String, dynamic>),
      ),
      parent: json['parent'] == null
          ? null
          : TLinearIssueRefDto.fromJson(json['parent'] as Map<String, dynamic>),
      children: TLinearConnectionDto<TLinearIssueRefDto>.fromJson(
        json['children'] as Map<String, dynamic>,
        (value) => TLinearIssueRefDto.fromJson(value as Map<String, dynamic>),
      ),
      comments: json['comments'] == null
          ? null
          : TLinearConnectionDto<TLinearCommentDto>.fromJson(
              json['comments'] as Map<String, dynamic>,
              (value) =>
                  TLinearCommentDto.fromJson(value as Map<String, dynamic>),
            ),
      attachments: TLinearConnectionDto<TLinearAttachmentDto>.fromJson(
        json['attachments'] as Map<String, dynamic>,
        (value) => TLinearAttachmentDto.fromJson(value as Map<String, dynamic>),
      ),
      documents: TLinearConnectionDto<TLinearDocumentDto>.fromJson(
        json['documents'] as Map<String, dynamic>,
        (value) => TLinearDocumentDto.fromJson(value as Map<String, dynamic>),
      ),
    );

Map<String, dynamic> _$TLinearIssueDtoToJson(TLinearIssueDto instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'title': instance.title,
      'description': ?instance.description,
      'url': instance.url,
      'branchName': instance.branchName,
      'state': instance.state.toJson(),
      'assignee': ?instance.assignee?.toJson(),
      'priority': instance.priority,
      'project': ?instance.project?.toJson(),
      'projectMilestone': ?instance.projectMilestone?.toJson(),
      'cycle': ?instance.cycle?.toJson(),
      'team': instance.team.toJson(),
      'labels': instance.labels.toJson((value) => value.toJson()),
      'parent': ?instance.parent?.toJson(),
      'children': instance.children.toJson((value) => value.toJson()),
      'comments': ?instance.comments?.toJson((value) => value.toJson()),
      'attachments': instance.attachments.toJson((value) => value.toJson()),
      'documents': instance.documents.toJson((value) => value.toJson()),
    };
