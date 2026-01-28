import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';

class ScaleButton extends StatefulWidget {
  const ScaleButton({
    Key? key,
    required this.child,
    this.minSize = 0,
    this.onPressed,
    this.padding = EdgeInsets.zero,
    this.hitTestBehavior = HitTestBehavior.translucent,
    this.tweenEnd = ScaleButton.tweenEndDefault,
  }) : super(key: key);

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final double minSize;
  final HitTestBehavior hitTestBehavior;
  final double tweenEnd;

  static const double tweenEndDefault = 0.80;

  bool get enabled => onPressed != null;

  @override
  ScaleButtonState createState() => ScaleButtonState();
}

class ScaleButtonState extends State<ScaleButton> with SingleTickerProviderStateMixin {
  static const Duration _scaleDuration = TDurations.hover;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _scaleDuration, vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.tweenEnd).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.decelerate,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails event) {
    if (widget.enabled) {
      widget.onPressed!.call();
      _animationController.animateTo(1.0);
    }
  }

  Future<void> _handleTapUp(TapUpDetails event) async {
    if (widget.enabled) {
      _animationController.stop(); // Stop any ongoing animations
      await _animationController.animateTo(1.0);
      await _animationController.animateTo(0.0);
    }
  }

  void _handleTapCancel() {
    if (widget.enabled) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      behavior: widget.hitTestBehavior,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: widget.minSize, minHeight: widget.minSize),
        child: Padding(
          padding: widget.padding,
          child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
        ),
      ),
    ),
  );
}
