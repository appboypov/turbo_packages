import 'package:json_annotation/json_annotation.dart';

import 't_jev_image_part_dto.dart';

part 't_jev_system_one_assets_dto.g.dart';

/// The wire form of the Images a System One Request sends, merged into its
/// body.
@JsonSerializable(
  createFactory: false,
  includeIfNull: false,
  explicitToJson: true,
)
final class TJevSystemOneAssetsDto {
  const TJevSystemOneAssetsDto({required this.assets});

  /// The Images the Request sends, keyed by their Image References.
  final Map<String, TJevImagePartDto> assets;

  Map<String, dynamic> toJson() => _$TJevSystemOneAssetsDtoToJson(this);
}
