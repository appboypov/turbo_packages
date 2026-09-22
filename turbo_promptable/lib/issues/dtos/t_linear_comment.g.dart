// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearCommentDto _$TLinearCommentDtoFromJson(
  Map<String, dynamic> json,
) => TLinearCommentDto(
  id: json['id'] as String,
  body: json['body'] as String,
  quotedText: json['quotedText'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  url: json['url'] as String,
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
  resolvingCommentId: json['resolvingCommentId'] as String?,
  resolvingUser: json['resolvingUser'] == null
      ? null
      : TLinearUserDto.fromJson(json['resolvingUser'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : TLinearUserDto.fromJson(json['user'] as Map<String, dynamic>),
  externalUser: json['externalUser'] == null
      ? null
      : TLinearUserDto.fromJson(json['externalUser'] as Map<String, dynamic>),
  parent: json['parent'] == null
      ? null
      : TLinearCommentParentDto.fromJson(
          json['parent'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$TLinearCommentDtoToJson(TLinearCommentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'quotedText': ?instance.quotedText,
      'createdAt': instance.createdAt.toIso8601String(),
      'url': instance.url,
      'resolvedAt': ?instance.resolvedAt?.toIso8601String(),
      'resolvingCommentId': ?instance.resolvingCommentId,
      'resolvingUser': ?instance.resolvingUser?.toJson(),
      'user': ?instance.user?.toJson(),
      'externalUser': ?instance.externalUser?.toJson(),
      'parent': ?instance.parent?.toJson(),
    };
