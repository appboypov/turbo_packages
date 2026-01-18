import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/storage/converters/timestamp_converter.dart';

part 'current_week_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class CurrentWeekDto {
  const CurrentWeekDto({required this.year, required this.weekStart, required this.weekEnd});

  final int year;
  @TimestampConverter()
  final DateTime weekStart;
  @TimestampConverter()
  final DateTime weekEnd;

  static const fromJsonFactory = _$CurrentWeekDtoFromJson;
  factory CurrentWeekDto.fromJson(Map<String, dynamic> json) => _$CurrentWeekDtoFromJson(json);
  static const toJsonFactory = _$CurrentWeekDtoToJson;
  Map<String, dynamic> toJson() => _$CurrentWeekDtoToJson(this);

  @override
  String toString() => 'CurrentWeekDto(year: $year)';
}

extension CurrentWeekDtoExtension on CurrentWeekDto {
  DateTimeRange get weekRange => DateTimeRange(start: weekStart, end: weekEnd);

  String getFormattedWeekDescription({
    required CurrentWeekDto currentWeek,
    required BuildContext context,
  }) {
    final strings = context.strings;
    final weekDifference = weekStart.difference(currentWeek.weekStart).inDays ~/ 7;

    if (weekDifference == 0) return strings.thisWeek;
    if (weekDifference == -1) return strings.lastWeek;
    if (weekDifference == 1) return strings.nextWeek;

    if (weekDifference < 0) {
      return strings.weeksAgo(weekDifference.abs());
    }

    return strings.inWeeks(weekDifference);
  }
}
