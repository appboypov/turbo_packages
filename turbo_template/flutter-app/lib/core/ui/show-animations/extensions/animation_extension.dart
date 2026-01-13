import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/animation_durations.dart';

extension AnimationExtension on Widget {
  Widget slideBottomUpWithFade({
    Duration duration = AnimationDurations.animation,
    Duration? delay,
    double begin = 0.2,
    double end = 0,
    Curve? curve,
    double? target,
    Key? key,
    AnimationController? animationController,
    bool shouldAnimate = true,
  }) {
    if (!shouldAnimate) {
      return this;
    }
    return RepaintBoundary(
      child: this,
    )
        .animate(
          target: target,
          key: key,
          controller: animationController,
        )
        .slideY(
          curve: curve,
          begin: begin,
          end: end,
          duration: duration,
          delay: delay,
        )
        .fadeIn();
  }

  Widget fade({
    Key? key,
    Duration duration = AnimationDurations.animationX0p5,
    Duration? delay,
    double? target,
    bool? autoPlay,
    Curve curve = Curves.linear,
  }) =>
      RepaintBoundary(
        child: this,
      )
          .animate(
            target: target,
            autoPlay: autoPlay,
            key: key,
          )
          .fade(
            duration: duration,
            delay: delay,
            curve: curve,
          );
}
