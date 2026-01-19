import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/widgets/t_gap.dart';

class TPadding extends StatelessWidget {
  const TPadding({
    required this.child,
    super.key,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  const TPadding.all({
    required this.child,
    super.key,
    double padding = TSpacings.appPadding,
  })  : top = padding,
        bottom = padding,
        left = padding,
        right = padding;

  const TPadding.app({
    required this.child,
    super.key,
    double multiplier = 1,
  })  : top = TSpacings.appPadding * multiplier,
        bottom = TSpacings.appPadding * multiplier,
        left = TSpacings.appPadding * multiplier,
        right = TSpacings.appPadding * multiplier;

  const TPadding.horizontal({
    required this.child,
    super.key,
    double padding = TSpacings.appPadding,
  })  : top = 0,
        bottom = 0,
        left = padding,
        right = padding;

  const TPadding.vertical({
    required this.child,
    super.key,
    double padding = TSpacings.appPadding,
  })  : top = padding,
        bottom = padding,
        left = 0,
        right = 0;

  const TPadding.only({
    required this.child,
    super.key,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  const TPadding.card({
    required this.child,
    super.key,
    double multiplier = 1,
  })  : top = TSpacings.cardPadding * multiplier,
        bottom = TSpacings.cardPadding * multiplier,
        left = TSpacings.cardPadding * multiplier,
        right = TSpacings.cardPadding * multiplier;

  const TPadding.element({
    required this.child,
    super.key,
    double multiplier = 1,
  })  : top = TSpacings.elementGap * multiplier,
        bottom = TSpacings.elementGap * multiplier,
        left = TSpacings.elementGap * multiplier,
        right = TSpacings.elementGap * multiplier;

  final Widget child;
  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: child,
    );
  }
}
