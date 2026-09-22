import 'package:json_annotation/json_annotation.dart';

part 't_linear_comment_parent.g.dart';

/// Parent comment reference of a threaded Linear comment reply.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearCommentParentDto {
  const TLinearCommentParentDto({
    required this.id,
  });

  final String id;

  factory TLinearCommentParentDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearCommentParentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearCommentParentDtoToJson(this);
}
