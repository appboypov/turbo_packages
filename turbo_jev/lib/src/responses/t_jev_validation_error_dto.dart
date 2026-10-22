import 'package:json_annotation/json_annotation.dart';

import '../constants/t_jev_http.dart';
import 't_jev_validation_error_detail_dto.dart';

part 't_jev_validation_error_dto.g.dart';

/// The wire form of the body of a 422 response.
@JsonSerializable(createToJson: false, checked: true)
final class TJevValidationErrorDto {
  const TJevValidationErrorDto({required this.detail});

  factory TJevValidationErrorDto.fromJson(Map<String, dynamic> json) =>
      _$TJevValidationErrorDtoFromJson(json);

  /// The validation errors, in the order TypeSafe sent them.
  @JsonKey(fromJson: _detailFromJson)
  final List<TJevValidationErrorDetailDto> detail;

  /// The entries of [json] that hold a message; the others are left out.
  static List<TJevValidationErrorDetailDto> _detailFromJson(
    List<Object?> json,
  ) => [
    for (final entry in json)
      if (entry
          case {
                TJevHttp.detailMessageKey: String(),
              } &&
              final Map<String, dynamic> fields)
        TJevValidationErrorDetailDto.fromJson(fields),
  ];
}
