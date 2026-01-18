import 'package:flutter/material.dart';
import 'package:roomy_mobile/l10n/globals/g_strings.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/generated/l10n.dart';

enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december;

  String fullName(BuildContext context) {
    switch (this) {
      case Month.january:
        return context.strings.january;
      case Month.february:
        return context.strings.february;
      case Month.march:
        return context.strings.march;
      case Month.april:
        return context.strings.april;
      case Month.may:
        return context.strings.may;
      case Month.june:
        return context.strings.june;
      case Month.july:
        return context.strings.july;
      case Month.august:
        return context.strings.august;
      case Month.september:
        return context.strings.september;
      case Month.october:
        return context.strings.october;
      case Month.november:
        return context.strings.november;
      case Month.december:
        return context.strings.december;
    }
  }

  String abbreviation(S strings) {
    switch (this) {
      case Month.january:
        return gStrings.jan;
      case Month.february:
        return gStrings.feb;
      case Month.march:
        return gStrings.mar;
      case Month.april:
        return gStrings.apr;
      case Month.may:
        return gStrings.may;
      case Month.june:
        return gStrings.jun;
      case Month.july:
        return gStrings.jul;
      case Month.august:
        return gStrings.aug;
      case Month.september:
        return gStrings.sep;
      case Month.october:
        return gStrings.oct;
      case Month.november:
        return gStrings.nov;
      case Month.december:
        return gStrings.dec;
    }
  }
}
