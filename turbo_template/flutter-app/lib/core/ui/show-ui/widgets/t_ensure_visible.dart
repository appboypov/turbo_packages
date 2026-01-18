import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbolytics/turbolytics.dart';

/// Scrolls to child widget upon focus.
class TEnsureVisible extends StatefulWidget {
  const TEnsureVisible({
    Key? key,
    required this.child,
    required this.focusNode,
    this.context,
    this.disposeNode = true,
  }) : super(key: key);

  final Widget child;
  final FocusNode focusNode;
  final bool disposeNode;
  final BuildContext? context;

  static void ensure(
    BuildContext context, {
    bool Function()? shouldScroll,
    double alignment = 0.5,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (shouldScroll?.call() ?? true) {
        final shouldScrollAgain = await _ensureVisible(context, alignment: alignment);
        if (shouldScrollAgain) {
          await Future.delayed(TDurations.animation);
          await _ensureVisible(context, alignment: alignment);
        }
      }
    });
  }

  static Future<bool> _ensureVisible(BuildContext context, {required double alignment}) async {
    try {
      final position = Scrollable.of(context).position;
      final oldMaxExtent = position.maxScrollExtent;
      await position.ensureVisible(
        context.findRenderObject()!,
        alignment: alignment,
        duration: TDurations.sheetAnimationX0p5,
        curve: Curves.easeOut,
        targetRenderObject: context.findRenderObject(),
      );
      final newMaxExtent = position.maxScrollExtent;
      final scrollAgain = newMaxExtent != oldMaxExtent;
      return scrollAgain;
    } catch (error, stackTrace) {
      Log(location: 'TEnsureVisible').error(
        'Unexpected ${error.runtimeType} caught while trying to ensure visible',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  State<TEnsureVisible> createState() => _TEnsureVisibleState();
}

class _TEnsureVisibleState extends State<TEnsureVisible> {
  @override
  void initState() {
    widget.focusNode.addListener(_ensureVisible);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.disposeNode) {
      widget.focusNode.removeListener(_ensureVisible);
    }
    super.dispose();
  }

  Future<void> _ensureVisible() async {
    TEnsureVisible.ensure(widget.context ?? context, shouldScroll: _shouldScroll);
  }

  bool _shouldScroll() => mounted && widget.focusNode.hasFocus;

  @override
  Widget build(BuildContext context) => widget.child;
}

// --------------- NULLABLE --------------- NULLABLE --------------- NULLABLE --------------- \\

/// Scrolls to child widget upon focus.
class TEnsureVisibleNullable extends StatefulWidget {
  const TEnsureVisibleNullable({
    Key? key,
    required this.child,
    required this.focusNode,
    this.disposeNode = true,
  }) : super(key: key);

  final Widget child;
  final FocusNode? focusNode;
  final bool disposeNode;

  @override
  State<TEnsureVisibleNullable> createState() => _TEnsureVisibleNullableState();
}

class _TEnsureVisibleNullableState extends State<TEnsureVisibleNullable> {
  @override
  void initState() {
    widget.focusNode?.addListener(_ensureVisible);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.disposeNode) {
      widget.focusNode?.removeListener(_ensureVisible);
      widget.focusNode?.dispose();
    }
    super.dispose();
  }

  Future<void> _ensureVisible() async {
    if (mounted && (widget.focusNode?.hasFocus ?? false)) {
      Future.delayed(TDurations.animation, () => Scrollable.ensureVisible(context));
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
