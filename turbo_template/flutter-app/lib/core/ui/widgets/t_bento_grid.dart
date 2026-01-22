import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';

// =============================================================================
// LAYOUT RESULT MODEL
// =============================================================================

/// Computed layout result for a single bento item.
class BentoLayoutResult {
  const BentoLayoutResult({
    required this.index,
    required this.position,
    required this.size,
  });

  final int index;
  final Offset position;
  final Size size;

  BentoLayoutResult lerp(BentoLayoutResult other, double t) {
    return BentoLayoutResult(
      index: index,
      position: Offset.lerp(position, other.position, t)!,
      size: Size.lerp(size, other.size, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BentoLayoutResult &&
          index == other.index &&
          position == other.position &&
          size == other.size;

  @override
  int get hashCode => Object.hash(index, position, size);
}

// =============================================================================
// LAYOUT CALCULATOR
// =============================================================================

/// Calculates proportional bento grid layouts where items fill all available space.
class BentoLayoutCalculator {
  const BentoLayoutCalculator._();

  static const double _minItemDimension = 60.0;

  /// Calculate layout for all items based on variant and available space.
  static List<BentoLayoutResult> calculateLayout({
    required List<TBentoItem> items,
    required Size availableSize,
    required double spacing,
    required int crossAxisCount,
    required TBentoGridVariant variant,
  }) {
    if (items.isEmpty) return [];
    if (items.length == 1) {
      return [
        BentoLayoutResult(
          index: 0,
          position: Offset.zero,
          size: availableSize,
        ),
      ];
    }

    return switch (variant) {
      TBentoGridVariant.masonry => _calculateMasonryLayout(
          items: items,
          availableSize: availableSize,
          spacing: spacing,
          crossAxisCount: crossAxisCount,
        ),
      TBentoGridVariant.magazine => _calculateMagazineLayout(
          items: items,
          availableSize: availableSize,
          spacing: spacing,
          crossAxisCount: crossAxisCount,
        ),
      TBentoGridVariant.brutalist => _calculateBrutalistLayout(
          items: items,
          availableSize: availableSize,
          spacing: spacing,
        ),
    };
  }

  /// Masonry: Greedy column packing with proportional heights.
  static List<BentoLayoutResult> _calculateMasonryLayout({
    required List<TBentoItem> items,
    required Size availableSize,
    required double spacing,
    required int crossAxisCount,
  }) {
    final totalSize = items.fold<double>(0, (sum, item) => sum + item.size);
    final columnWidth =
        (availableSize.width - spacing * (crossAxisCount - 1)) / crossAxisCount;
    final columnHeights = List.filled(crossAxisCount, 0.0);
    final results = <BentoLayoutResult>[];

    // Sort indices by size descending for better packing
    final sortedIndices = List.generate(items.length, (i) => i)
      ..sort((a, b) => items[b].size.compareTo(items[a].size));

    // First pass: calculate initial heights based on proportional area
    final itemHeights = <int, double>{};
    for (final index in sortedIndices) {
      final proportion = items[index].size / totalSize;
      // Target area for this item based on proportion
      final targetArea = proportion * availableSize.width * availableSize.height;
      final height = (targetArea / columnWidth).clamp(_minItemDimension, double.infinity);
      itemHeights[index] = height;
    }

    // Place items in shortest column
    final columnAssignments = <int, int>{};
    for (final index in sortedIndices) {
      // Find shortest column
      int shortestCol = 0;
      for (int c = 1; c < crossAxisCount; c++) {
        if (columnHeights[c] < columnHeights[shortestCol]) shortestCol = c;
      }

      columnAssignments[index] = shortestCol;
      columnHeights[shortestCol] += itemHeights[index]! + spacing;
    }

    // Find max column height and scale all heights to fill available space
    final maxColumnHeight = columnHeights.reduce(math.max);
    final totalSpacingPerColumn = spacing * (items.length / crossAxisCount).ceil();
    final targetHeight = availableSize.height;
    final scaleFactor =
        maxColumnHeight > 0 ? (targetHeight + totalSpacingPerColumn) / maxColumnHeight : 1.0;

    // Reset column heights for final positioning
    columnHeights.fillRange(0, crossAxisCount, 0.0);

    // Second pass: place items with scaled heights in original order for consistent indexing
    for (int index = 0; index < items.length; index++) {
      final col = columnAssignments[index]!;
      final scaledHeight = (itemHeights[index]! * scaleFactor).clamp(_minItemDimension, double.infinity);

      results.add(BentoLayoutResult(
        index: index,
        position: Offset(
          col * (columnWidth + spacing),
          columnHeights[col],
        ),
        size: Size(columnWidth, scaledHeight),
      ));

      columnHeights[col] += scaledHeight + spacing;
    }

    return results;
  }

  /// Magazine: Hero card + proportional grid below.
  static List<BentoLayoutResult> _calculateMagazineLayout({
    required List<TBentoItem> items,
    required Size availableSize,
    required double spacing,
    required int crossAxisCount,
  }) {
    final totalSize = items.fold<double>(0, (sum, item) => sum + item.size);

    // Find hero (largest item)
    int heroIndex = 0;
    double maxSize = items[0].size;
    for (int i = 1; i < items.length; i++) {
      if (items[i].size > maxSize) {
        maxSize = items[i].size;
        heroIndex = i;
      }
    }

    // Hero gets proportional height
    final heroProportion = items[heroIndex].size / totalSize;
    final heroHeight =
        (availableSize.height * heroProportion).clamp(_minItemDimension * 2, availableSize.height * 0.6);

    final results = <BentoLayoutResult>[
      BentoLayoutResult(
        index: heroIndex,
        position: Offset.zero,
        size: Size(availableSize.width, heroHeight),
      ),
    ];

    // Remaining items in grid below
    final gridItems = <int>[];
    for (int i = 0; i < items.length; i++) {
      if (i != heroIndex) gridItems.add(i);
    }

    if (gridItems.isEmpty) return results;

    final gridTop = heroHeight + spacing;
    final gridHeight = availableSize.height - gridTop;
    final gridTotalSize = gridItems.fold<double>(0, (sum, i) => sum + items[i].size);

    final columnWidth =
        (availableSize.width - spacing * (crossAxisCount - 1)) / crossAxisCount;

    // Distribute grid items
    final columnHeights = List.filled(crossAxisCount, 0.0);

    for (int i = 0; i < gridItems.length; i++) {
      final itemIndex = gridItems[i];
      final col = i % crossAxisCount;

      // Calculate height based on proportion of remaining items
      final rowCount = (gridItems.length / crossAxisCount).ceil();
      final itemHeight = (gridHeight / rowCount - spacing).clamp(_minItemDimension, double.infinity);

      results.add(BentoLayoutResult(
        index: itemIndex,
        position: Offset(
          col * (columnWidth + spacing),
          gridTop + columnHeights[col],
        ),
        size: Size(columnWidth, itemHeight),
      ));

      columnHeights[col] += itemHeight + spacing;
    }

    return results;
  }

  /// Brutalist: Full-width strips with proportional heights.
  static List<BentoLayoutResult> _calculateBrutalistLayout({
    required List<TBentoItem> items,
    required Size availableSize,
    required double spacing,
  }) {
    final totalSize = items.fold<double>(0, (sum, item) => sum + item.size);
    final totalSpacing = spacing * (items.length - 1);
    final usableHeight = availableSize.height - totalSpacing;

    final results = <BentoLayoutResult>[];
    double currentY = 0;

    for (int i = 0; i < items.length; i++) {
      final proportion = items[i].size / totalSize;
      final itemHeight = (usableHeight * proportion).clamp(_minItemDimension, double.infinity);

      results.add(BentoLayoutResult(
        index: i,
        position: Offset(0, currentY),
        size: Size(availableSize.width, itemHeight),
      ));

      currentY += itemHeight + spacing;
    }

    return results;
  }
}

// =============================================================================
// FLOW DELEGATE
// =============================================================================

/// High-performance delegate that positions bento items based on pre-computed layout.
class _BentoFlowDelegate extends FlowDelegate {
  _BentoFlowDelegate({
    required this.layout,
    this.previousLayout,
    this.animation,
  }) : super(repaint: animation);

  final List<BentoLayoutResult> layout;
  final List<BentoLayoutResult>? previousLayout;
  final Animation<double>? animation;

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      final current = layout.firstWhere(
        (r) => r.index == i,
        orElse: () => BentoLayoutResult(index: i, position: Offset.zero, size: Size.zero),
      );

      Offset pos = current.position;

      // Interpolate position during animation
      if (previousLayout != null && animation != null && animation!.value < 1.0) {
        final previous = previousLayout!.firstWhere(
          (r) => r.index == i,
          orElse: () => current,
        );
        pos = Offset.lerp(previous.position, current.position, animation!.value)!;
      }

      context.paintChild(
        i,
        transform: Matrix4.translationValues(pos.dx, pos.dy, 0),
      );
    }
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final result = layout.firstWhere(
      (r) => r.index == i,
      orElse: () => BentoLayoutResult(index: i, position: Offset.zero, size: constraints.biggest),
    );

    // Interpolate size during animation
    Size targetSize = result.size;
    if (previousLayout != null && animation != null && animation!.value < 1.0) {
      final previous = previousLayout!.firstWhere(
        (r) => r.index == i,
        orElse: () => result,
      );
      targetSize = Size.lerp(previous.size, result.size, animation!.value)!;
    }

    return BoxConstraints.tight(targetSize);
  }

  @override
  Size getSize(BoxConstraints constraints) => constraints.biggest;

  @override
  bool shouldRepaint(_BentoFlowDelegate oldDelegate) {
    return !listEquals(layout, oldDelegate.layout) ||
        previousLayout != oldDelegate.previousLayout ||
        animation != oldDelegate.animation;
  }
}

// =============================================================================
// VARIANT ENUM
// =============================================================================

/// Visual variant for the bento grid layout.
enum TBentoGridVariant {
  /// Masonry-style layout with staggered cards and glass morphism.
  masonry,

