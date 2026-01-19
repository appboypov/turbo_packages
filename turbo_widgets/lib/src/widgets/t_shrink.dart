import 'package:flutter/material.dart';

class TVerticalShrink extends StatelessWidget {
  const TVerticalShrink({
    required this.show,
    required this.child,
    super.key,
    this.fadeDuration = const Duration(milliseconds: 225),
    this.sizeDuration = const Duration(milliseconds: 225),
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.topCenter,
    this.hideChild,
    this.width,
  });

  final bool show;
  final Widget child;
  final Duration fadeDuration;
  final Duration sizeDuration;
  final Curve fadeInCurve;
  final Curve fadeOutCurve;
  final Curve sizeCurve;
  final AlignmentGeometry alignment;
  final Widget? hideChild;
  final double? width;

  static final _key = UniqueKey();

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
          transitionBuilder: hideChild != null
              ? (child, animation) => FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.15, 1.0, curve: Curves.easeInOut),
                      ),
                    ),
                    child: child,
                  )
              : AnimatedSwitcher.defaultTransitionBuilder,
          layoutBuilder: (currentChild, previousChildren) {
            List<Widget> children = previousChildren;
            if (currentChild != null) {
              if (previousChildren.isEmpty) {
                children = [currentChild];
              } else {
                children = [
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    child: previousChildren[0],
                  ),
                  currentChild,
                ];
              }
            }
            return Stack(
              clipBehavior: Clip.none,
              alignment: alignment,
              children: children,
            );
          },
          child: show
              ? child
              : (hideChild ??
                  SizedBox(
                    key: _key,
                    width: width ?? double.infinity,
                    height: 0,
                  )),
        ),
      ),
    );
  }
}

class THorizontalShrink extends StatelessWidget {
  const THorizontalShrink({
    required this.show,
    required this.child,
    super.key,
    this.fadeDuration = const Duration(milliseconds: 225),
    this.sizeDuration = const Duration(milliseconds: 225),
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.centerLeft,
    this.hideChild,
    this.height,
  });

  final bool show;
  final Widget child;
  final Duration fadeDuration;
  final Duration sizeDuration;
  final Curve fadeInCurve;
  final Curve fadeOutCurve;
  final Curve sizeCurve;
  final Alignment alignment;
  final Widget? hideChild;
  final double? height;

  static final _key = UniqueKey();

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
          layoutBuilder: (currentChild, previousChildren) {
            List<Widget> children = previousChildren;
            if (currentChild != null) {
              if (previousChildren.isEmpty) {
                children = [currentChild];
              } else {
                children = [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: previousChildren[0],
                  ),
                  currentChild,
                ];
              }
            }
            return Stack(
              clipBehavior: Clip.none,
              alignment: alignment,
              children: children,
            );
          },
          child: show
              ? child
              : (hideChild ??
                  SizedBox(
                    key: _key,
                    width: 0,
                    height: height ?? double.infinity,
                  )),
        ),
      ),
    );
  }
}
