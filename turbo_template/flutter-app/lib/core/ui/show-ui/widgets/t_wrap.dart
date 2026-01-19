import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TWrap<T> extends StatelessWidget {
  const TWrap({
    super.key,
    required this.children,
    required this.childBuilder,
    this.spacing = TSizes.appPadding,
    this.maxChildPerRow = 2,
    this.maxChildWidth = double.infinity,
    this.expandedWidth = TSizes.wrapMinChildWidth * 1.5,
    this.minChildWidth = TSizes.wrapMinChildWidth,
    this.emptyPlaceholderBuilder,
    this.leadingBuilder,
  });

  final List<T> children;
  final Widget Function(
    T child,
    BoxConstraints constraints,
    double spacing,
    double childWidth,
    BuildContext context,
  )
  childBuilder;

  final double maxChildPerRow;
  final double maxChildWidth;
  final double expandedWidth;
  final double minChildWidth;
  final double spacing;

  final WidgetBuilder? emptyPlaceholderBuilder;
  final Widget Function(
    BoxConstraints constraints,
    double spacing,
    double childWidth,
    BuildContext context,
  )?
  leadingBuilder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final rawMinChildWidth = minChildWidth + spacing;
      final biggestChildCount = ((constraints.maxWidth + spacing) / rawMinChildWidth).floor();
      final childCount = min(biggestChildCount, maxChildPerRow);
      final rawChildWidth = (constraints.maxWidth - (spacing * (childCount - 1))) / childCount;
      final childWidth = biggestChildCount > maxChildPerRow
          ? min(rawChildWidth, expandedWidth)
          : rawChildWidth;
      final wrapChildren = [
        if (leadingBuilder != null) leadingBuilder!(constraints, spacing, childWidth, context),
        for (final child in children)
          childBuilder(child, constraints, spacing, childWidth, context),
      ];
      if (wrapChildren.isEmpty && emptyPlaceholderBuilder != null) {
        return SizedBox(width: constraints.maxWidth, child: emptyPlaceholderBuilder!(context));
      }

      // Wrap the result in a SizedBox with explicit width to avoid intrinsic dimension issues
      return SizedBox(
        width: constraints.maxWidth,
        child: Wrap(runSpacing: spacing, spacing: spacing, children: wrapChildren),
      );
    },
  );
}
