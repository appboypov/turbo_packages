import 'package:flutter/widgets.dart';
import '../constants/t_durations.dart';

class TAnimatedSize extends StatelessWidget {
  const TAnimatedSize({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
    this.curve = Curves.easeInOut,
    this.duration = TDurations.animation,
  });

  final Duration duration;
  final Widget child;
  final Alignment alignment;
  final Curve curve;

  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: duration,
    alignment: alignment,
    curve: curve,
    child: child,
  );
}
