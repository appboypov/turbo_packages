import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TPadding extends EdgeInsets {
  const TPadding.all(super.value) : super.all();

  const TPadding.only({super.left = 0, super.right = 0, super.top = 0, super.bottom = 0})
    : super.only();

  const TPadding.symmetric({super.vertical = 0, super.horizontal = 0}) : super.symmetric();

  const TPadding.app({double value = TSizes.appPadding}) : super.all(value);

  const TPadding.button({double horizontal = TSizes.appPadding, double vertical = 0})
    : super.symmetric(horizontal: horizontal, vertical: vertical);

  const TPadding.card({double value = TSizes.cardPadding}) : super.all(value);

  const TPadding.left({double value = TSizes.appPadding}) : super.only(left: value);

  const TPadding.right({double value = TSizes.appPadding}) : super.only(right: value);

  const TPadding.top({double value = TSizes.appPadding}) : super.only(top: value);

  const TPadding.bottom([double value = TSizes.appPadding]) : super.only(bottom: value);

  const TPadding.horizontal([double value = TSizes.appPadding])
    : super.symmetric(horizontal: value);

  const TPadding.vertical({double value = TSizes.appPadding}) : super.symmetric(vertical: value);
}
