import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/widgets/hover_builder.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_button_raw.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/t_hoverable.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_vibrate_moment.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_constraints.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ux/globals/g_vibrate.dart';

class TButton extends StatefulWidget {
  const TButton({
    super.key,
    this.child,
    this.duration = TDurations.hover,
    this.curve = Curves.fastOutSlowIn,
    this.reverseCurve = Curves.decelerate,
    this.scaleEnd = 0.95,
    this.opacityEnd = 0.8,
    this.height,
    this.width,
    this.isEnabled = true,
    this.focusNode,
    this.onPressed,
    this.showHover = true,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.appPadding),
    this.hoverColor,
    this.hoverBorderWidth = 0,
    this.hoverBorderColor,
    this.hoverBorderRadius = TSizes.buttonBorderRadius,
    this.hoverOpacity = 1,
    this.hoverBuilder,
    this.minWidth,
    this.minHeight,
    this.hoverPadding = EdgeInsets.zero,
    this.vibrateMoment = TVibrateMoment.onDown,
  });

  const TButton.scale({
    super.key,
    this.child,
    this.duration = TDurations.hover,
    this.curve = Curves.fastOutSlowIn,
    this.reverseCurve = Curves.decelerate,
    this.scaleEnd = 0.95,
    this.opacityEnd = 1,
    this.height,
    this.width,
    this.isEnabled = true,
    this.focusNode,
    this.onPressed,
    this.showHover = true,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.appPadding),
    this.hoverColor,
    this.hoverBorderWidth = 0,
    this.hoverBorderColor,
    this.hoverBorderRadius = TSizes.buttonBorderRadius,
    this.hoverOpacity = 1,
    this.hoverBuilder,
    this.minWidth,
    this.minHeight,
    this.hoverPadding = EdgeInsets.zero,
    this.vibrateMoment = TVibrateMoment.onDown,
  });

  const TButton.opacity({
    super.key,
    this.child,
    this.duration = TDurations.hover,
    this.curve = Curves.fastOutSlowIn,
    this.reverseCurve = Curves.decelerate,
    this.scaleEnd = 1,
    this.opacityEnd = 0.8,
    this.height,
    this.width,
    this.isEnabled = true,
    this.focusNode,
    this.onPressed,
    this.showHover = true,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.appPadding),
    this.hoverColor,
    this.hoverBorderWidth = 0,
    this.hoverBorderColor,
    this.hoverBorderRadius = TSizes.buttonBorderRadius,
    this.hoverOpacity = 1,
    this.hoverBuilder,
    this.minWidth,
    this.minHeight,
    this.hoverPadding = EdgeInsets.zero,
    this.vibrateMoment = TVibrateMoment.onDown,
  });

  final Widget? child;
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  final double scaleEnd;
  final double opacityEnd;
  final FocusNode? focusNode;
  final bool isEnabled;
  final double? height;
  final double? width;
  final double? minWidth;
  final double? minHeight;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final bool showHover;
  final Color? hoverColor;
  final double hoverBorderWidth;
  final Color? hoverBorderColor;
  final double hoverBorderRadius;
  final double hoverOpacity;
  final EdgeInsets hoverPadding;
  final HoverWidgetBuilder? hoverBuilder;
  final TVibrateMoment vibrateMoment;

  @override
  State<TButton> createState() => _TButtonState();
}

class _TButtonState extends State<TButton> with SingleTickerProviderStateMixin {
  Size? _childSize;

  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  late FocusNode focusNode = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleEnd).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: widget.opacityEnd).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      focusNode = widget.focusNode ?? FocusNode();
    }

    if (widget.hoverBuilder != oldWidget.hoverBuilder) {
      if (widget.hoverBuilder != null) {
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            _scaleController.forward();
          } else {
            _scaleController.reverse();
          }
        });
      } else {
        focusNode.removeListener(() {
          if (focusNode.hasFocus) {
            _scaleController.forward();
          } else {
            _scaleController.reverse();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
    if (widget.vibrateMoment == TVibrateMoment.onDown) {
      gVibrateSelection();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
    if (widget.vibrateMoment == TVibrateMoment.onUp) {
      gVibrateSelection();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: !widget.isEnabled,
    child: Listener(
      onPointerDown: (_) => _handleTapDown(TapDownDetails(kind: PointerDeviceKind.touch)),
      onPointerUp: (_) => _handleTapUp(TapUpDetails(kind: PointerDeviceKind.touch)),
      onPointerCancel: _handlePointerCancel,
      child: TConstraints(
        minHeight: widget.height ?? widget.minHeight ?? 0,
        minWidth: widget.width ?? widget.minWidth ?? 0,
        maxWidth: widget.width ?? double.infinity,
        maxHeight: widget.height ?? double.infinity,
        child: GestureDetector(
          child: FocusableActionDetector(
            mouseCursor: SystemMouseCursors.click,
            enabled: widget.isEnabled,
            actions: {
              ActivateIntent: CallbackAction(
                onInvoke: (e) {
                  widget.onPressed?.call();
                  return null;
                },
              ),
              DirectionalFocusIntent: CallbackAction(
                onInvoke: (e) {
                  final direction = (e as DirectionalFocusIntent).direction;
                  final focus = focusNode;
                  switch (direction) {
                    case TraversalDirection.up:
                      focus.focusInDirection(TraversalDirection.up);
                      break;
                    case TraversalDirection.down:
                      focus.focusInDirection(TraversalDirection.down);
                      break;
                    case TraversalDirection.left:
                      focus.focusInDirection(TraversalDirection.left);
                      break;
                    case TraversalDirection.right:
                      focus.focusInDirection(TraversalDirection.right);
                      break;
                  }
                  return null;
                },
              ),
            },
            child: MeasureSize(
              onChange: (size) {
                if (_childSize != size) {
                  _childSize = size;
                }
              },
              child: AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  double effectiveScale = _scaleAnimation.value;
                  if (_childSize != null) {
                    // Calculate the minimum scale such that the reduction is no more than 4 pixels.
                    final minScaleWidth = _childSize!.width > 0
                        ? (_childSize!.width - 4) / _childSize!.width
                        : 1.0;
                    final minScaleHeight = _childSize!.height > 0
                        ? (_childSize!.height - 4) / _childSize!.height
                        : 1.0;
                    final minAllowedScale = math.max(minScaleWidth, minScaleHeight);
                    effectiveScale = math.max(_scaleAnimation.value, minAllowedScale);
                  }
                  return Transform.scale(
                    scale: effectiveScale,
                    child: Opacity(opacity: _opacityAnimation.value, child: child),
                  );
                },
                child: THoverable(
                  child: widget.child,
                  duration: widget.duration,
                  isActive: widget.isEnabled && widget.showHover,
                  color: widget.hoverColor,
                  curve: widget.curve,
                  borderWidth: widget.hoverBorderWidth,
                  borderColor: widget.hoverBorderColor,
                  borderRadius: widget.hoverBorderRadius,
                  opacity: widget.hoverOpacity,
                  padding: widget.hoverPadding,
                  hoverBuilder: widget.hoverBuilder,
                ),
              ),
            ),
          ),
          onTapDown: (_) {
            if (widget.vibrateMoment == TVibrateMoment.onDown) {
              gVibrateSelection();
            }
          },
          onTapUp: (_) {
            if (widget.vibrateMoment == TVibrateMoment.onUp) {
              gVibrateSelection();
            }
            widget.onPressed?.call();
          },
        ),
      ),
    ),
  );
}
