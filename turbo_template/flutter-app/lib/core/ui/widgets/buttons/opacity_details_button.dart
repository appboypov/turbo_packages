import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/constants/spacings.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';

class OpacityDetailsButton extends StatefulWidget {
  const OpacityDetailsButton({
    Key? key,
    required this.child,
    this.minSize = 0,
    this.onPressed,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Function(Offset globalPosition)? onPressed;
  final double minSize;

  bool get enabled => onPressed != null;

  @override
  OpacityDetailsButtonState createState() => OpacityDetailsButtonState();
}

class OpacityDetailsButtonState extends State<OpacityDetailsButton>
    with SingleTickerProviderStateMixin {
  static const Duration _scaleDuration = TDurations.animation;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _scaleDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: Spacings.opacityDisabled)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeIn,
            reverseCurve: Curves.elasticOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails tapDownDetails) {
    if (widget.enabled) {
      widget.onPressed!.call(tapDownDetails.globalPosition);
      _animationController.animateTo(1.0);
    }
  }

  Future<void> _handleTapUp(TapUpDetails tapUpdateDetails) async {
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
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: widget.minSize,
          minHeight: widget.minSize,
        ),
        child: Padding(
          padding: widget.padding,
          child: FadeTransition(opacity: _scaleAnimation, child: widget.child),
        ),
      ),
    ),
  );
}
