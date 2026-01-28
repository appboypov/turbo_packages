import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/generated/l10n.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String fullName(Strings strings) {
    switch (this) {
      case WeekDay.monday:
        return strings.monday;
      case WeekDay.tuesday:
        return strings.tuesday;
      case WeekDay.wednesday:
        return strings.wednesday;
      case WeekDay.thursday:
        return strings.thursday;
      case WeekDay.friday:
        return strings.friday;
      case WeekDay.saturday:
        return strings.saturday;
      case WeekDay.sunday:
        return strings.sunday;
    }
  }

  String abbreviation(BuildContext context) {
    final strings = context.strings;
    switch (this) {
      case WeekDay.monday:
        return strings.mon;
      case WeekDay.tuesday:
        return strings.tue;
      case WeekDay.wednesday:
        return strings.wed;
      case WeekDay.thursday:
        return strings.thu;
      case WeekDay.friday:
        return strings.fri;
      case WeekDay.saturday:
        return strings.sat;
      case WeekDay.sunday:
        return strings.sun;
    }
  }
}
