import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_flex.dart';

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
