import 'package:flutter/material.dart';
import '../constants/t_durations.dart';
import '../constants/t_widgets.dart';
import '../extensions/t_animation_extension.dart';
import '../typedefs/t_lazy_locator_def.dart';
import 't_animated_size.dart';

class THorizontalFadeShrink extends StatelessWidget {
  const THorizontalFadeShrink({
    super.key,
    required this.show,
    required this.child,
    this.fadeDuration = TDurations.durationsAnimation,
    this.sizeDuration = TDurations.durationsAnimation,
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

class THorizontalSlideShrink extends StatelessWidget {
  const THorizontalSlideShrink({
    super.key,
    required this.show,
    required this.child,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.centerRight,
    this.duration = TDurations.durationsAnimation,
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
  Widget build(BuildContext context) => TAnimatedSize(
    duration: duration,
    alignment: alignment,
    curve: curve,
    child: show
        ? builder?.call(context, child) ??
              child.slideInRightWithFade(
                begin: 0.6,
                duration: duration,
                curve: curve,
              )
        : (hideBuilder?.call(context, hideChild) ??
              hideChild?.slideInRightWithFade(
                duration: duration,
                curve: curve,
              ) ??
              TWidgets.widgetsNothing),
  );
}

class TStatefulSlideShrink extends StatefulWidget {
  const TStatefulSlideShrink({
    super.key,
    required this.show,
    this.lazyChild,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.topCenter,
    this.duration = TDurations.durationsAnimation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
    this.child,
  });

  final bool show;
  final Widget? child;
  final TLazyLocatorDef<Widget>? lazyChild;
  final Widget? hideChild;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, Widget child)? builder;
  final Widget Function(BuildContext context, Widget? hideChild)? hideBuilder;

  @override
  State<TStatefulSlideShrink> createState() =>
      _TStatefulSlideShrinkState();
}

class _TStatefulSlideShrinkState extends State<TStatefulSlideShrink> {
  bool initialBuild = true;

  @override
  Widget build(BuildContext context) {
    if (initialBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initialBuild = false;
      });
    }
    return TAnimatedSize(
      duration: widget.duration,
      alignment: widget.alignment,
      curve: widget.curve,
      child: widget.show
          ? (widget.child ??
                    widget.builder?.call(context, widget.lazyChild!()) ??
                    widget.lazyChild!())
                .slideBottomUpWithFade(
                  duration: widget.duration,
                  curve: widget.curve,
                  shouldAnimate: !initialBuild,
                )
          : (widget.hideBuilder?.call(context, widget.hideChild) ??
                widget.hideChild?.slideBottomUpWithFade(
                  shouldAnimate: !initialBuild,
                  duration: widget.duration,
                  curve: widget.curve,
                ) ??
                TWidgets.widgetsNothing),
    );
  }
}

class TSlideShrink extends StatelessWidget {
  const TSlideShrink({
    super.key,
    required this.show,
    this.lazyChild,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.topCenter,
    this.duration = TDurations.durationsAnimation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
    this.child,
  });

  final bool show;
  final Widget? child;
  final TLazyLocatorDef<Widget>? lazyChild;
  final Widget? hideChild;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, Widget child)? builder;
  final Widget Function(BuildContext context, Widget? hideChild)? hideBuilder;

  @override
  Widget build(BuildContext context) => TAnimatedSize(
    duration: duration,
    alignment: alignment,
    curve: curve,
    child: show
        ? (child ?? builder?.call(context, lazyChild!()) ?? lazyChild!())
              .slideBottomUpWithFade(duration: duration, curve: curve)
        : (hideBuilder?.call(context, hideChild) ??
              hideChild?.slideBottomUpWithFade(
                duration: duration,
                curve: curve,
              ) ??
              TWidgets.widgetsNothing),
  );
}

class THorizontalShrink extends StatelessWidget {
  const THorizontalShrink({
    super.key,
    required this.show,
    required this.child,
    this.fadeDuration = TDurations.durationsAnimation,
    this.sizeDuration = TDurations.durationsAnimation,
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

class TVerticalShrink extends StatelessWidget {
  const TVerticalShrink({
    super.key,
    required this.show,
    required this.child,
    this.fadeDuration = TDurations.durationsAnimation,
    this.sizeDuration = TDurations.durationsAnimation,
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
