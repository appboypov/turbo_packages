import 'package:flutter/widgets.dart';

/// Margin widget with convenient constructors for common margin values.
class TurboMargin extends StatelessWidget {
  const TurboMargin({
    super.key,
    required this.child,
    this.bottom = 16.0,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 16.0,
    this.multiplier = 1.0,
  });

  const TurboMargin.app({
    super.key,
    required this.child,
    this.bottom = 16.0,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 16.0,
    this.multiplier = 1.0,
  });

  const TurboMargin.button({
    super.key,
    required this.child,
    this.bottom = 0,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 0,
    this.multiplier = 1.0,
  });

  const TurboMargin.card({
    super.key,
    required this.child,
    this.bottom = 12.0,
    this.left = 12.0,
    this.right = 12.0,
    this.top = 12.0,
    this.multiplier = 1.0,
  });

  const TurboMargin.only({
    super.key,
    required this.child,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.multiplier = 1.0,
  });

  const TurboMargin.left({
    super.key,
    required this.child,
    this.left = 16.0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TurboMargin.right({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 16.0,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TurboMargin.top({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = 16.0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TurboMargin.bottom({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 16.0,
    this.multiplier = 1.0,
  });

  const TurboMargin.horizontal({
    super.key,
    required this.child,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TurboMargin.vertical({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = 16.0,
    this.bottom = 16.0,
    this.multiplier = 1.0,
  });

  const TurboMargin.symmetric({
    super.key,
    required this.child,
    double vertical = 16.0,
    double horizontal = 16.0,
    this.multiplier = 1.0,
  }) : bottom = vertical,
       left = horizontal,
       right = horizontal,
       top = vertical;

  final Widget child;
  final double bottom;
  final double left;
  final double right;
  final double top;
  final double multiplier;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      bottom: bottom * multiplier,
      left: left * multiplier,
      right: right * multiplier,
      top: top * multiplier,
    ),
    child: child,
  );
}
