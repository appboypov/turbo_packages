import 'package:flutter/widgets.dart';

class Unfocusable extends StatelessWidget {
  const Unfocusable({
    Key? key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onTapDown,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final ValueChanged<TapDownDetails>? onTapDown;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: onTapDown,
    onDoubleTap: onDoubleTap,
    onTap: () {
      onTap?.call();
      FocusScope.of(context).unfocus();
    },
    child: child,
  );
}
