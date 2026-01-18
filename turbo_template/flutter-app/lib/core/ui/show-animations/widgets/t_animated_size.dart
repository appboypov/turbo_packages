import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

class TAnimatedSize extends StatelessWidget {
  const TAnimatedSize({
    Key? key,
    required this.child,
    this.alignment = Alignment.topCenter,
    this.curve = Curves.easeInOut,
    this.duration = TDurations.animation,
  }) : super(key: key);

  final Duration duration;
  final Widget child;
  final Alignment alignment;
  final Curve curve;

  @override
  Widget build(BuildContext context) =>
      AnimatedSize(duration: duration, alignment: alignment, curve: curve, child: child);
}
