// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_issue_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearIssueRefDto _$TLinearIssueRefDtoFromJson(Map<String, dynamic> json) =>
    TLinearIssueRefDto(
      identifier: json['identifier'] as String,
      title: json['title'] as String,
      state: TLinearStateDto.fromJson(json['state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TLinearIssueRefDtoToJson(TLinearIssueRefDto instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'title': instance.title,
      'state': instance.state.toJson(),
    };
