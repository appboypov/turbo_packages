import 'package:flutter/widgets.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

class BusyListenableBuilder extends StatelessWidget {
  const BusyListenableBuilder({super.key, required this.builder, this.child});

  final Widget? child;
  final Widget Function(BuildContext context, TBusyModel busyModel, Widget? child) builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    child: child,
    valueListenable: TBusyService.instance().isBusyListenable,
    builder: (context, busyModel, child) => builder(context, busyModel, child),
  );
}
