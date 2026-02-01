import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/widgets/animation_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_animated_size.dart';

class HorizontalFadeShrink extends StatelessWidget {
  const HorizontalFadeShrink({
    required this.show,
    required this.child,
    Key? key,
    this.fadeDuration = TDurations.animation,
    this.sizeDuration = TDurations.animation,
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.hideChild,
    this.height,
  }) : super(key: key);

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

class HorizontalSlideShrink extends StatelessWidget {
  const HorizontalSlideShrink({
    Key? key,
    required this.show,
    required this.child,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.centerRight,
    this.duration = TDurations.animation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
  }) : super(key: key);

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
              TWidgets.nothing),
  );
}

class StatefulSlideShrink extends StatefulWidget {
  const StatefulSlideShrink({
    Key? key,
    required this.show,
    this.lazyChild,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.topCenter,
    this.duration = TDurations.animation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
    this.child,
  }) : super(key: key);

  final bool show;
  final Widget? child;
  final LazyLocatorDef<Widget>? lazyChild;
  final Widget? hideChild;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, Widget child)? builder;
  final Widget Function(BuildContext context, Widget? hideChild)? hideBuilder;

  @override
  State<StatefulSlideShrink> createState() => _StatefulSlideShrinkState();
}

class _StatefulSlideShrinkState extends State<StatefulSlideShrink> {
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
                TWidgets.nothing),
    );
  }
}

class SlideShrink extends StatelessWidget {
  const SlideShrink({
    Key? key,
    required this.show,
    this.lazyChild,
    this.hideChild,
    this.builder,
    this.alignment = Alignment.topCenter,
    this.duration = TDurations.animation,
    this.curve = Curves.decelerate,
    this.hideBuilder,
    this.child,
  }) : super(key: key);

  final bool show;
  final Widget? child;
  final LazyLocatorDef<Widget>? lazyChild;
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
              .slideBottomUpWithFade(
                duration: duration,
                curve: curve,
              )
        : (hideBuilder?.call(context, hideChild) ??
              hideChild?.slideBottomUpWithFade(
                duration: duration,
                curve: curve,
              ) ??
              TWidgets.nothing),
  );
}

class HorizontalShrink extends StatelessWidget {
  const HorizontalShrink({
    required this.show,
    required this.child,
    Key? key,
    this.fadeDuration = TDurations.animation,
    this.sizeDuration = TDurations.animation,
    this.fadeInCurve = Curves.fastOutSlowIn,
    this.fadeOutCurve = Curves.fastOutSlowIn,
    this.sizeCurve = Curves.fastOutSlowIn,
    this.alignment = Alignment.center,
    this.hideChild,
    this.height,
  }) : super(key: key);

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

class VerticalShrink extends StatelessWidget {
  const VerticalShrink({
    required this.show,
    required this.child,
    Key? key,
    this.fadeDuration = TDurations.animation,
    this.sizeDuration = TDurations.animation,
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.topCenter,
    this.hideChild,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

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
