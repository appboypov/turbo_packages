import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TFlex extends StatelessWidget {
  static const mainAxisAlignmentDefault = MainAxisAlignment.start;
  static const mainAxisSizeDefault = MainAxisSize.min;
  static const crossAxisAlignmentDefault = CrossAxisAlignment.start;
  static const spacingDefault = TSizes.elementGap;

  const TFlex({
    super.key,
    required this.children,
    required this.direction,
    this.mainAxisAlignment = TFlex.mainAxisAlignmentDefault,
    this.mainAxisSize = TFlex.mainAxisSizeDefault,
    this.crossAxisAlignment = TFlex.crossAxisAlignmentDefault,
    this.spacing = TFlex.spacingDefault,
  });

  const TFlex.horizontal({
    super.key,
    required this.children,
    this.mainAxisAlignment = TFlex.mainAxisAlignmentDefault,
    this.mainAxisSize = TFlex.mainAxisSizeDefault,
    this.crossAxisAlignment = TFlex.crossAxisAlignmentDefault,
    this.spacing = TFlex.spacingDefault,
  }) : direction = Axis.horizontal;

  const TFlex.vertical({
    super.key,
    required this.children,
    this.mainAxisAlignment = TFlex.mainAxisAlignmentDefault,
    this.mainAxisSize = TFlex.mainAxisSizeDefault,
    this.crossAxisAlignment = TFlex.crossAxisAlignmentDefault,
    this.spacing = TFlex.spacingDefault,
  }) : direction = Axis.vertical;

  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) => Flex(
    crossAxisAlignment: crossAxisAlignment,
    direction: direction,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    spacing: spacing,
    children: children,
  );
}
