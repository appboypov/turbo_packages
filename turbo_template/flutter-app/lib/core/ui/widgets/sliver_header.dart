import 'package:flutter/material.dart';

class SliverHeader extends SliverPersistentHeaderDelegate {
  double minHeight;
  final double maxHeight;
  final Widget child;

  SliverHeader({
    this.minHeight = 0,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(SliverHeader oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}
