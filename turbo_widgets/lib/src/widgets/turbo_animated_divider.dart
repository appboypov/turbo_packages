import 'package:flutter/material.dart';
import '../constants/turbo_constants.dart';

/// An animated divider that fades in/out based on visibility.
class TurboAnimatedDivider extends StatelessWidget {
  const TurboAnimatedDivider({
    super.key,
    required this.show,
    this.height = 0.5,
    this.thickness = 0.5,
    this.color,
    this.duration = turboDurationsAnimation,
  });

  final bool show;
  final double height;
  final double thickness;
  final Color? color;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedOpacity(
      duration: duration,
      opacity: show ? 1 : 0,
      child: Divider(
        height: height,
        thickness: thickness,
        color: color ?? theme.dividerColor,
      ),
    );
  }
}
