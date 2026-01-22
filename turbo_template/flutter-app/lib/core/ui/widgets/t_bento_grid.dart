import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
// FLOW DELEGATE
// =============================================================================

/// High-performance delegate that positions items based on pre-computed layout.
class _ProportionalFlowDelegate extends FlowDelegate {
  _ProportionalFlowDelegate({
    required this.layout,
  });

  final List<ProportionalLayoutResult> layout;

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      final result = _findResult(layout, i);
      if (result == null) continue;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(result.position.dx, result.position.dy, 0),
      );
    }
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final result = _findResult(layout, i);
    if (result == null) return BoxConstraints.tight(Size.zero);
    return BoxConstraints.tight(result.size);
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
  bool shouldRepaint(_ProportionalFlowDelegate oldDelegate) {
    return !listEquals(layout, oldDelegate.layout);
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
///
/// When layout parameters change (sizes, available space), the grid fades out,
/// waits for changes to stabilize, then fades back in with the new layout.
class TProportionalGrid extends StatefulWidget {
  const TProportionalGrid({
    super.key,
    required this.items,
    this.spacing = 8.0,
    this.debounceDuration = const Duration(milliseconds: 150),
    this.fadeDuration = const Duration(milliseconds: 200),
    this.fadeCurve = Curves.easeInOut,
  });

  /// The items to display in the grid.
  final List<TProportionalItem> items;

  /// Spacing between items.
  final double spacing;

  /// How long to wait after changes stop before recalculating layout.
  final Duration debounceDuration;

  /// Duration of the fade in/out animation.
  final Duration fadeDuration;

  /// Curve of the fade animation.
  final Curve fadeCurve;

  @override
  State<TProportionalGrid> createState() => _TProportionalGridState();
}

class _TProportionalGridState extends State<TProportionalGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  Timer? _debounceTimer;
  List<ProportionalLayoutResult>? _stableLayout;
  Size? _lastStableSize;
  List<double>? _lastStableSizes;
  double? _lastStableSpacing;

  bool _isWaitingForStability = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: widget.fadeDuration,
      vsync: this,
      value: 1.0, // Start visible
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: widget.fadeCurve,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TProportionalGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fadeDuration != oldWidget.fadeDuration) {
      _fadeController.duration = widget.fadeDuration;
    }
    if (widget.fadeCurve != oldWidget.fadeCurve) {
      _fadeAnimation = CurvedAnimation(
        parent: _fadeController,
        curve: widget.fadeCurve,
      );
    }
  }

  /// Check if layout parameters have changed from the last stable state.
  bool _hasLayoutChanged(Size availableSize, List<double> sizes, double spacing) {
    if (_stableLayout == null) return true;
    if (_lastStableSize != availableSize) return true;
    if (_lastStableSpacing != spacing) return true;
    if (_lastStableSizes == null || _lastStableSizes!.length != sizes.length) return true;
    for (int i = 0; i < sizes.length; i++) {
      if (_lastStableSizes![i] != sizes[i]) return true;
    }
    return false;
  }

  /// Called when layout parameters change - starts fade out and debounce.
  void _onLayoutChanged(Size availableSize, List<double> sizes, double spacing) {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Start fading out if not already
    if (!_isWaitingForStability) {
      _isWaitingForStability = true;
      _fadeController.reverse();
    }

    // Start debounce timer
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (!mounted) return;

      // Layout has stabilized - calculate new layout
      final newLayout = ProportionalLayoutCalculator.calculate(
        sizes: sizes,
        availableSize: availableSize,
        spacing: spacing,
      );

      setState(() {
        _stableLayout = newLayout;
        _lastStableSize = availableSize;
        _lastStableSizes = List.from(sizes);
        _lastStableSpacing = spacing;
        _isWaitingForStability = false;
      });

      // Fade back in
      _fadeController.forward();
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

        // Check if layout parameters changed
        if (_hasLayoutChanged(availableSize, sizes, spacing)) {
          // Schedule the change handling after this build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _onLayoutChanged(availableSize, sizes, spacing);
            }
          });
        }

        // If no stable layout yet, calculate initial one immediately
        if (_stableLayout == null) {
          _stableLayout = ProportionalLayoutCalculator.calculate(
            sizes: sizes,
            availableSize: availableSize,
            spacing: spacing,
          );
          _lastStableSize = availableSize;
          _lastStableSizes = List.from(sizes);
          _lastStableSpacing = spacing;
        }

        return SizedBox(
          width: availableSize.width,
          height: availableSize.height,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Flow(
              delegate: _ProportionalFlowDelegate(
                layout: _stableLayout!,
              ),
              children: widget.items.asMap().entries.map((entry) {
                return RepaintBoundary(
                  child: entry.value.child,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
