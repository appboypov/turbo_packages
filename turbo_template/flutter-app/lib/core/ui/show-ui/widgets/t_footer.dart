import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/widgets/bottom_positioned.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/bottom_positioned.dart';

class TFooter extends StatelessWidget {
  const TFooter._({
    Key? key,
    required this.child,
    required this.bottom,
    required this.left,
    required this.right,
  }) : super(key: key);

  const TFooter.fullScreen({
    Key? key,
    required Widget child,
    double bottom = 24,
    double left = 16,
    double right = 16,
  }) : this._(
         key: key,
         child: child,
         bottom: bottom,
         left: left,
         right: right,
       );

  const TFooter.shell({
    Key? key,
    required Widget child,
    double bottom = 0,
    double left = 16,
    double right = 16,
  }) : this._(
         key: key,
         child: child,
         bottom: bottom,
         left: left,
         right: right,
       );

  final Widget child;

  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) =>
      BottomPositioned(child: child, bottom: bottom, left: left, right: right);
}
