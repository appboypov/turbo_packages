import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

class FadeIn extends StatelessWidget {
  const FadeIn({
    required this.fadeIn,
    required this.fadeInChild,
    this.fadeOutChild,
    this.duration = TDurations.animation,
    super.key,
  });

  final bool fadeIn;
  final Widget fadeInChild;
  final Widget? fadeOutChild;
  final Duration duration;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: duration,
    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
    child: fadeIn ? fadeInChild : fadeOutChild ?? const SizedBox.shrink(),
  );
}
