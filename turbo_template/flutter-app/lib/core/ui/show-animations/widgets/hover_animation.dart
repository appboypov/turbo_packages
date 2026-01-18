import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

class HoverAnimation extends StatefulWidget {
  const HoverAnimation({
    Key? key,
    required this.child,
    this.animateDuration = TDurations.hover,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.padding = EdgeInsets.zero,
    this.cursor = SystemMouseCursors.click,
    this.overrideHover = false,
    this.onHover,
    this.onEnter,
    this.onExit,
    this.shouldHover,
  }) : super(key: key);

  final Widget child;
  final Duration animateDuration;
  final Color? color;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final MouseCursor cursor;
  final bool overrideHover;
  final void Function(PointerHoverEvent event, AnimationController animationController)? onHover;
  final VoidCallback? onEnter;
  final void Function(PointerExitEvent event, AnimationController animationController)? onExit;
  final bool Function()? shouldHover;

  @override
  _HoverAnimationState createState() => _HoverAnimationState();
}

class _HoverAnimationState extends State<HoverAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animateDuration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEnterEvent event) {
    widget.onEnter?.call();
    _controller.forward();
  }

  void _onExit(PointerExitEvent event) {
    widget.onExit?.call(event, _controller);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: widget.cursor,
    onEnter: _onEnter,
    onExit: _onExit,
    onHover: (event) => widget.onHover?.call(event, _controller),
    child: AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        if (widget.shouldHover?.call() == false) {
          return child!;
        }
        return CustomPaint(
          painter: _SquarePainter(
            color: widget.color ?? context.colors.hover,
            controllerValue: widget.overrideHover ? 1 : _controller.value,
            borderRadius: widget.borderRadius,
            padding: widget.padding,
          ),
          child: child!,
        );
      },
    ),
  );
}

class _SquarePainter extends CustomPainter {
  final Color color;
  final double controllerValue;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  _SquarePainter({
    required this.color,
    required this.controllerValue,
    required this.borderRadius,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color.withValues(alpha: controllerValue);

    final rect =
        Offset(0 - padding.left, 0 - padding.top) &
        Size(size.width + padding.left + padding.right, size.height + padding.top + padding.bottom);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SquarePainter oldDelegate) {
    return oldDelegate.controllerValue != controllerValue ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.padding != padding;
  }
}
