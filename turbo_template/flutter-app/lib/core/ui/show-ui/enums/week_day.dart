import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String fullName(BuildContext context) {
    final s = S.of(context);
    switch (this) {
      case WeekDay.monday:
        return s.monday;
      case WeekDay.tuesday:
        return s.tuesday;
      case WeekDay.wednesday:
        return s.wednesday;
      case WeekDay.thursday:
        return s.thursday;
      case WeekDay.friday:
        return s.friday;
      case WeekDay.saturday:
        return s.saturday;
      case WeekDay.sunday:
        return s.sunday;
    }
  }

  String abbreviation(BuildContext context) {
    final s = S.of(context);
    switch (this) {
      case WeekDay.monday:
        return s.mon;
      case WeekDay.tuesday:
        return s.tue;
      case WeekDay.wednesday:
        return s.wed;
      case WeekDay.thursday:
        return s.thu;
      case WeekDay.friday:
        return s.fri;
      case WeekDay.saturday:
        return s.sat;
      case WeekDay.sunday:
        return s.sun;
    }
  }
}
