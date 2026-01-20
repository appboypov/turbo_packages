import 'package:json_annotation/json_annotation.dart';

part 'file_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class FileDto {
  final String path;
  final String? content;
  final int? lastModified;

  const FileDto({
    required this.path,
    this.content,
    this.lastModified,
  });

  String get id => path;

  static const fromJsonFactory = _$FileDtoFromJson;
  factory FileDto.fromJson(Map<String, dynamic> json) => _$FileDtoFromJson(json);
  static const toJsonFactory = _$FileDtoToJson;
  Map<String, dynamic> toJson() => _$FileDtoToJson(this);

  FileDto copyWith({
    String? path,
    String? content,
    int? lastModified,
  }) {
    return FileDto(
      path: path ?? this.path,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}
