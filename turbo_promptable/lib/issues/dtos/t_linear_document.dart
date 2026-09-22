import 'package:json_annotation/json_annotation.dart';

part 't_linear_document.g.dart';

/// Document linked to a Linear issue.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearDocumentDto {
  const TLinearDocumentDto({
    required this.id,
    required this.title,
    required this.slugId,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String slugId;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory TLinearDocumentDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearDocumentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearDocumentDtoToJson(this);
}
