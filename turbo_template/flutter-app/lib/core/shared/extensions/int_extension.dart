import 'dart:math';

import 'package:flutter/material.dart';

extension IntExtension on int {
  int get random {
    final random = Random();
    return random.nextInt(this);
  }

  Duration get asMinutesDuration => Duration(minutes: this);

  TimeOfDay get toTimeOfDayFromMinutes {
    final hours = (this / 60).floor();
    final minutes = (this % 60).floor();
    return TimeOfDay(hour: hours, minute: minutes);
  }

  String get timeBlockLabel {
    if (this < 60) {
      return '$this\m';
    } else {
      final hours = this ~/ 60;
      final minutes = this % 60;
      return '$hours\h${minutes > 0 ? ' $minutes\m' : ''}';
    }
  }

  String get timePadded => toString().padLeft(2, '0');

  int get roundedDownToEven => this % 2 == 0 ? this : this - 1;
  int get roundedUpToEven => this % 2 == 0 ? this : this + 1;

  int aboveOrElse({required int above, required int orElse}) {
    if (this > above) {
      return orElse;
    } else {
      return this;
    }
  }

  int belowOrElse({required int below, required int orElse}) {
    if (this < below) {
      return orElse;
    } else {
      return this;
    }
  }

  bool get isSuccessfulStatusCode {
    if (this >= 200 && this < 300) {
      return true;
    } else {
      return false;
    }
  }

  /// Converts 20240101 format
  DateTime get asDateTime => DateTime(this ~/ 10000, this ~/ 100 % 100, this % 100);

  bool get isNotFound => this == -1;

  Duration get asSecondsDuration => Duration(seconds: this);
  bool get isFirstIndex => this == 0;
  bool isLastIndexOf(Iterable iterable) => this == iterable.length - 1;
  bool isNotLastIndexOf(Iterable iterable) => this != iterable.length - 1;

  WeekDay get weekDayEnum {
    switch (this) {
      case DateTime.monday:
        return WeekDay.monday;
      case DateTime.tuesday:
        return WeekDay.tuesday;
      case DateTime.wednesday:
        return WeekDay.wednesday;
      case DateTime.thursday:
        return WeekDay.thursday;
      case DateTime.friday:
        return WeekDay.friday;
      case DateTime.saturday:
        return WeekDay.saturday;
      case DateTime.sunday:
        return WeekDay.sunday;
    }
    throw const UnexpectedStateException(
      reason: 'weekDay should never return anything below 1 or above 7',
    );
  }

  Month get monthEnum {
    switch (this) {
      case DateTime.january:
        return Month.january;
      case DateTime.february:
        return Month.february;
      case DateTime.march:
        return Month.march;
      case DateTime.april:
        return Month.april;
      case DateTime.may:
        return Month.may;
      case DateTime.june:
        return Month.june;
      case DateTime.july:
        return Month.july;
      case DateTime.august:
        return Month.august;
      case DateTime.september:
        return Month.september;
      case DateTime.october:
        return Month.october;
      case DateTime.november:
        return Month.november;
      case DateTime.december:
        return Month.december;
    }
    throw const UnexpectedStateException(
      reason: 'month should never return anything below 1 or above 12',
    );
  }

  int get nextFocusMaxFocusTaskCount {
    switch (this) {
      case 1:
        return 2;
      case 2:
        return 3;
      case 3:
        return 1;
      default:
        throw const UnexpectedStateException(
          reason: 'nextFocusMaxFocusTaskCount should never return anything below 1 or above 3',
        );
    }
  }

  double get x1p5 => this * 1.5;
  int get x2 => this * 2;
  int get x3 => this * 3;
  int get x4 => this * 4;
  int get x5 => this * 5;
}
