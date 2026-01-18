import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_now.dart';
import 'package:turbo_flutter_template/core/shared/dtos/current_week_dto.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/date_format.dart';

abstract class DateTimeUtils {
  static DateTime latestOf(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
  static DateTime earliestOf(DateTime? a, DateTime b) => a == null || b.isBefore(a) ? b : a;
}

extension DateTimeExtension on DateTime {
  bool get isToday {
    return year == gNow.year && month == gNow.month && day == gNow.day;
  }

  String asMemberSinceString({
    required BuildContext context,
    DateFormat dateFormat = DateFormat.defaultValue,
  }) =>
      context.strings.memberSinceCreatedAtString(parseDateFormat(dateFormat: dateFormat));

  String asCreatedAtString({
    DateFormat dateFormat = DateFormat.defaultValue,
    required BuildContext context,
  }) =>
      context.strings.createdAtDateString(parseDateFormat(dateFormat: dateFormat));

  String asLastUpdatedString({
    DateFormat dateFormat = DateFormat.defaultValue,
    required BuildContext context,
  }) =>
      context.strings.lastUpdateAtString(parseDateFormat(dateFormat: dateFormat));

  DateTime get asUpcomingBirthday {
    final now = gNow;
    final birthday = DateTime(now.year, month, day);
    return birthday.isBefore(now) ? DateTime(now.year + 1, month, day) : birthday;
  }

  bool isMoreThanHoursAgo(int hours) {
    final now = gNow;
    return isBefore(now) && now.difference(this).inHours >= hours;
  }

  String get upToMinuteId => '$year$month$day$hour$minute';

  DateTime get asStartOfDay => DateTime(year, month, day, 0, 0, 0, 0, 0);
  DateTime get asStartOfWeek => subtract(Duration(days: weekday - 1)).asStartOfDay;
  DateTime get asEndOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);

  Timestamp get asTimeStamp => Timestamp.fromDate(this);

  DateTimeRange get weekRange {
    final monday = subtract(Duration(days: weekday - 1));
    final startOfMonday = DateTime(monday.year, monday.month, monday.day, 0, 0, 0, 0, 0);
    final endOfSunday = DateTime(monday.year, monday.month, monday.day + 6, 23, 59, 59, 999, 999);
    return DateTimeRange(start: startOfMonday, end: endOfSunday);
  }

  bool isBetween(DateTime start, DateTime end) => isAfter(start) && isBefore(end);

  bool isWithin(DateTimeRange range) => isBetween(range.start, range.end);

  CurrentWeekDto get currentWeekDto {
    final year = this.year;
    final pWeekRange = weekRange;
    return CurrentWeekDto(year: year, weekStart: pWeekRange.start, weekEnd: pWeekRange.end);
  }

  DateTime get nextDay => add(const Duration(days: 1));

  String asRelativeDeadlineString({
    required BuildContext context,
    DateFormat dateFormat = DateFormat.defaultValue,
  }) {
    final now = gNow.asStartOfDay;
    final targetDate = asStartOfDay;
    final difference = targetDate.difference(now).inDays;

    if (difference < 0) {
      final daysPast = difference.abs();
      if (daysPast == 1) {
        return context.strings.overdueOneDay;
      } else {
        return context.strings.overdueDays(daysPast);
      }
    }

    if (difference == 0) {
      return context.strings.today;
    }

    if (difference <= 14) {
      if (difference == 1) {
        return context.strings.inOneDay;
      } else {
        return context.strings.inDays(difference);
      }
    }

    if (difference <= 60) {
      final weeks = (difference / 7).floor();
      if (weeks == 1) {
        return context.strings.inOnePlusWeek;
      } else {
        return context.strings.inWeeksPlus(weeks);
      }
    }

    final months = (difference / 30).floor();
    if (months == 1) {
      return context.strings.inOneMonth;
    } else {
      return context.strings.inMonths(months);
    }
  }

  String asRelativeTimeAgo({required BuildContext context}) {
    final now = gNow;
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return context.strings.justNow;
    }

    if (difference.inMinutes < 60) {
      return context.strings.minutesAgo(difference.inMinutes);
    }

    if (difference.inHours < 24) {
      return context.strings.hoursAgo(difference.inHours);
    }

    final targetDate = asStartOfDay;
    final yesterday = now.subtract(const Duration(days: 1)).asStartOfDay;
    if (targetDate.isAtSameMomentAs(yesterday)) {
      return context.strings.yesterday;
    }

    if (difference.inDays < 7) {
      return context.strings.daysAgo(difference.inDays);
    }

    return parseDateFormat(dateFormat: DateFormat.defaultValue);
  }
}
