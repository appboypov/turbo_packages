import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_proportional_grid_animation.dart';
import 'package:turbo_flutter_template/core/ui/models/proportional_layout_result.dart';
import 'package:turbo_flutter_template/core/ui/models/t_proportional_item.dart';
import 'package:turbo_flutter_template/core/ui/utils/proportional_layout_calculator.dart';

/// High-performance delegate that positions items based on pre-computed layout.
/// Used for fade, scale, and none animation types.
class _StaticFlowDelegate extends FlowDelegate {
  _StaticFlowDelegate({
    required this.layout,
  });

  final List<ProportionalLayoutResult> layout;

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      final result = _findResult(i);
      if (result == null) continue;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          result.position.dx,
          result.position.dy,
          0,
        ),
      );
    }
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final result = _findResult(i);
    if (result == null) return BoxConstraints.tight(Size.zero);
    return BoxConstraints.tight(result.size);
  }

  ProportionalLayoutResult? _findResult(int index) {
    for (final r in layout) {
      if (r.index == index) return r;
    }
    return null;
  }

  @override
  Size getSize(BoxConstraints constraints) => constraints.biggest;

  @override
  bool shouldRepaint(_StaticFlowDelegate oldDelegate) {
    return !listEquals(layout, oldDelegate.layout);
  }

  @override
  bool shouldRelayout(_StaticFlowDelegate oldDelegate) {
    return !listEquals(layout, oldDelegate.layout);
  }
}

/// Delegate that interpolates between layouts during animation.
/// Used for slide animation type.
class _SlideFlowDelegate extends FlowDelegate {
  _SlideFlowDelegate({
    required this.currentLayout,
    this.previousLayout,
    required this.animation,
  }) : super(repaint: animation);

  final List<ProportionalLayoutResult> currentLayout;
  final List<ProportionalLayoutResult>? previousLayout;
  final Animation<double> animation;

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      final current = _findResult(currentLayout, i);
      if (current == null) continue;

      Offset position = current.position;
      if (previousLayout != null && animation.value < 1.0) {
        final previous = _findResult(previousLayout!, i) ?? current;
        position = Offset.lerp(
          previous.position,
          current.position,
          animation.value,
        )!;
      }

      context.paintChild(
        i,
        transform: Matrix4.translationValues(position.dx, position.dy, 0),
      );
    }
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final current = _findResult(currentLayout, i);
    if (current == null) return BoxConstraints.tight(Size.zero);

    if (previousLayout == null || animation.value >= 1.0) {
      return BoxConstraints.tight(current.size);
    }

    final previous = _findResult(previousLayout!, i) ?? current;
    final interpolatedSize = Size.lerp(
      previous.size,
      current.size,
      animation.value,
    )!;
    return BoxConstraints.tight(interpolatedSize);
  }

  ProportionalLayoutResult? _findResult(
    List<ProportionalLayoutResult> results,
    int index,
  ) {
    for (final r in results) {
      if (r.index == index) return r;
    }
    return null;
  }

  @override
  Size getSize(BoxConstraints constraints) => constraints.biggest;

  @override
  bool shouldRepaint(_SlideFlowDelegate oldDelegate) => true;

  @override
  bool shouldRelayout(_SlideFlowDelegate oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        !listEquals(currentLayout, oldDelegate.currentLayout);
  }
}

/// A proportional grid that fills 100% of available space.
///
/// Items are sized based on their [TProportionalItem.size] values relative to
/// each other. Larger sizes get proportionally more area.
///
/// Example: If items have sizes [4, 2, 2, 2], total is 10.
/// - Item 1 gets 40% of area (4/10)
/// - Items 2-4 each get 20% of area (2/10)
///
/// The layout algorithm (squarified treemap) automatically arranges items
/// to minimize aspect ratio distortion while guaranteeing 100% space fill.
class TProportionalGrid extends StatefulWidget {
  const TProportionalGrid({
    super.key,
    required this.items,
    this.spacing = 8.0,
    this.animation = TProportionalGridAnimation.fade,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.debounceDuration = const Duration(milliseconds: 150),
  });

  /// The items to display in the grid.
  final List<TProportionalItem> items;

  /// Spacing between items.
  final double spacing;

  /// The animation type to use for layout transitions.
  final TProportionalGridAnimation animation;

  /// Duration of the animation.
  final Duration animationDuration;

  /// Curve of the animation.
  final Curve animationCurve;

  /// How long to wait after changes stop before recalculating layout.
  /// Only used for [TProportionalGridAnimation.fade] and [TProportionalGridAnimation.scale].
  final Duration debounceDuration;

  @override
  State<TProportionalGrid> createState() => _TProportionalGridState();
}

