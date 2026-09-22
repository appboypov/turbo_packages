import 'package:json_annotation/json_annotation.dart';

part 't_linear_attachment.g.dart';

/// Attachment on a Linear issue, such as a linked pull request.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearAttachmentDto {
  const TLinearAttachmentDto({
    required this.id,
    required this.title,
    required this.url,
    this.subtitle,
    this.sourceType,
    required this.metadata,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String url;
  final String? subtitle;
  final String? sourceType;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  factory TLinearAttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearAttachmentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearAttachmentDtoToJson(this);
}
