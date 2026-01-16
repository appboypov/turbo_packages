import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

/// A flexible layout widget that arranges children with spacing.
class TurboFlex extends StatelessWidget {
  const TurboFlex({
    super.key,
    required this.children,
    required this.direction,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 0,
  });

  static const crossAxisAlignmentDefault = CrossAxisAlignment.start;
  static const mainAxisAlignmentDefault = MainAxisAlignment.start;
  static const mainAxisSizeDefault = MainAxisSize.max;
  static const spacingDefault = 0.0;

  final List<Widget> children;
  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (spacing == 0) {
      return direction == Axis.horizontal
          ? Row(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              children: children,
            )
          : Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              children: children,
            );
    }

    final spacedChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        spacedChildren.add(Gap(spacing));
      }
      spacedChildren.add(children[i]);
    }

    return direction == Axis.horizontal
        ? Row(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: spacedChildren,
          )
        : Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: spacedChildren,
          );
  }
}
