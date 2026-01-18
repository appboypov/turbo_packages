import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ValueListenableBuilderX4<T1, T2, T3, T4> extends StatefulWidget {
  const ValueListenableBuilderX4({
    required this.valueListenable,
    required this.valueListenable2,
    required this.valueListenable3,
    required this.valueListenable4,
    required this.builder,
    this.child,
    super.key,
  });

  final Widget? child;
  final ValueListenable<T1> valueListenable;
  final ValueListenable<T2> valueListenable2;
  final ValueListenable<T3> valueListenable3;
  final ValueListenable<T4> valueListenable4;
  final Widget Function(
    BuildContext context,
    T1 value,
    T2 value2,
    T3 value3,
    T4 value4,
    Widget? child,
  )
  builder;

  @override
  ValueListenableBuilderX4State<T1, T2, T3, T4> createState() =>
      ValueListenableBuilderX4State<T1, T2, T3, T4>();
}

class ValueListenableBuilderX4State<T1, T2, T3, T4>
    extends State<ValueListenableBuilderX4<T1, T2, T3, T4>> {
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  void initState() {
    initListeners();
    super.initState();
  }

  void initListeners() {
    for (final listenable in _listenables) {
      listenable.addListener(rebuild);
    }
  }

  @override
  void dispose() {
    for (final listener in _listenables) {
      listener.removeListener(rebuild);
    }
    super.dispose();
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  List<Listenable> get _listenables => [
    widget.valueListenable,
    widget.valueListenable2,
    widget.valueListenable3,
    widget.valueListenable4,
  ];

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  void rebuild() => setState(() {});

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  @override
  void didUpdateWidget(ValueListenableBuilderX4<T1, T2, T3, T4> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(rebuild);
      widget.valueListenable.addListener(rebuild);
    }

    if (oldWidget.valueListenable2 != widget.valueListenable2) {
      oldWidget.valueListenable2.removeListener(rebuild);
      widget.valueListenable2.addListener(rebuild);
    }

    if (oldWidget.valueListenable3 != widget.valueListenable3) {
      oldWidget.valueListenable3.removeListener(rebuild);
      widget.valueListenable3.addListener(rebuild);
    }

    if (oldWidget.valueListenable4 != widget.valueListenable4) {
      oldWidget.valueListenable4.removeListener(rebuild);
      widget.valueListenable4.addListener(rebuild);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    widget.valueListenable.value,
    widget.valueListenable2.value,
    widget.valueListenable3.value,
    widget.valueListenable4.value,
    widget.child,
  );
}
