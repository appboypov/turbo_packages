import 'dart:async';
import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/abstracts/t_contextual_buttons_service_interface.dart';
import 'package:turbo_widgets/src/enums/t_contextual_allow_filter.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/models/t_contextual_buttons_config.dart';
import 'package:turbo_widgets/src/services/t_contextual_buttons_service.dart';

/// A widget that displays contextual buttons at configurable positions
/// (top, bottom, left, right) as overlays on top of the main content.
///
/// Content at each position animates with a sequential out-then-in transition:
/// old content animates out completely before new content animates in.
///
/// Configuration is managed through [TContextualButtonsService]. By default,
/// uses the singleton [TContextualButtonsService.instance]. Pass a custom
/// service to use a different instance.
///
/// Example:
/// ```dart
/// TContextualButtons(
///   child: mainContent,
/// )
///
/// // Configure buttons via service
/// TContextualButtonsService.instance.update(
///   TContextualButtonsConfig(
///     top: (context) => [AppBar(...)],
///     bottom: (context) => [BottomNavBar(...)],
///   ),
/// );
/// ```
class TContextualButtons extends StatelessWidget {
  const TContextualButtons({
    required this.child,
    super.key,
    this.service,
  });

  /// The main content that fills the wrapper.
  final Widget child;

  /// Optional service instance. If not provided, uses the singleton
  /// [TContextualButtonsService.instance].
  final TContextualButtonsServiceInterface? service;

  @override
  Widget build(BuildContext context) {
    final effectiveService = service ?? TContextualButtonsService.instance;

    return ValueListenableBuilder<TContextualButtonsConfig>(
      valueListenable: effectiveService,
      child: child,
      builder: (context, config, child) => _TContextualButtonsAnimated(
        child: child!,
        config: config,
      ),
    );
  }
}

enum _AnimationPhase { idle, animatingOut, animatingIn }

class _TContextualButtonsAnimated extends StatefulWidget {
  const _TContextualButtonsAnimated({
    required this.child,
    required this.config,
  });

  final Widget child;
  final TContextualButtonsConfig config;

  @override
  State<_TContextualButtonsAnimated> createState() =>
      _TContextualButtonsAnimatedState();
}

