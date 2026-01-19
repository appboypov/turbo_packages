import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/material.dart';
import 'package:roomy_mobile/animations/widgets/t_animated_size.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

/// A reusable list view widget that supports reordering and animations.
///
/// This widget encapsulates the common functionality of [AnimatedReorderableListView]
/// with predefined animation settings and styling.
class TListView<T extends Object> extends StatelessWidget {
  const TListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onReorder,
    this.shrinkWrap = true,
    this.enableSwap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.proxyDecorator,
    this.dragStartDelay = TDurations.animationX1p5,
    this.insertDuration = TDurations.animationX1p5,
    this.removeDuration = TDurations.animationX1p5,
    this.isSameItem,
    this.canReorder = true,
  });

  /// The list of items to display.
  final List<T> items;

  /// Builder function to create the widget for each item.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Callback function when items are reordered.
  final ReorderCallback? onReorder;

  /// Whether the list should shrink to its contents.
  final bool shrinkWrap;

  /// Whether to enable swapping of items.
  final bool enableSwap;

  /// The scroll physics to use.
  final ScrollPhysics physics;

  /// Optional decorator for the dragged item.
  final Widget Function(Widget child, int index, Animation<double> animation)? proxyDecorator;

  /// The delay before starting drag.
  final Duration dragStartDelay;

  /// The duration for insert animations.
  final Duration insertDuration;

  /// The duration for remove animations.
  final Duration removeDuration;

  /// Function to determine if two items are the same.
  final bool Function(T a, T b)? isSameItem;

  /// Whether the list can be reordered.
  final bool canReorder;

  @override
  Widget build(BuildContext context) => TAnimatedSize(
    alignment: Alignment.topCenter,
    child: AnimatedReorderableListView<T>(
      shrinkWrap: shrinkWrap,
      enableSwap: enableSwap,
      physics: physics,
      clipBehavior: Clip.none,
      longPressDraggable: true,
      buildDefaultDragHandles: false,
      primary: false,
      items: items,
      itemBuilder: itemBuilder,
      proxyDecorator:
          proxyDecorator ??
          (child, index, animation) =>
              Transform.scale(scale: 1 - (animation.value * 0.05), child: child),
      dragStartDelay: dragStartDelay,
      enterTransition: [
        if (canReorder)
          SlideInLeft(curve: Curves.decelerate)
        else
          SlideInRight(curve: Curves.decelerate),
      ],
      exitTransition: [
        if (canReorder)
          SlideInRight(curve: Curves.decelerate)
        else
          SlideInLeft(curve: Curves.decelerate),
      ],
      insertDuration: insertDuration,
      removeDuration: removeDuration,
      nonDraggableItems: canReorder ? [] : items,
      onReorder: onReorder ?? (_, __) {},
      isSameItem: isSameItem ?? (a, b) => a == b,
    ),
  );
}
