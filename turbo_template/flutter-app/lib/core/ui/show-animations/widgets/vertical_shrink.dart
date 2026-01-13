import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/animation_durations.dart';

class VerticalShrink extends StatelessWidget {
  const VerticalShrink({
    required this.show,
    required this.child,
    super.key,
    this.fadeDuration = AnimationDurations.animation,
    this.sizeDuration = AnimationDurations.animation,
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.topCenter,
    this.hideChild,
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final Duration fadeDuration;
  final Duration sizeDuration;
  final Curve fadeInCurve;
  final Curve fadeOutCurve;
  final Curve sizeCurve;
  final Alignment alignment;
  final bool show;
  final Widget? hideChild;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => ClipRect(
        clipBehavior: clipBehavior,
        child: RepaintBoundary(
          child: AnimatedSize(
            duration: sizeDuration,
            curve: sizeCurve,
            alignment: alignment,
            child: Stack(
              alignment: alignment,
              children: [
                AnimatedOpacity(
                  opacity: show ? 1 : 0,
                  duration: fadeDuration,
                  curve: show ? fadeInCurve : fadeOutCurve,
                  child: Align(
                    alignment: alignment,
                    heightFactor: show ? null : 0,
                    child: child,
                  ),
                ),
                if (hideChild != null)
                  AnimatedOpacity(
                    opacity: show ? 0 : 1,
                    duration: fadeDuration,
                    curve: show ? fadeInCurve : fadeOutCurve,
                    child: Align(
                      alignment: alignment,
                      heightFactor: show ? 0 : null,
                      child: hideChild,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