class _TContextualButtonsAnimatedState extends State<_TContextualButtonsAnimated>
    with TickerProviderStateMixin {
  late final Map<TContextualPosition, AnimationController> _controllers;
  final Map<TContextualPosition, _AnimationPhase> _phases = {};
  Map<TContextualPosition, List<Widget>> _displayedContent = {};
  final Queue<Map<TContextualPosition, List<Widget>>> _pendingQueue = Queue();
  bool _isAnimating = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    final halfDuration = Duration(
      milliseconds: widget.config.animationDuration.inMilliseconds ~/ 2,
    );

    _controllers = {
      for (final position in TContextualPosition.values)
        position: AnimationController(duration: halfDuration, vsync: this),
    };

    for (final position in TContextualPosition.values) {
      _phases[position] = _AnimationPhase.idle;
    }

    _displayedContent = _ContentResolver.resolve(widget.config, context);
  }

  @override
  void didUpdateWidget(_TContextualButtonsAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.config.animationDuration != widget.config.animationDuration) {
      final halfDuration = Duration(
        milliseconds: widget.config.animationDuration.inMilliseconds ~/ 2,
      );
      for (final controller in _controllers.values) {
        controller.duration = halfDuration;
      }
    }

    final newContent = _ContentResolver.resolve(widget.config, context);
    if (!_contentMapsEqual(_displayedContent, newContent)) {
      _enqueueAnimation(newContent);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _enqueueAnimation(Map<TContextualPosition, List<Widget>> newContent) {
    _pendingQueue.add(newContent);
    if (!_isAnimating) {
      _processNextAnimation();
    }
  }

  Future<void> _processNextAnimation() async {
    if (_pendingQueue.isEmpty || _isDisposed) {
      _isAnimating = false;
      return;
    }

    _isAnimating = true;
    final newContent = _pendingQueue.removeFirst();

    await _animateContentChanges(newContent);

    if (!_isDisposed && mounted) {
      unawaited(_processNextAnimation());
    }
  }

  bool _contentMapsEqual(
    Map<TContextualPosition, List<Widget>> a,
    Map<TContextualPosition, List<Widget>> b,
  ) {
    for (final position in TContextualPosition.values) {
      if (!_listEquals(a[position] ?? const [], b[position] ?? const [])) {
        return false;
      }
    }
    return true;
  }

  Object _widgetIdentityKey(Widget widget) => widget.key ?? widget;

  bool _listEquals(List<Widget> a, List<Widget> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (_widgetIdentityKey(a[i]) != _widgetIdentityKey(b[i])) return false;
    }
    return true;
  }

  Future<void> _animateContentChanges(
    Map<TContextualPosition, List<Widget>> newContent,
  ) async {
    if (_isDisposed) return;

    final positionsToAnimateOut = <TContextualPosition>[];
    final positionsToAnimateIn = <TContextualPosition>[];

    for (final position in TContextualPosition.values) {
      final oldWidgets = _displayedContent[position] ?? const [];
      final newWidgets = newContent[position] ?? const [];
      if (!_listEquals(oldWidgets, newWidgets)) {
        if (oldWidgets.isNotEmpty) {
          positionsToAnimateOut.add(position);
        }
        if (newWidgets.isNotEmpty) {
          positionsToAnimateIn.add(position);
        }
      }
    }

    // Phase 1: Animate out all positions losing content (in parallel)
    if (positionsToAnimateOut.isNotEmpty) {
      for (final position in positionsToAnimateOut) {
        _phases[position] = _AnimationPhase.animatingOut;
        _controllers[position]!.reset();
      }

      final outFutures = <Future<void>>[];
      for (final position in positionsToAnimateOut) {
        outFutures.add(
          _controllers[position]!.forward().orCancel.catchError((_) {}),
        );
      }

      if (mounted && !_isDisposed) setState(() {});

      await Future.wait(outFutures);

      if (!mounted || _isDisposed) return;

      // Clear content from positions that animated out
      for (final position in positionsToAnimateOut) {
        _displayedContent[position] = const [];
        _phases[position] = _AnimationPhase.idle;
      }
    }

    // Phase 2: Update displayed content and animate in positions gaining content
    if (positionsToAnimateIn.isNotEmpty) {
      for (final position in positionsToAnimateIn) {
        _displayedContent[position] = newContent[position] ?? const [];
        _phases[position] = _AnimationPhase.animatingIn;
        _controllers[position]!.reset();
      }

      final inFutures = <Future<void>>[];
      for (final position in positionsToAnimateIn) {
        inFutures.add(
          _controllers[position]!.forward().orCancel.catchError((_) {}),
        );
      }

      if (mounted && !_isDisposed) setState(() {});

      await Future.wait(inFutures);

      if (!mounted || _isDisposed) return;
    }

    // Update remaining positions that changed without animation
    for (final position in TContextualPosition.values) {
      final oldWidgets = _displayedContent[position] ?? const [];
      final newWidgets = newContent[position] ?? const [];
      final didAnimateOut = positionsToAnimateOut.contains(position);
      final didAnimateIn = positionsToAnimateIn.contains(position);
      if (!didAnimateOut && !didAnimateIn && !_listEquals(oldWidgets, newWidgets)) {
        _displayedContent[position] = newWidgets;
      }
    }

    // Reset all phases to idle
    for (final position in TContextualPosition.values) {
      _phases[position] = _AnimationPhase.idle;
    }

    if (mounted && !_isDisposed) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              widgets: _displayedContent[TContextualPosition.top] ?? const [],
              position: TContextualPosition.top,
              phase: _phases[TContextualPosition.top]!,
              controller: _controllers[TContextualPosition.top]!,
              curve: config.animationCurve,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              widgets: _displayedContent[TContextualPosition.bottom] ?? const [],
              position: TContextualPosition.bottom,
              phase: _phases[TContextualPosition.bottom]!,
              controller: _controllers[TContextualPosition.bottom]!,
              curve: config.animationCurve,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              widgets: _displayedContent[TContextualPosition.left] ?? const [],
              position: TContextualPosition.left,
              phase: _phases[TContextualPosition.left]!,
              controller: _controllers[TContextualPosition.left]!,
              curve: config.animationCurve,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              widgets: _displayedContent[TContextualPosition.right] ?? const [],
              position: TContextualPosition.right,
              phase: _phases[TContextualPosition.right]!,
              controller: _controllers[TContextualPosition.right]!,
              curve: config.animationCurve,
            ),
          ),
        ),
      ],
    );
  }
}

/// Separates content resolution logic from animation orchestration.
class _ContentResolver {
  const _ContentResolver._();

  static Map<TContextualPosition, List<Widget>> resolve(
    TContextualButtonsConfig config,
    BuildContext context,
  ) {
    var result = _buildInitialStructure(config, context);
    result = _applyPositionOverrides(result, config);
    result = _applyAllowFilter(result, config);
    result = _applyHiddenPositions(result, config);
    return result;
  }

