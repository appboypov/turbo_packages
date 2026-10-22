import 'package:json_annotation/json_annotation.dart';

part 't_jev_box_coordinates_dto.g.dart';

/// The wire form of the edges of a Box Answer.
@JsonSerializable(createToJson: false, checked: true)
final class TJevBoxCoordinatesDto {
  const TJevBoxCoordinatesDto({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  factory TJevBoxCoordinatesDto.fromJson(Map<String, dynamic> json) =>
      _$TJevBoxCoordinatesDtoFromJson(json);

  final double top;

  final double bottom;

  final double left;

  final double right;
}
