// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_box_coordinates_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevBoxCoordinatesDto _$TJevBoxCoordinatesDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TJevBoxCoordinatesDto', json, ($checkedConvert) {
  final val = TJevBoxCoordinatesDto(
    top: $checkedConvert('top', (v) => (v as num).toDouble()),
    bottom: $checkedConvert('bottom', (v) => (v as num).toDouble()),
    left: $checkedConvert('left', (v) => (v as num).toDouble()),
    right: $checkedConvert('right', (v) => (v as num).toDouble()),
  );
  return val;
});
