import 'package:flutter/widgets.dart';

/// Margin widget with convenient constructors for common margin values.
class TMargin extends StatelessWidget {
  const TMargin({
    super.key,
    required this.child,
    this.bottom = 16.0,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 16.0,
    this.multiplier = 1.0,
  });

  const TMargin.app({
    super.key,
    required this.child,
    this.bottom = 16.0,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 16.0,
    this.multiplier = 1.0,
  });

  const TMargin.button({
    super.key,
    required this.child,
    this.bottom = 0,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 0,
    this.multiplier = 1.0,
  });

  const TMargin.card({
    super.key,
    required this.child,
    this.bottom = 12.0,
    this.left = 12.0,
    this.right = 12.0,
    this.top = 12.0,
    this.multiplier = 1.0,
  });

  const TMargin.only({
    super.key,
    required this.child,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.multiplier = 1.0,
  });

  const TMargin.left({
    super.key,
    required this.child,
    this.left = 16.0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TMargin.right({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 16.0,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TMargin.top({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = 16.0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TMargin.bottom({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 16.0,
    this.multiplier = 1.0,
  });

  const TMargin.horizontal({
    super.key,
    required this.child,
    this.left = 16.0,
    this.right = 16.0,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  });

  const TMargin.vertical({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = 16.0,
    this.bottom = 16.0,
    this.multiplier = 1.0,
  });

  const TMargin.symmetric({
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