  static Map<TContextualPosition, List<Widget>> _buildInitialStructure(
    TContextualButtonsConfig config,
    BuildContext context,
  ) {
    return {
      TContextualPosition.top: config.top(context),
      TContextualPosition.bottom: config.bottom(context),
      TContextualPosition.left: config.left(context),
      TContextualPosition.right: config.right(context),
    };
  }

  static Map<TContextualPosition, List<Widget>> _applyPositionOverrides(
    Map<TContextualPosition, List<Widget>> input,
    TContextualButtonsConfig config,
  ) {
    final result = <TContextualPosition, List<Widget>>{
      for (final position in TContextualPosition.values)
        position: List.from(input[position]!),
    };

    for (final entry in config.positionOverrides.entries) {
      final source = entry.key;
      final target = entry.value;

      final sourceContent = result[source] ?? const [];
      if (sourceContent.isNotEmpty) {
        result[target] = [
          ...(result[target] ?? const []),
          ...sourceContent,
        ];
        result[source] = const [];
      }
    }

    return result;
  }

  static Map<TContextualPosition, List<Widget>> _applyAllowFilter(
    Map<TContextualPosition, List<Widget>> input,
    TContextualButtonsConfig config,
  ) {
    if (config.allowFilter == TContextualAllowFilter.all) {
      return input;
    }

    final targetPosition = TContextualPosition.values.firstWhere(
      (p) => p.name == config.allowFilter.name,
    );

    final allContent = <Widget>[
      ...input[TContextualPosition.top] ?? const [],
      ...input[TContextualPosition.bottom] ?? const [],
      ...input[TContextualPosition.left] ?? const [],
      ...input[TContextualPosition.right] ?? const [],
    ];

    return {
      for (final position in TContextualPosition.values)
        position: position == targetPosition ? allContent : const [],
    };
  }

  static Map<TContextualPosition, List<Widget>> _applyHiddenPositions(
    Map<TContextualPosition, List<Widget>> input,
    TContextualButtonsConfig config,
  ) {
    return {
      for (final position in TContextualPosition.values)
        position: config.hiddenPositions.contains(position)
            ? const []
            : input[position]!,
    };
  }
}

/// Stateless widget that renders content for a position with animation.
class _TPositionContent extends StatelessWidget {
  const _TPositionContent({
    required this.widgets,
    required this.position,
    required this.phase,
    required this.controller,
    required this.curve,
  });

  final List<Widget> widgets;
  final TContextualPosition position;
  final _AnimationPhase phase;
  final AnimationController controller;
  final Curve curve;

  bool get _isTopOrBottom =>
      position == TContextualPosition.top || position == TContextualPosition.bottom;

  Axis get _contentAxis => _isTopOrBottom ? Axis.horizontal : Axis.vertical;

  Offset _getSlideOffset() {
    switch (position) {
      case TContextualPosition.top:
        return const Offset(0, -1);
      case TContextualPosition.bottom:
        return const Offset(0, 1);
      case TContextualPosition.left:
        return const Offset(-1, 0);
      case TContextualPosition.right:
        return const Offset(1, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widgets.isEmpty) {
      return const SizedBox.shrink();
    }

    final Widget contentWidget;
    if (widgets.length == 1) {
      contentWidget = widgets.first;
    } else {
      contentWidget = SingleChildScrollView(
        scrollDirection: _contentAxis,
        child: Flex(
          direction: _contentAxis,
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ),
      );
    }

    return Semantics(
      container: true,
      liveRegion: true,
      label: '${position.name} contextual content',
      child: IgnorePointer(
        ignoring: phase != _AnimationPhase.idle,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final curvedValue = curve.transform(controller.value);

            final double opacity;
            final Offset offset;
            final slideOffset = _getSlideOffset();

            switch (phase) {
              case _AnimationPhase.idle:
                opacity = 1.0;
                offset = Offset.zero;
              case _AnimationPhase.animatingOut:
                opacity = 1.0 - curvedValue;
                offset = Offset(
                  slideOffset.dx * curvedValue,
                  slideOffset.dy * curvedValue,
                );
              case _AnimationPhase.animatingIn:
                opacity = curvedValue;
                offset = Offset(
                  slideOffset.dx * (1.0 - curvedValue),
                  slideOffset.dy * (1.0 - curvedValue),
                );
            }

            return Opacity(
              opacity: opacity,
              child: FractionalTranslation(
                translation: offset,
                child: child,
              ),
            );
          },
          child: contentWidget,
        ),
      ),
    );
  }
}
