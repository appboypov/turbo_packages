import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_comment_parent.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_user.dart';

part 't_linear_comment.g.dart';

/// Comment on a Linear issue.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearCommentDto {
  const TLinearCommentDto({
    required this.id,
    required this.body,
    this.quotedText,
    required this.createdAt,
    required this.url,
    this.resolvedAt,
    this.resolvingCommentId,
    this.resolvingUser,
    this.user,
    this.externalUser,
    this.parent,
  });

  final String id;
  final String body;
  final String? quotedText;
  final DateTime createdAt;
  final String url;
  final DateTime? resolvedAt;
  final String? resolvingCommentId;
  final TLinearUserDto? resolvingUser;
  final TLinearUserDto? user;
  final TLinearUserDto? externalUser;
  final TLinearCommentParentDto? parent;

  factory TLinearCommentDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearCommentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearCommentDtoToJson(this);
}
