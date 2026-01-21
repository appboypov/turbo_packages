import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/context_def.dart';

class OpacityButton extends StatefulWidget {
  const OpacityButton({
    super.key,
    required this.child,
    this.minSize = 0,
    this.onPressed,
    this.padding = EdgeInsets.zero,
    this.pressedOpacity = 0.6,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.onPressedWithContext,
    this.focusNode,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double minSize;
  final double? pressedOpacity;
  final HitTestBehavior hitTestBehavior;
  final ContextDef? onPressedWithContext;
  final FocusNode? focusNode;

  bool get enabled => onPressed != null;

  @override
  OpacityButtonState createState() => OpacityButtonState();
}

class OpacityButtonState extends State<OpacityButton> with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(OpacityButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTween();
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode = widget.focusNode ?? FocusNode();
    }
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: _fadeDuration)
        : _animationController.animateTo(0.0, duration: _fadeDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: widget.hitTestBehavior,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: Focus(
          focusNode: _focusNode,
          child: Semantics(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: widget.minSize, minHeight: widget.minSize),
              child: widget.padding != null
                  ? Padding(
                      padding: widget.padding!,
                      child: FadeTransition(opacity: _opacityAnimation, child: widget.child),
                    )
                  : FadeTransition(opacity: _opacityAnimation, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
