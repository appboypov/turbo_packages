import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';

class TAnimatedEnabled extends StatelessWidget {
  const TAnimatedEnabled({
    required this.isEnabled,
    required this.child,
    this.animationDuration = TDurations.animation,
    this.disabledOpacity = TSizes.opacityDisabled,
    this.disabledBuilder,
    Key? key,
  }) : super(key: key);

  final bool isEnabled;
  final Widget child;
  final Duration animationDuration;
  final double disabledOpacity;
  final Widget Function(BuildContext context, Widget child)? disabledBuilder;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: isEnabled ? 1 : disabledOpacity,
    duration: animationDuration,
    curve: Curves.easeInOut,
    child: IgnorePointer(
      ignoring: !isEnabled,
      child: isEnabled ? child : disabledBuilder?.call(context, child) ?? child,
    ),
  );
}
