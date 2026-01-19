import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Rebuilds when any of the provided [Listenable]s notify.
class MultiListenableBuilder extends StatefulWidget {
  const MultiListenableBuilder({
    required this.listenables,
    required this.builder,
    this.child,
    super.key,
  });

  final List<Listenable> listenables;
  final Widget Function(
    BuildContext context,
    List<Listenable> listenables,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  State<MultiListenableBuilder> createState() => _MultiListenableBuilderState();
}

class _MultiListenableBuilderState extends State<MultiListenableBuilder> {
  late List<Listenable> _listenables;

  void _rebuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    _initListeners();
  }

  @override
  void didUpdateWidget(MultiListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(_listenables, widget.listenables)) {
      for (final oldListenable in _listenables) {
        oldListenable.removeListener(_rebuild);
      }
      _initListeners();
    }
  }

  void _initListeners() {
    _listenables = List.from(widget.listenables, growable: false);
    for (final listenable in _listenables) {
      listenable.addListener(_rebuild);
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _listenables, widget.child);

  @override
  void dispose() {
    for (final listenable in _listenables) {
      listenable.removeListener(_rebuild);
    }
    super.dispose();
  }
}
