import 'package:flutter/widgets.dart';

/// A wrap widget with convenient defaults and responsive child sizing.
class TurboWrap extends StatelessWidget {
  const TurboWrap({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.clipBehavior = Clip.none,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;
  final Axis direction;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: spacing,
    runSpacing: runSpacing,
    alignment: alignment,
    runAlignment: runAlignment,
    crossAxisAlignment: crossAxisAlignment,
    direction: direction,
    verticalDirection: verticalDirection,
    textDirection: textDirection,
    clipBehavior: clipBehavior,
    children: children,
  );
}
