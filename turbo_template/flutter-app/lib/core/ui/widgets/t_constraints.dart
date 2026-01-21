import 'package:flutter/widgets.dart';

class TConstraints extends StatelessWidget {
  const TConstraints({
    Key? key,
    required this.child,
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  }) : super(key: key);

  final Widget child;

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    child: child,
    constraints: BoxConstraints(
      minHeight: minHeight,
      maxHeight: maxHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
    ),
  );
}
