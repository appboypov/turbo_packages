import 'package:json_annotation/json_annotation.dart';

part 't_jev_validation_error_detail_dto.g.dart';

/// The wire form of one validation error in a 422 response.
@JsonSerializable(createToJson: false, checked: true)
final class TJevValidationErrorDetailDto {
  const TJevValidationErrorDetailDto({required this.loc, required this.msg});

  factory TJevValidationErrorDetailDto.fromJson(Map<String, dynamic> json) =>
      _$TJevValidationErrorDetailDtoFromJson(json);

  /// Where in the Request the problem is, empty when TypeSafe names no
  /// place.
  @JsonKey(defaultValue: [])
  final List<Object?> loc;

  /// What is wrong at [loc].
  final String msg;
}
