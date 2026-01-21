import 'package:flutter/widgets.dart';

class BottomPositioned extends StatelessWidget {
  const BottomPositioned({
    Key? key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.bottom = 0,
  }) : super(key: key);

  final Widget child;
  final double left;
  final double right;
  final double bottom;

  @override
  Widget build(BuildContext context) =>
      Positioned(bottom: bottom, left: left, right: right, child: child);
}