  /// Magazine editorial layout with featured hero card and clean typography.
  magazine,

  /// Brutalist industrial design with monospace typography and sharp edges.
  brutalist,
}

/// Data model for a bento grid item.
class TBentoItem {
  const TBentoItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.size,
    this.backgroundImageUrl,
    this.accentColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final double size;
  final String? backgroundImageUrl;
  final Color? accentColor;
}

/// A bento grid widget that displays items sized relative to each other.
///
/// Items are laid out based on their [TBentoItem.size] values, with larger
/// values resulting in larger cells in the grid. Items fill ALL available space
/// proportionally - larger sizes get more area.
class TBentoGrid extends StatefulWidget {
  const TBentoGrid({
    super.key,
    required this.items,
    required this.variant,
    this.spacing = 12.0,
    this.crossAxisCount = 2,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  final List<TBentoItem> items;
  final TBentoGridVariant variant;
  final double spacing;
  final int crossAxisCount;
  final Duration animationDuration;
  final Curve animationCurve;

  @override
  State<TBentoGrid> createState() => _TBentoGridState();
}

class _TBentoGridState extends State<TBentoGrid> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<BentoLayoutResult>? _previousLayout;
  List<BentoLayoutResult>? _currentLayout;
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TBentoGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
  }

  void _updateLayout(List<BentoLayoutResult> newLayout) {
    if (_currentLayout != null && !listEquals(_currentLayout, newLayout)) {
      _previousLayout = _currentLayout;
      _animationController.forward(from: 0);
    }
    _currentLayout = newLayout;
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
          constraints.hasBoundedHeight ? constraints.maxHeight : 600,
        );

