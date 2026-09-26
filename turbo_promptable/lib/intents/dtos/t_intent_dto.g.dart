// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_intent_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TIntentDto _$TIntentDtoFromJson(Map<String, dynamic> json) => TIntentDto(
  id: json['id'] as String,
  userRequests: (json['userRequests'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  endGoal: json['endGoal'] as String,
  team: json['team'] == null
      ? null
      : TLinearTeamDto.fromJson(json['team'] as Map<String, dynamic>),
  product: json['product'] == null
      ? null
      : TProductDto.fromJson(json['product'] as Map<String, dynamic>),
  repo: json['repo'] == null
      ? null
      : TRepoDto.fromJson(json['repo'] as Map<String, dynamic>),
  issue: json['issue'] == null
      ? null
      : TLinearIssueDto.fromJson(json['issue'] as Map<String, dynamic>),
  changeId: json['changeId'] as String?,
  conversation: json['conversation'] as String?,
  reason: json['reason'] as String?,
  openQuestions:
      (json['openQuestions'] as List<dynamic>?)
          ?.map((e) => TQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  material:
      (json['material'] as List<dynamic>?)
          ?.map((e) => TReferenceDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TIntentDtoToJson(TIntentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userRequests': instance.userRequests,
      'endGoal': instance.endGoal,
      'team': ?instance.team?.toJson(),
      'product': ?instance.product?.toJson(),
      'repo': ?instance.repo?.toJson(),
      'issue': ?instance.issue?.toJson(),
      'changeId': ?instance.changeId,
      'conversation': ?instance.conversation,
      'reason': ?instance.reason,
      'openQuestions': instance.openQuestions.map((e) => e.toJson()).toList(),
      'material': instance.material.map((e) => e.toJson()).toList(),
    };
