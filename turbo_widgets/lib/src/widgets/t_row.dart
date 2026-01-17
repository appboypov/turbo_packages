import 'package:flutter/widgets.dart';
import 't_flex.dart';

/// A row widget with convenient defaults and spacing support.
class TRow extends StatelessWidget {
  const TRow({
    super.key,
    required this.children,
    this.crossAxisAlignment = TFlex.crossAxisAlignmentDefault,
    this.mainAxisAlignment = TFlex.mainAxisAlignmentDefault,
    this.mainAxisSize = TFlex.mainAxisSizeDefault,
    this.spacing = TFlex.spacingDefault,
  });

  const TRow.centered({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = TFlex.mainAxisSizeDefault,
    this.spacing = TFlex.spacingDefault,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  @override
  Widget build(BuildContext context) => TFlex(
    direction: Axis.horizontal,
    spacing: spacing,
    crossAxisAlignment: crossAxisAlignment,
    mainAxisSize: mainAxisSize,
    mainAxisAlignment: mainAxisAlignment,
    children: children,
  );
}
