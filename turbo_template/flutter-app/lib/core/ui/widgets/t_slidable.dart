import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TSlidable extends StatelessWidget {
  const TSlidable({
    Key? key,
    required this.child,
    required this.children,
    required this.slidableController,
    required this.valueKey,
    this.extendRatio = 0.5,
  }) : super(key: key);

  final ValueKey<String> valueKey;
  final SlidableController slidableController;
  final Widget child;
  final List<Widget> children;
  final double extendRatio;

  @override
  Widget build(BuildContext context) => Slidable(
    key: valueKey,
    enabled: true,
    controller: slidableController,
    closeOnScroll: true,
    endActionPane: ActionPane(
      motion: const DrawerMotion(),
      extentRatio: extendRatio,
      children: children,
    ),
    child: child,
  );
}
