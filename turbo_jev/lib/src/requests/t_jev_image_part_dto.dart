import 'package:json_annotation/json_annotation.dart';

part 't_jev_image_part_dto.g.dart';

/// The wire form of an Image sent in a part of a multipart Request.
@JsonSerializable(createFactory: false)
final class TJevImagePartDto {
  const TJevImagePartDto({required this.part});

  @JsonKey(includeToJson: true)
  String get type => 'image';

  /// The name of the multipart part that holds the Image's file bytes.
  final String part;

  Map<String, dynamic> toJson() => _$TJevImagePartDtoToJson(this);
}
