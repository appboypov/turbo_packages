import 'package:flutter/material.dart';
import '../constants/turbo_constants.dart';
import '../extensions/turbo_animation_extension.dart';
import '../typedefs/turbo_lazy_locator_def.dart';
import 'turbo_animated_size.dart';

class TurboHorizontalFadeShrink extends StatelessWidget {
  const TurboHorizontalFadeShrink({
    super.key,
    required this.show,
    required this.child,
    this.fadeDuration = turboDurationsAnimation,
    this.sizeDuration = turboDurationsAnimation,
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.hideChild,
    this.height,
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
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSize(
        duration: sizeDuration,
        curve: sizeCurve,
        alignment: alignment,
        child: AnimatedSwitcher(
          duration: fadeDuration,
          switchInCurve: fadeInCurve,
          switchOutCurve: fadeOutCurve,
          child: show ? child : hideChild,
        ),
      ),
    );
  }
}

class TurboHorizontalSlideShrink extends StatelessWidget {
  const TurboHorizontalSlideShrink({
    super.key,
    required this.show,
    required this.child,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.centerRight,
    this.duration = turboDurationsAnimation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
  });

  final bool show;
  final Widget child;
  final Widget? hideChild;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, Widget child)? builder;
  final Widget Function(BuildContext context, Widget? hideChild)? hideBuilder;

  @override
  Widget build(BuildContext context) => TurboAnimatedSize(
    duration: duration,
    alignment: alignment,
    curve: curve,
    child: show
        ? builder?.call(context, child) ??
              child.turboSlideInRightWithFade(
                begin: 0.6,
                duration: duration,
                curve: curve,
              )
        : (hideBuilder?.call(context, hideChild) ??
              hideChild?.turboSlideInRightWithFade(
                duration: duration,
                curve: curve,
              ) ??
              turboWidgetsNothing),
  );
}

class TurboStatefulSlideShrink extends StatefulWidget {
  const TurboStatefulSlideShrink({
    super.key,
    required this.show,
    this.lazyChild,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.topCenter,
    this.duration = turboDurationsAnimation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
    this.child,
  });

  final bool show;
  final Widget? child;
  final TurboLazyLocatorDef<Widget>? lazyChild;
  final Widget? hideChild;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, Widget child)? builder;
  final Widget Function(BuildContext context, Widget? hideChild)? hideBuilder;

  @override
  State<TurboStatefulSlideShrink> createState() =>
      _TurboStatefulSlideShrinkState();
}

class _TurboStatefulSlideShrinkState extends State<TurboStatefulSlideShrink> {
  bool initialBuild = true;

  @override
  Widget build(BuildContext context) {
    if (initialBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initialBuild = false;
      });
    }
    return TurboAnimatedSize(
      duration: widget.duration,
      alignment: widget.alignment,
      curve: widget.curve,
      child: widget.show
          ? (widget.child ??
                    widget.builder?.call(context, widget.lazyChild!()) ??
                    widget.lazyChild!())
                .turboSlideBottomUpWithFade(
                  duration: widget.duration,
                  curve: widget.curve,
                  shouldAnimate: !initialBuild,
                )
          : (widget.hideBuilder?.call(context, widget.hideChild) ??
                widget.hideChild?.turboSlideBottomUpWithFade(
                  shouldAnimate: !initialBuild,
                  duration: widget.duration,
                  curve: widget.curve,
                ) ??
                turboWidgetsNothing),
    );
  }
}

class TurboSlideShrink extends StatelessWidget {
  const TurboSlideShrink({
    super.key,
    required this.show,
    this.lazyChild,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.topCenter,
    this.duration = turboDurationsAnimation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
    this.child,
  });

  final bool show;
  final Widget? child;
  final TurboLazyLocatorDef<Widget>? lazyChild;
  final Widget? hideChild;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, Widget child)? builder;
  final Widget Function(BuildContext context, Widget? hideChild)? hideBuilder;

  @override
  Widget build(BuildContext context) => TurboAnimatedSize(
    duration: duration,
    alignment: alignment,
    curve: curve,
    child: show
        ? (child ?? builder?.call(context, lazyChild!()) ?? lazyChild!())
              .turboSlideBottomUpWithFade(duration: duration, curve: curve)
        : (hideBuilder?.call(context, hideChild) ??
              hideChild?.turboSlideBottomUpWithFade(
                duration: duration,
                curve: curve,
              ) ??
              turboWidgetsNothing),
  );
}

class TurboHorizontalShrink extends StatelessWidget {
  const TurboHorizontalShrink({
    super.key,
    required this.show,
    required this.child,
    this.fadeDuration = turboDurationsAnimation,
    this.sizeDuration = turboDurationsAnimation,
    this.fadeInCurve = Curves.fastOutSlowIn,
    this.fadeOutCurve = Curves.fastOutSlowIn,
    this.sizeCurve = Curves.fastOutSlowIn,
    this.alignment = Alignment.center,
    this.hideChild,
    this.height,
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
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
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
                widthFactor: show ? null : 0,
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
                  widthFactor: show ? 0 : null,
                  child: hideChild,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TurboVerticalShrink extends StatelessWidget {
  const TurboVerticalShrink({
    super.key,
    required this.show,
    required this.child,
    this.fadeDuration = turboDurationsAnimation,
    this.sizeDuration = turboDurationsAnimation,
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
