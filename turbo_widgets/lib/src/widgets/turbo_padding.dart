import 'package:flutter/widgets.dart';

/// Padding widget with convenient constructors for common padding values.
class TurboPadding extends EdgeInsets {
  const TurboPadding.all(super.value) : super.all();

  const TurboPadding.only({
    super.left = 0,
    super.right = 0,
    super.top = 0,
    super.bottom = 0,
  }) : super.only();

  const TurboPadding.symmetric({super.vertical = 0, super.horizontal = 0})
    : super.symmetric();

  /// Standard app padding (16.0)
  const TurboPadding.app({double value = 16.0}) : super.all(value);

  /// Button padding (16.0 horizontal, 0 vertical)
  const TurboPadding.button({super.horizontal = 16.0, super.vertical = 0})
    : super.symmetric();

  /// Card padding (12.0)
  const TurboPadding.card({double value = 12.0}) : super.all(value);

  const TurboPadding.left({double value = 16.0}) : super.only(left: value);

  const TurboPadding.right({double value = 16.0}) : super.only(right: value);

  const TurboPadding.top({double value = 16.0}) : super.only(top: value);

  const TurboPadding.bottom([double value = 16.0]) : super.only(bottom: value);

  const TurboPadding.horizontal([double value = 16.0])
    : super.symmetric(horizontal: value);

  const TurboPadding.vertical({double value = 16.0})
    : super.symmetric(vertical: value);
}
