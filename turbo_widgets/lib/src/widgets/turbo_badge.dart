import 'package:flutter/material.dart';

/// A badge widget that displays a small indicator on top of a child widget.
class TurboBadge extends StatelessWidget {
  const TurboBadge({
    super.key,
    required this.child,
    this.color,
    this.size = 8.0,
    this.position = const Offset(8, 8),
  });

  final Widget child;
  final Color? color;
  final double size;
  final Offset position;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      child,
      Positioned(
        top: position.dy,
        right: position.dx,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.error,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  );
}
