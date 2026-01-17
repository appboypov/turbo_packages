import 'package:flutter/widgets.dart';

/// Padding widget with convenient constructors for common padding values.
class TPadding extends EdgeInsets {
  const TPadding.all(super.value) : super.all();

  const TPadding.only({
    super.left = 0,
    super.right = 0,
    super.top = 0,
    super.bottom = 0,
  }) : super.only();

  const TPadding.symmetric({super.vertical = 0, super.horizontal = 0})
    : super.symmetric();

  /// Standard app padding (16.0)
  const TPadding.app({double value = 16.0}) : super.all(value);

  /// Button padding (16.0 horizontal, 0 vertical)
  const TPadding.button({super.horizontal = 16.0, super.vertical = 0})
    : super.symmetric();

  /// Card padding (12.0)
  const TPadding.card({double value = 12.0}) : super.all(value);

  const TPadding.left({double value = 16.0}) : super.only(left: value);

  const TPadding.right({double value = 16.0}) : super.only(right: value);

  const TPadding.top({double value = 16.0}) : super.only(top: value);

  const TPadding.bottom([double value = 16.0]) : super.only(bottom: value);

  const TPadding.horizontal([double value = 16.0])
    : super.symmetric(horizontal: value);

  const TPadding.vertical({double value = 16.0})
    : super.symmetric(vertical: value);
}
