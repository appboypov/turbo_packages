import 'package:json_annotation/json_annotation.dart';

part 't_jev_usage_dto.g.dart';

/// The wire form of the tokens TypeSafe counted for one Request.
@JsonSerializable(
  createToJson: false,
  checked: true,
  fieldRename: FieldRename.snake,
)
final class TJevUsageDto {
  const TJevUsageDto({this.inputTokens, this.outputTokens});

  factory TJevUsageDto.fromJson(Map<String, dynamic> json) =>
      _$TJevUsageDtoFromJson(json);

  // 🎩 STATE

  final int? inputTokens;

  final int? outputTokens;
}