        // Calculate layout
        final layout = BentoLayoutCalculator.calculateLayout(
          items: widget.items,
          availableSize: availableSize,
          spacing: widget.spacing,
          crossAxisCount: widget.crossAxisCount,
          variant: widget.variant,
        );

        // Trigger animation on layout change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && (_lastSize != availableSize || !listEquals(_currentLayout, layout))) {
            _updateLayout(layout);
            _lastSize = availableSize;
          }
        });

        final curvedAnimation = CurvedAnimation(
          parent: _animationController,
          curve: widget.animationCurve,
        );

        return SizedBox(
          width: availableSize.width,
          height: availableSize.height,
          child: Flow(
            delegate: _BentoFlowDelegate(
              layout: layout,
              previousLayout: _previousLayout,
              animation: curvedAnimation,
            ),
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final layoutResult = layout.firstWhere(
                (r) => r.index == index,
                orElse: () => BentoLayoutResult(
                  index: index,
                  position: Offset.zero,
                  size: const Size(100, 100),
                ),
              );

              return RepaintBoundary(
                child: _buildCard(item, layoutResult.size, index),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCard(TBentoItem item, Size size, int index) {
    return switch (widget.variant) {
      TBentoGridVariant.masonry => _MasonryCard(
          item: item,
          size: size,
        ),
      TBentoGridVariant.magazine => index == _getHeroIndex()
          ? _MagazineHeroCard(item: item, size: size)
          : _MagazineGridCard(item: item, size: size),
      TBentoGridVariant.brutalist => _BrutalistCard(
          item: item,
          index: index,
          totalSize: widget.items.fold<double>(0, (sum, i) => sum + i.size),
          size: size,
        ),
    };
  }

  int _getHeroIndex() {
    int heroIndex = 0;
    double maxSize = widget.items[0].size;
    for (int i = 1; i < widget.items.length; i++) {
      if (widget.items[i].size > maxSize) {
        maxSize = widget.items[i].size;
        heroIndex = i;
      }
    }
    return heroIndex;
  }
}

// =============================================================================
// VARIANT 1: MASONRY - Glass morphism with staggered heights
// =============================================================================

class _MasonryCard extends StatelessWidget {
  const _MasonryCard({
    required this.item,
    required this.size,
  });

  final TBentoItem item;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colors = context.colors;
    final accentColor = item.accentColor ?? theme.colorScheme.primary;
    final hasImage = item.backgroundImageUrl != null &&
        item.backgroundImageUrl!.isNotEmpty;

    final isCompact = size.width < 150 || size.height < 120;
    final padding = isCompact ? 12.0 : 16.0;
    final iconSize = isCompact ? 18.0 : 22.0;
    final iconPadding = isCompact ? 8.0 : 10.0;
    const borderRadius = 16.0;

    // Adjust description lines based on available height
    final descriptionLines = ((size.height - 100) / 20).clamp(1, 6).round();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: colors.border.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          child: Stack(
            children: [
              // Background
              Positioned.fill(
                child: hasImage
                    ? Image.network(
                        item.backgroundImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _GlassBackground(
                          accentColor: accentColor,
                        ),
                      )
                    : _GlassBackground(accentColor: accentColor),
              ),

              // Glass overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.card.withValues(alpha: hasImage ? 0.85 : 0.7),
                        colors.card.withValues(alpha: hasImage ? 0.95 : 0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon badge
                    Container(
                      padding: EdgeInsets.all(iconPadding),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        size: iconSize,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(height: isCompact ? 10 : 12),
                    // Title
                    Text(
                      item.title,
                      style: theme.textTheme.large.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.primaryText,
                        height: 1.2,
                      ),
                      maxLines: isCompact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Description - expands to fill available space
                    Expanded(
                      child: Text(
                        item.description,
                        style: theme.textTheme.muted.copyWith(
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: descriptionLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Size indicator
                    Container(
                      height: 4,
                      width: 32 * (item.size / 10).clamp(0.3, 1.0),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassBackground extends StatelessWidget {
  const _GlassBackground({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            accentColor.withValues(alpha: 0.15),
            colors.card,
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// VARIANT 2: MAGAZINE - Editorial layout with hero card
// =============================================================================

class _MagazineHeroCard extends StatelessWidget {
  const _MagazineHeroCard({
    required this.item,
    required this.size,
  });

  final TBentoItem item;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colors = context.colors;
    final accentColor = item.accentColor ?? theme.colorScheme.primary;
    final hasImage = item.backgroundImageUrl != null &&
        item.backgroundImageUrl!.isNotEmpty;

    final isCompact = size.width < 400 || size.height < 150;
    final padding = isCompact ? 16.0 : 28.0;
    final iconSize = isCompact ? 24.0 : 36.0;
    final iconPadding = isCompact ? 12.0 : 20.0;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: [
              // Background image or gradient
              if (hasImage)
                Positioned.fill(
                  child: Image.network(
                    item.backgroundImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: colors.secondary,
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withValues(alpha: 0.05),
                          colors.card,
                        ],
                      ),
                    ),
                  ),
                ),

              // Overlay for readability
              if (hasImage)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colors.card.withValues(alpha: 0.95),
                        ],
                        stops: const [0.3, 0.9],
                      ),
                    ),
                  ),
                ),

              // Content
              Padding(
                padding: EdgeInsets.all(padding),
                child: isCompact
                    ? _buildCompactContent(context, theme, accentColor)
                    : _buildExpandedContent(
                        context, theme, accentColor, iconSize, iconPadding),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactContent(
    BuildContext context,
    ShadThemeData theme,
    Color accentColor,
  ) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                'FEATURED',
                style: theme.textTheme.small.copyWith(
                  color: accentColor.onColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          item.title,
          style: theme.textTheme.large.copyWith(
            color: colors.primaryText,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Text(
            item.description,
            style: theme.textTheme.small.copyWith(
              color: colors.primaryText.withValues(alpha: 0.7),
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    ShadThemeData theme,
    Color accentColor,
    double iconSize,
    double iconPadding,
  ) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  'FEATURED',
                  style: theme.textTheme.small.copyWith(
                    color: accentColor.onColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: theme.textTheme.h3.copyWith(
                  color: colors.primaryText,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: theme.textTheme.p.copyWith(
                  color: colors.primaryText.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          padding: EdgeInsets.all(iconPadding),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: accentColor.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Icon(
            item.icon,
            size: iconSize,
            color: accentColor,
          ),
        ),
      ],
    );
  }
}

class _MagazineGridCard extends StatelessWidget {
  const _MagazineGridCard({
    required this.item,
    required this.size,
  });

  final TBentoItem item;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colors = context.colors;
    final accentColor = item.accentColor ?? theme.colorScheme.primary;

    final isCompact = size.width < 160 || size.height < 100;
    final padding = isCompact ? 12.0 : 20.0;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon row
            Row(
              children: [
                Icon(
                  item.icon,
                  size: isCompact ? 16 : 18,
                  color: accentColor,
                ),
                const Spacer(),
                // Size indicator as dots
                if (!isCompact)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => Container(
                        margin: const EdgeInsets.only(left: 3),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < (item.size / 2).ceil()
                              ? accentColor
                              : colors.border,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isCompact ? 10 : 14),
            // Title
            Text(
              item.title,
              style: (isCompact ? theme.textTheme.p : theme.textTheme.large)
                  .copyWith(
                fontWeight: FontWeight.w700,
                color: colors.primaryText,
                height: 1.2,
              ),
              maxLines: isCompact ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Description - expands to fill available space
            Expanded(
              child: Text(
                item.description,
                style: theme.textTheme.small.copyWith(
                  color: colors.primaryText.withValues(alpha: 0.6),
                  height: 1.4,
                  fontSize: isCompact ? 11 : null,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// VARIANT 3: BRUTALIST - Industrial monospace design
// =============================================================================

class _BrutalistCard extends StatelessWidget {
  const _BrutalistCard({
    required this.item,
    required this.index,
    required this.totalSize,
    required this.size,
  });

  final TBentoItem item;
  final int index;
  final double totalSize;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colors = context.colors;
    final accentColor = item.accentColor ?? theme.colorScheme.primary;
    final sizePercentage = ((item.size / totalSize) * 100).toStringAsFixed(1);
    final hasImage = item.backgroundImageUrl != null &&
        item.backgroundImageUrl!.isNotEmpty;

    final isCompact = size.width < 350 || size.height < 100;
    final padding = isCompact ? 12.0 : 16.0;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          border: Border.all(color: colors.primaryText, width: 2),
        ),
        child: Stack(
          children: [
            // Background image with harsh overlay
            if (hasImage)
              Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    colors.card.withValues(alpha: 0.9),
                    BlendMode.srcOver,
                  ),
                  child: Image.network(
                    item.backgroundImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: index and size
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 6 : 8,
                          vertical: isCompact ? 3 : 4,
                        ),
                        color: colors.primaryText,
                        child: Text(
                          (index + 1).toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: isCompact ? 10 : 12,
                            fontWeight: FontWeight.w900,
                            color: colors.card,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$sizePercentage%',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: isCompact ? 18 : 24,
                          fontWeight: FontWeight.w900,
                          color: accentColor,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isCompact ? 8 : 16),
                  // Title
                  Text(
                    item.title.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: isCompact ? 14 : 18,
                      fontWeight: FontWeight.w900,
                      color: colors.primaryText,
                      letterSpacing: isCompact ? 1 : 2,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Description - expands to fill available space
                  Expanded(
                    child: Text(
                      item.description,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: isCompact ? 10 : 11,
                        color: colors.primaryText.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                      maxLines: ((size.height - 100) / 16).clamp(1, 6).round(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: isCompact ? 6 : 12),
                  // Bottom: icon and progress bar
                  Row(
                    children: [
                      Icon(
                        item.icon,
                        size: isCompact ? 14 : 18,
                        color: accentColor,
                      ),
                      SizedBox(width: isCompact ? 8 : 12),
                      Expanded(
                        child: Container(
                          height: isCompact ? 6 : 8,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.primaryText,
                              width: 1,
                            ),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (item.size / 10).clamp(0.1, 1.0),
                            child: Container(
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
