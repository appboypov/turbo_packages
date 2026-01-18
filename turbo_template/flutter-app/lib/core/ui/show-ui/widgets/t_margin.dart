import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TMargin extends StatelessWidget {
  const TMargin({
    Key? key,
    required this.child,
    this.bottom = TSizes.appPadding,
    this.left = TSizes.appPadding,
    this.right = TSizes.appPadding,
    this.top = TSizes.appPadding,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.app({
    Key? key,
    required this.child,
    this.bottom = TSizes.appPadding,
    this.left = TSizes.appPadding,
    this.right = TSizes.appPadding,
    this.top = TSizes.appPadding,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.button({
    Key? key,
    required this.child,
    this.bottom = 0,
    this.left = TSizes.appPadding,
    this.right = TSizes.appPadding,
    this.top = 0,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.card({
    Key? key,
    required this.child,
    this.bottom = TSizes.cardPadding,
    this.left = TSizes.cardPadding,
    this.right = TSizes.cardPadding,
    this.top = TSizes.cardPadding,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.only({
    Key? key,
    required this.child,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.left({
    Key? key,
    required this.child,
    this.left = TSizes.appPadding,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.right({
    Key? key,
    required this.child,
    this.left = 0,
    this.right = TSizes.appPadding,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.top({
    Key? key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = TSizes.appPadding,
    this.bottom = 0,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.bottom({
    Key? key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = TSizes.appPadding,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.horizontalScrollBody({
    Key? key,
    required this.child,
    this.left = TSizes.appPadding * 1.5,
    this.right = TSizes.appPadding * 1.5,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.horizontal({
    Key? key,
    required this.child,
    double? horizontal,
    double left = TSizes.appPadding,
    double right = TSizes.appPadding,
    this.top = 0,
    this.bottom = 0,
    this.multiplier = 1.0,
  }) : left = horizontal ?? left,
        right = horizontal ?? right,
        super(key: key);

  const TMargin.vertical({
    Key? key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top = TSizes.appPadding,
    this.bottom = TSizes.appPadding,
    this.multiplier = 1.0,
  }) : super(key: key);

  const TMargin.symmetric({
    Key? key,
    required this.child,
    double vertical = TSizes.appPadding,
    double horizontal = TSizes.appPadding,
    this.multiplier = 1.0,
  }) : bottom = vertical,
        left = horizontal,
        right = horizontal,
        top = vertical,
        super(key: key);

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