class _TProportionalGridState extends State<TProportionalGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Timer? _debounceTimer;
  List<ProportionalLayoutResult>? _currentLayout;
  List<ProportionalLayoutResult>? _previousLayout;
  Size? _lastSize;
  List<double>? _lastSizes;
  double? _lastSpacing;

  bool _isWaitingForStability = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    // For slide animation, add listener to trigger rebuilds
    if (widget.animation == TProportionalGridAnimation.slide) {
      _controller.addListener(_onAnimationTick);
    }
  }

  void _onAnimationTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onAnimationTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TProportionalGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationDuration != oldWidget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (widget.animationCurve != oldWidget.animationCurve) {
      _animation = CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      );
    }
    if (widget.animation != oldWidget.animation) {
      _controller.removeListener(_onAnimationTick);
      if (widget.animation == TProportionalGridAnimation.slide) {
        _controller.addListener(_onAnimationTick);
      }
    }
  }

  bool _hasLayoutChanged(
    Size availableSize,
    List<double> sizes,
    double spacing,
  ) {
    if (_currentLayout == null) return true;
    if (_lastSize != availableSize) return true;
    if (_lastSpacing != spacing) return true;
    if (_lastSizes == null || _lastSizes!.length != sizes.length) return true;
    for (int i = 0; i < sizes.length; i++) {
      if (_lastSizes![i] != sizes[i]) return true;
    }
    return false;
  }

  void _updateLayoutImmediate(
    Size availableSize,
    List<double> sizes,
    double spacing,
  ) {
    final newLayout = ProportionalLayoutCalculator.calculate(
      sizes: sizes,
      availableSize: availableSize,
      spacing: spacing,
    );

    _previousLayout = _currentLayout;
    _currentLayout = newLayout;
    _lastSize = availableSize;
    _lastSizes = List.from(sizes);
    _lastSpacing = spacing;
  }

  // For slide animation: immediate update with animation
  void _onLayoutChangedSlide(
    Size availableSize,
    List<double> sizes,
    double spacing,
  ) {
    if (!_hasLayoutChanged(availableSize, sizes, spacing)) return;

    setState(() {
      _updateLayoutImmediate(availableSize, sizes, spacing);
    });

    if (_previousLayout != null) {
      _controller.forward(from: 0);
    }
  }

  // For fade/scale animation: debounced with transition
  void _onLayoutChangedDebounced(
    Size availableSize,
    List<double> sizes,
    double spacing,
  ) {
    _debounceTimer?.cancel();

    if (!_isWaitingForStability) {
      _isWaitingForStability = true;
      _controller.reverse();
    }

    _debounceTimer = Timer(widget.debounceDuration, () {
      if (!mounted) return;

      setState(() {
        _updateLayoutImmediate(availableSize, sizes, spacing);
        _isWaitingForStability = false;
      });

      _controller.forward();
    });
  }

  // For none animation: immediate update, no animation
  void _onLayoutChangedNone(
    Size availableSize,
    List<double> sizes,
    double spacing,
  ) {
    if (!_hasLayoutChanged(availableSize, sizes, spacing)) return;

    setState(() {
      _updateLayoutImmediate(availableSize, sizes, spacing);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableSize = Size(
          constraints.maxWidth,
          constraints.hasBoundedHeight ? constraints.maxHeight : 400,
        );

        final sizes = widget.items.map((item) => item.size).toList();
        final spacing = widget.spacing;

        // Initialize layout if needed
        if (_currentLayout == null) {
          _updateLayoutImmediate(availableSize, sizes, spacing);
          // Start visible for fade/scale
          if (widget.animation == TProportionalGridAnimation.fade ||
              widget.animation == TProportionalGridAnimation.scale) {
            _controller.value = 1.0;
          }
        }

        // Handle layout changes based on animation type
        if (_hasLayoutChanged(availableSize, sizes, spacing)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            switch (widget.animation) {
              case TProportionalGridAnimation.slide:
                _onLayoutChangedSlide(availableSize, sizes, spacing);
              case TProportionalGridAnimation.fade:
              case TProportionalGridAnimation.scale:
                _onLayoutChangedDebounced(availableSize, sizes, spacing);
              case TProportionalGridAnimation.none:
                _onLayoutChangedNone(availableSize, sizes, spacing);
            }
          });
        }

        return SizedBox(
          width: availableSize.width,
          height: availableSize.height,
          child: _buildAnimatedContent(),
        );
      },
    );
  }

  Widget _buildAnimatedContent() {
    final flow = Flow(
      delegate: widget.animation == TProportionalGridAnimation.slide
          ? _SlideFlowDelegate(
              currentLayout: _currentLayout!,
              previousLayout: _previousLayout,
              animation: _animation,
            )
          : _StaticFlowDelegate(layout: _currentLayout!),
      children: widget.items.asMap().entries.map((entry) {
        return RepaintBoundary(child: entry.value.child);
      }).toList(),
    );

    return switch (widget.animation) {
      TProportionalGridAnimation.slide => flow,
      TProportionalGridAnimation.fade => FadeTransition(
        opacity: _animation,
        child: flow,
      ),
      TProportionalGridAnimation.scale => ScaleTransition(
        scale: _animation,
        child: flow,
      ),
      TProportionalGridAnimation.none => flow,
    };
  }
}
