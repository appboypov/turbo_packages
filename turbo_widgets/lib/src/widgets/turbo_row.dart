import 'package:flutter/widgets.dart';
import 'turbo_flex.dart';

/// A row widget with convenient defaults and spacing support.
class TurboRow extends StatelessWidget {
  const TurboRow({
    super.key,
    required this.children,
    this.crossAxisAlignment = TurboFlex.crossAxisAlignmentDefault,
    this.mainAxisAlignment = TurboFlex.mainAxisAlignmentDefault,
    this.mainAxisSize = TurboFlex.mainAxisSizeDefault,
    this.spacing = TurboFlex.spacingDefault,
  });

  const TurboRow.centered({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = TurboFlex.mainAxisSizeDefault,
    this.spacing = TurboFlex.spacingDefault,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  @override
  Widget build(BuildContext context) => TurboFlex(
    direction: Axis.horizontal,
    spacing: spacing,
    crossAxisAlignment: crossAxisAlignment,
    mainAxisSize: mainAxisSize,
    mainAxisAlignment: mainAxisAlignment,
    children: children,
  );
}
