import 'package:flutter/widgets.dart';
import 'package:veto/veto.dart';

class BusyListenableBuilder extends StatelessWidget {
  const BusyListenableBuilder({super.key, required this.builder, this.child});

  final Widget? child;
  final Widget Function(BuildContext context, BusyModel busyModel, Widget? child) builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    child: child,
    valueListenable: BusyService.instance().isBusyListenable,
    builder: (context, busyModel, child) => builder(context, busyModel, child),
  );
}
