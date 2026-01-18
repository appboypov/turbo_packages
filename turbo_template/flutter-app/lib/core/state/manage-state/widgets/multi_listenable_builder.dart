import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Used to control rebuilds based ´on any list of [Listenable]'s.
class MultiListenableBuilder extends StatefulWidget {
  const MultiListenableBuilder({
    required List<Listenable> listenables,
    required Widget Function(BuildContext context, List<Listenable> listenables, Widget? child)
    builder,
    Widget? child,
    Key? key,
  }) : _child = child,
       _listenables = listenables,
       _builder = builder,
       super(key: key);

  final Widget? _child;
  final List<Listenable> _listenables;
  final Widget Function(BuildContext context, List<Listenable> listenables, Widget? child) _builder;

  @override
  MultiListenableBuilderState createState() => MultiListenableBuilderState();
}

class MultiListenableBuilderState extends State<MultiListenableBuilder> {
  late List<Listenable> _listenables;

  void _rebuild() => setState(() {});

  @override
  void initState() {
    _initListeners();
    super.initState();
  }

  @override
  void didUpdateWidget(MultiListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(_listenables, widget._listenables)) {
      for (final oldListenable in _listenables) {
        oldListenable.removeListener(_rebuild);
      }
      _initListeners();
    }
  }

  void _initListeners() {
    _listenables = List.from(widget._listenables, growable: false);
    for (final listenables in _listenables) {
      listenables.addListener(_rebuild);
    }
  }

  @override
  Widget build(BuildContext context) => widget._builder(context, _listenables, widget._child);

  @override
  void dispose() {
    for (final listener in _listenables) {
      listener.removeListener(_rebuild);
    }
    super.dispose();
  }
}
