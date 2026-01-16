import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/turbo_constants.dart';
import 'turbo_duration_extension.dart';

extension TurboAnimationExtension on Widget {
  Widget turboSlideBottomUp({
    Duration duration = turboDurationsAnimation,
    Duration? delay,
    double size = 1,
    double begin = 1,
    Curve? curve,
    double? target,
  }) => RepaintBoundary(child: this)
      .animate(target: target)
      .slideY(
        curve: curve,
        begin: begin,
        end: 0,
        duration: duration,
        delay: delay,
      );

  Widget turboSlideDownWithFade({
    Duration duration = turboDurationsAnimation,
    Duration? delay,
    double begin = -0.2,
    double end = 0,
    Curve? curve,
    double? target,
    Key? key,
    AnimationController? animationController,
  }) => RepaintBoundary(child: this)
      .animate(target: target, key: key, controller: animationController)
      .slideY(
        curve: curve,
        begin: begin,
        end: end,
        duration: duration,
        delay: delay,
      )
      .fadeIn();

  Widget turboSlideBottomUpWithFade({
    Duration duration = turboDurationsAnimation,
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
    return RepaintBoundary(child: this)
        .animate(target: target, key: key, controller: animationController)
        .slideY(
          curve: curve,
          begin: begin,
          end: end,
          duration: duration,
          delay: delay,
        )
        .fadeIn();
  }

  Widget turboFade({
    Key? key,
    Duration duration = turboDurationsAnimationX0p5,
    Duration? delay,
    double? target,
    bool? autoPlay,
    Curve curve = Curves.linear,
  }) => RepaintBoundary(child: this)
      .animate(target: target, autoPlay: autoPlay, key: key)
      .fade(duration: duration, delay: delay, curve: curve);

  Widget turboFadeWithoutRepaint({
    Key? key,
    Duration duration = turboDurationsAnimationX0p5,
    Duration? delay,
    double? target,
    bool? autoPlay,
    Curve curve = Curves.linear,
  }) => animate(
    target: target,
    autoPlay: autoPlay,
    key: key,
  ).fade(duration: duration, delay: delay, curve: curve);

  Widget turboSlideBottomDownWithFade({
    Duration duration = turboDurationsAnimation,
    Duration? delay,
    double begin = 0,
    double end = 1,
    Curve? curve,
    double? target,
  }) => RepaintBoundary(child: this)
      .animate(target: target)
      .slideY(
        curve: curve,
        begin: begin,
        end: end,
        duration: duration,
        delay: delay,
      )
      .fadeOut();

  Widget turboSlideOutLeftWithFade({
    Duration duration = turboDurationsAnimation,
    Duration? delay,
    double size = 1,
    double begin = 0,
    double end = -1,
    Curve? curve,
    double? target,
  }) => RepaintBoundary(child: this)
      .animate(target: target)
      .slideX(
        curve: curve,
        begin: begin,
        end: end,
        duration: duration,
        delay: delay,
      )
      .fadeOut();

  Widget turboSlideInRightWithFade({
    Key? key,
    Duration duration = turboDurationsAnimation,
    Duration? delay,
    double size = 1,
    double begin = 1,
    Curve? curve,
    double? target,
  }) => RepaintBoundary(child: this)
      .animate(target: target, key: key)
      .slideX(
        curve: curve,
        begin: begin,
        end: 0,
        duration: duration,
        delay: delay,
      )
      .fadeIn();

  Widget turboSlideInLeftWithFade({
    Key? key,
    Duration duration = turboDurationsAnimation,
    Duration? delay,
    double size = 1,
    double begin = -1,
    Curve? curve,
    double? target,
  }) => RepaintBoundary(child: this)
      .animate(target: target, key: key)
      .slideX(
        curve: curve,
        begin: begin,
        end: 0,
        duration: duration,
        delay: delay,
      )
      .fadeIn();

  Widget turboSlideInRightOutLeftWithFade({
    Duration duration = turboDurationsAnimation,
    Duration? slideInDelay,
    double size = 1,
    double slideInBegin = 1,
    double slideInEnd = 0,
    double slideOutBegin = 0,
    double slideOutEnd = -1,
    Curve? curve,
    double? target,
  }) => RepaintBoundary(child: this)
      .animate(target: target)
      .slideX(
        curve: curve,
        begin: slideInBegin,
        end: slideInEnd,
        duration: duration.turboAdd(slideInDelay),
      )
      .fadeIn()
      .then()
      .slideX(
        curve: curve,
        begin: slideOutBegin,
        end: slideOutEnd,
        duration: duration,
      )
      .fadeOut();
}
