import 'package:turbo_flutter_template/core/generated/l10n.dart';

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
  december
  ;

  String fullName(Strings strings) {
    switch (this) {
      case Month.january:
        return strings.january;
      case Month.february:
        return strings.february;
      case Month.march:
        return strings.march;
      case Month.april:
        return strings.april;
      case Month.may:
        return strings.may;
      case Month.june:
        return strings.june;
      case Month.july:
        return strings.july;
      case Month.august:
        return strings.august;
      case Month.september:
        return strings.september;
      case Month.october:
        return strings.october;
      case Month.november:
        return strings.november;
      case Month.december:
        return strings.december;
    }
  }

  String abbreviation(Strings strings) {
    switch (this) {
      case Month.january:
        return strings.jan;
      case Month.february:
        return strings.feb;
      case Month.march:
        return strings.mar;
      case Month.april:
        return strings.apr;
      case Month.may:
        return strings.may;
      case Month.june:
        return strings.jun;
      case Month.july:
        return strings.jul;
      case Month.august:
        return strings.aug;
      case Month.september:
        return strings.sep;
      case Month.october:
        return strings.oct;
      case Month.november:
        return strings.nov;
      case Month.december:
        return strings.dec;
    }
  }
}
