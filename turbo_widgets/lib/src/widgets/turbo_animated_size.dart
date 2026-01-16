import 'package:flutter/widgets.dart';
import '../constants/turbo_constants.dart';

class TurboAnimatedSize extends StatelessWidget {
  const TurboAnimatedSize({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
    this.curve = Curves.easeInOut,
    this.duration = turboDurationsAnimation,
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
