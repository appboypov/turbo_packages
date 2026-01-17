import 'package:flutter/widgets.dart';
import 't_flex.dart';

/// A column widget with convenient defaults and spacing support.
class TColumn extends StatelessWidget {
  const TColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = TFlex.crossAxisAlignmentDefault,
    this.mainAxisAlignment = TFlex.mainAxisAlignmentDefault,
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
    direction: Axis.vertical,
    spacing: spacing,
    crossAxisAlignment: crossAxisAlignment,
    mainAxisSize: mainAxisSize,
    mainAxisAlignment: mainAxisAlignment,
    children: children,
  );
}
