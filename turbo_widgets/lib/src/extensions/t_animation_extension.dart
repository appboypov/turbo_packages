import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/t_durations.dart';
import 't_duration_extension.dart';

extension TAnimationExtension on Widget {
  Widget slideBottomUp({
    Duration duration = tDurationsAnimation,
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

  Widget slideDownWithFade({
    Duration duration = tDurationsAnimation,
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

  Widget slideBottomUpWithFade({
    Duration duration = tDurationsAnimation,
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

  Widget fade({
    Key? key,
    Duration duration = tDurationsAnimationX0p5,
    Duration? delay,
    double? target,
    bool? autoPlay,
    Curve curve = Curves.linear,
  }) => RepaintBoundary(child: this)
      .animate(target: target, autoPlay: autoPlay, key: key)
      .fade(duration: duration, delay: delay, curve: curve);

  Widget fadeWithoutRepaint({
    Key? key,
    Duration duration = tDurationsAnimationX0p5,
    Duration? delay,
    double? target,
    bool? autoPlay,
    Curve curve = Curves.linear,
  }) => animate(
    target: target,
    autoPlay: autoPlay,
    key: key,
  ).fade(duration: duration, delay: delay, curve: curve);

  Widget slideBottomDownWithFade({
    Duration duration = tDurationsAnimation,
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

  Widget slideOutLeftWithFade({
    Duration duration = tDurationsAnimation,
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

  Widget slideInRightWithFade({
    Key? key,
    Duration duration = tDurationsAnimation,
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

  Widget slideInLeftWithFade({
    Key? key,
    Duration duration = tDurationsAnimation,
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

  Widget slideInRightOutLeftWithFade({
    Duration duration = tDurationsAnimation,
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
        duration: duration.add(slideInDelay),
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
