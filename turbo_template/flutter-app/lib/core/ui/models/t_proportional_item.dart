import 'package:flutter/widgets.dart';

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
