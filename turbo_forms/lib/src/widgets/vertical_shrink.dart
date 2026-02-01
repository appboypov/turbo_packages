import 'package:flutter/material.dart';
import 'package:turbo_forms/src/constants/turbo_forms_defaults.dart';

class VerticalShrink extends StatelessWidget {
  const VerticalShrink({
    required this.show,
    required this.child,
    super.key,
    this.fadeDuration = TurboFormsDefaults.animationDuration,
    this.sizeDuration = TurboFormsDefaults.animationDuration,
    this.fadeInCurve = TurboFormsDefaults.defaultFadeInCurve,
    this.fadeOutCurve = TurboFormsDefaults.defaultFadeOutCurve,
    this.sizeCurve = TurboFormsDefaults.defaultSizeCurve,
    this.alignment = TurboFormsDefaults.defaultAlignment,
    this.hideChild,
    this.clipBehavior = TurboFormsDefaults.defaultClipBehavior,
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
                      child: child),
                ),
                if (hideChild != null)
                  AnimatedOpacity(
                    opacity: show ? 0 : 1,
                    duration: fadeDuration,
                    curve: show ? fadeInCurve : fadeOutCurve,
                    child: Align(
                        alignment: alignment,
                        heightFactor: show ? 0 : null,
                        child: hideChild),
                  ),
              ],
            ),
          ),
        ),
      );
}
