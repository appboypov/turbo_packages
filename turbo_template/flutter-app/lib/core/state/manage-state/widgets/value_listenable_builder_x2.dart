import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ValueListenableBuilderX2<T1, T2> extends StatefulWidget {
  const ValueListenableBuilderX2({
    required this.valueListenable,
    required this.valueListenable2,
    required this.builder,
    this.child,
    super.key,
  });

  final Widget? child;
  final ValueListenable<T1> valueListenable;
  final ValueListenable<T2> valueListenable2;
  final Widget Function(BuildContext context, T1 value, T2 value2, Widget? child) builder;

  @override
  ValueListenableBuilderX2State<T1, T2> createState() => ValueListenableBuilderX2State<T1, T2>();
}

class ValueListenableBuilderX2State<T1, T2> extends State<ValueListenableBuilderX2<T1, T2>> {
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

  List<Listenable> get _listenables => [widget.valueListenable, widget.valueListenable2];

  void rebuild() => setState(() {});

  @override
  void didUpdateWidget(ValueListenableBuilderX2<T1, T2> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(rebuild);
      widget.valueListenable.addListener(rebuild);
    }

    if (oldWidget.valueListenable2 != widget.valueListenable2) {
      oldWidget.valueListenable2.removeListener(rebuild);
      widget.valueListenable2.addListener(rebuild);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    widget.valueListenable.value,
    widget.valueListenable2.value,
    widget.child,
  );
}

