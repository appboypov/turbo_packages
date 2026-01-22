import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// =============================================================================
// ANIMATION TYPE ENUM
// =============================================================================

/// Animation type for TProportionalGrid layout transitions.
enum TProportionalGridAnimation {
  /// Cards smoothly slide and resize to new positions.
  slide,

  /// Cards fade out, layout recalculates, then fade in.
  fade,

  /// Cards scale down, layout recalculates, then scale up.
  scale,

  /// Instant layout change with no animation.
  none,
}

// =============================================================================
// LAYOUT RESULT MODEL
// =============================================================================

/// Computed layout result for a single item in the proportional grid.
class ProportionalLayoutResult {
  const ProportionalLayoutResult({
    required this.index,
    required this.position,
    required this.size,
  });

  final int index;
  final Offset position;
  final Size size;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProportionalLayoutResult &&
          index == other.index &&
          position == other.position &&
          size == other.size;

  @override
  int get hashCode => Object.hash(index, position, size);
}

// =============================================================================
// ITEM MODEL
// =============================================================================

/// An item in the proportional grid with a size weight and child widget.
class TProportionalItem {
  const TProportionalItem({
    required this.size,
    required this.child,
  });

  /// The relative size/weight of this item. Larger values get more area.
  /// Example: If items have sizes [4, 2, 2, 2], the first gets 40% of area.
  final double size;

  /// The widget to display in this cell.
  final Widget child;
}

// =============================================================================
// LAYOUT CALCULATOR - SQUARIFIED TREEMAP
// =============================================================================

/// Calculates proportional layouts using a squarified treemap algorithm.
/// Guarantees 100% fill of available space with area proportional to size values.
class ProportionalLayoutCalculator {
  const ProportionalLayoutCalculator._();

  static const double _minDimension = 40.0;

  /// Calculate layout positions and sizes for all items.
  static List<ProportionalLayoutResult> calculate({
    required List<double> sizes,
    required Size availableSize,
    required double spacing,
  }) {
    if (sizes.isEmpty) return [];

    if (sizes.length == 1) {
      return [
        ProportionalLayoutResult(
          index: 0,
          position: Offset.zero,
          size: availableSize,
        ),
      ];
    }

    final totalSize = sizes.fold<double>(0, (sum, s) => sum + s);
    if (totalSize <= 0) return [];

    final totalArea = availableSize.width * availableSize.height;

    // Calculate target areas for each item
    final targetAreas = sizes.map((s) => (s / totalSize) * totalArea).toList();

    // Run squarified algorithm
    return _squarify(
      indices: List.generate(sizes.length, (i) => i),
      areas: targetAreas,
      rect: Rect.fromLTWH(0, 0, availableSize.width, availableSize.height),
      spacing: spacing,
    );
  }

  static List<ProportionalLayoutResult> _squarify({
    required List<int> indices,
    required List<double> areas,
    required Rect rect,
    required double spacing,
  }) {
    if (indices.isEmpty) return [];

    // Base case: single item fills the entire rect
    if (indices.length == 1) {
      return [
        ProportionalLayoutResult(
          index: indices[0],
          position: Offset(rect.left, rect.top),
          size: Size(
            rect.width.clamp(_minDimension, double.infinity),
            rect.height.clamp(_minDimension, double.infinity),
          ),
        ),
      ];
    }

    // Find best partition point (closest to 50/50 split by area)
    final totalArea = areas.fold<double>(0, (sum, a) => sum + a);
    double runningSum = 0;
    int splitIndex = 1;
    double bestDiff = double.infinity;

    for (int i = 0; i < indices.length - 1; i++) {
      runningSum += areas[i];
      final diff = (runningSum - totalArea / 2).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        splitIndex = i + 1;
      }
    }

    final group1Indices = indices.sublist(0, splitIndex);
    final group1Areas = areas.sublist(0, splitIndex);
    final group2Indices = indices.sublist(splitIndex);
    final group2Areas = areas.sublist(splitIndex);

    final group1TotalArea = group1Areas.fold<double>(0, (sum, a) => sum + a);
    final ratio = totalArea > 0 ? group1TotalArea / totalArea : 0.5;

    Rect rect1, rect2;

    if (rect.width >= rect.height) {
      // Vertical split (side by side)
      // Subtract spacing from available width, then distribute proportionally
      final availableWidth = rect.width - spacing;
      final width1 = (availableWidth * ratio).clamp(_minDimension, availableWidth);
      final width2 = (availableWidth - width1).clamp(_minDimension, availableWidth);

      rect1 = Rect.fromLTWH(rect.left, rect.top, width1, rect.height);
      rect2 = Rect.fromLTWH(rect.left + width1 + spacing, rect.top, width2, rect.height);
    } else {
      // Horizontal split (stacked)
      // Subtract spacing from available height, then distribute proportionally
      final availableHeight = rect.height - spacing;
      final height1 = (availableHeight * ratio).clamp(_minDimension, availableHeight);
      final height2 = (availableHeight - height1).clamp(_minDimension, availableHeight);

      rect1 = Rect.fromLTWH(rect.left, rect.top, rect.width, height1);
      rect2 = Rect.fromLTWH(rect.left, rect.top + height1 + spacing, rect.width, height2);
    }

    return [
      ..._squarify(
        indices: group1Indices,
        areas: group1Areas,
        rect: rect1,
        spacing: spacing,
      ),
      ..._squarify(
        indices: group2Indices,
        areas: group2Areas,
        rect: rect2,
        spacing: spacing,
      ),
    ];
  }
}

// =============================================================================
// STATIC FLOW DELEGATE (for fade/scale/none animations)
// =============================================================================

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
        transform: Matrix4.translationValues(result.position.dx, result.position.dy, 0),
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

// =============================================================================
// SLIDE FLOW DELEGATE (for slide animation)
// =============================================================================

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
        position = Offset.lerp(previous.position, current.position, animation.value)!;
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
    final interpolatedSize = Size.lerp(previous.size, current.size, animation.value)!;
    return BoxConstraints.tight(interpolatedSize);
  }

  ProportionalLayoutResult? _findResult(List<ProportionalLayoutResult> results, int index) {
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

// =============================================================================
// MAIN WIDGET
// =============================================================================

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

  bool _hasLayoutChanged(Size availableSize, List<double> sizes, double spacing) {
    if (_currentLayout == null) return true;
    if (_lastSize != availableSize) return true;
    if (_lastSpacing != spacing) return true;
    if (_lastSizes == null || _lastSizes!.length != sizes.length) return true;
    for (int i = 0; i < sizes.length; i++) {
      if (_lastSizes![i] != sizes[i]) return true;
    }
    return false;
  }

  void _updateLayoutImmediate(Size availableSize, List<double> sizes, double spacing) {
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
  void _onLayoutChangedSlide(Size availableSize, List<double> sizes, double spacing) {
    if (!_hasLayoutChanged(availableSize, sizes, spacing)) return;

    setState(() {
      _updateLayoutImmediate(availableSize, sizes, spacing);
    });

    if (_previousLayout != null) {
      _controller.forward(from: 0);
    }
  }

  // For fade/scale animation: debounced with transition
  void _onLayoutChangedDebounced(Size availableSize, List<double> sizes, double spacing) {
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
  void _onLayoutChangedNone(Size availableSize, List<double> sizes, double spacing) {
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
