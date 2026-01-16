import 'package:flutter/material.dart';

/// A divider widget with convenient styling.
class TurboDivider extends StatelessWidget {
  const TurboDivider({
    super.key,
    this.height,
    this.color,
    this.indent = 1,
    this.endIndent = 1,
    this.thickness = 1,
  });

  final double? height;
  final Color? color;
  final double indent;
  final double endIndent;
  final double thickness;

  @override
  Widget build(BuildContext context) => Divider(
    color: color ?? Theme.of(context).dividerColor.withValues(alpha: 0.7),
    indent: indent,
    endIndent: endIndent,
    height: height,
    thickness: thickness,
  );
}
