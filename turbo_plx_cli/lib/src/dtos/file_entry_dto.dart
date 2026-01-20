import 'package:json_annotation/json_annotation.dart';

part 'file_entry_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class FileEntryDto {
  final String path;
  final String content;
  final int lastModified;

  const FileEntryDto({
    required this.path,
    required this.content,
    required this.lastModified,
  });

  static const fromJsonFactory = _$FileEntryDtoFromJson;
  factory FileEntryDto.fromJson(Map<String, dynamic> json) =>
      _$FileEntryDtoFromJson(json);
  static const toJsonFactory = _$FileEntryDtoToJson;
  Map<String, dynamic> toJson() => _$FileEntryDtoToJson(this);
}
