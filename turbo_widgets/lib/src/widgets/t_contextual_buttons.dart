import 'dart:async';
import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/abstracts/t_contextual_buttons_service_interface.dart';
import 'package:turbo_widgets/src/enums/t_contextual_allow_filter.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/enums/t_contextual_variation.dart';
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
///     top: TContextualButtonsSlotConfig(
///       primary: [AppBar(...)],
///     ),
///     bottom: TContextualButtonsSlotConfig(
///       primary: [BottomNavBar(...)],
///     ),
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
      builder: (context, config, child) {
        return _TContextualButtonsAnimated(
          child: child!,
          config: config,
        );
      },
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

class _TContextualButtonsAnimatedState
    extends State<_TContextualButtonsAnimated> with TickerProviderStateMixin {
  late final Map<TContextualPosition, AnimationController> _controllers;
  final Map<TContextualPosition, _AnimationPhase> _phases = {};
  Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>
      _displayedContent = {};
  final Queue<Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>>
      _pendingQueue = Queue();
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

    _displayedContent = _ContentResolver.resolve(widget.config);
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

    final newContent = _ContentResolver.resolve(widget.config);
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

  void _enqueueAnimation(
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> newContent,
  ) {
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

  bool _variationMapsEqual(
    Map<TContextualVariation, List<Widget>> a,
    Map<TContextualVariation, List<Widget>> b,
  ) {
    for (final variation in TContextualVariation.values) {
      if (!_listEquals(a[variation] ?? const [], b[variation] ?? const [])) {
        return false;
      }
    }
    return true;
  }

  bool _hasAnyVariationContent(
    Map<TContextualVariation, List<Widget>> contentByVariation,
  ) {
    for (final variation in TContextualVariation.values) {
      final content = contentByVariation[variation] ?? const [];
      if (content.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  bool _contentMapsEqual(
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> a,
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> b,
  ) {
    for (final position in TContextualPosition.values) {
      if (!_variationMapsEqual(
        a[position] ?? const {},
        b[position] ?? const {},
      )) {
        return false;
      }
    }
    return true;
  }

  bool _listEquals(List<Widget> a, List<Widget> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!identical(a[i], b[i])) return false;
    }
    return true;
  }

  Future<void> _animateContentChanges(
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> newContent,
  ) async {
    if (_isDisposed) return;

    final positionsToAnimateOut = <TContextualPosition>[];
    final positionsToAnimateIn = <TContextualPosition>[];

    for (final position in TContextualPosition.values) {
      final oldContentByVariation = _displayedContent[position] ?? const {};
      final newContentByVariation = newContent[position] ?? const {};

      if (!_variationMapsEqual(oldContentByVariation, newContentByVariation)) {
        final oldHasContent = _hasAnyVariationContent(oldContentByVariation);
        final newHasContent = _hasAnyVariationContent(newContentByVariation);

        if (oldHasContent) {
          positionsToAnimateOut.add(position);
        }
        if (newHasContent) {
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
        _displayedContent[position] = const {};
        _phases[position] = _AnimationPhase.idle;
      }
    }

    // Phase 2: Update displayed content and animate in positions gaining content
    if (positionsToAnimateIn.isNotEmpty) {
      for (final position in positionsToAnimateIn) {
        _displayedContent[position] =
            Map.from(newContent[position] ?? const {});
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
      if (!positionsToAnimateOut.contains(position) &&
          !positionsToAnimateIn.contains(position)) {
        _displayedContent[position] =
            Map.from(newContent[position] ?? const {});
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
              contentByVariation:
                  _displayedContent[TContextualPosition.top] ?? const {},
              position: TContextualPosition.top,
              alignment: config.top.alignment,
              mainAxisSize: config.top.mainAxisSize,
              builder: config.top.builder,
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
              contentByVariation:
                  _displayedContent[TContextualPosition.bottom] ?? const {},
              position: TContextualPosition.bottom,
              alignment: config.bottom.alignment,
              mainAxisSize: config.bottom.mainAxisSize,
              builder: config.bottom.builder,
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
              contentByVariation:
                  _displayedContent[TContextualPosition.left] ?? const {},
              position: TContextualPosition.left,
              alignment: config.left.alignment,
              mainAxisSize: config.left.mainAxisSize,
              builder: config.left.builder,
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
              contentByVariation:
                  _displayedContent[TContextualPosition.right] ?? const {},
              position: TContextualPosition.right,
              alignment: config.right.alignment,
              mainAxisSize: config.right.mainAxisSize,
              builder: config.right.builder,
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

  static Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>
      resolve(TContextualButtonsConfig config) {
    var result = _buildInitialStructure(config);
    result = _applyActiveVariations(result, config);
    result = _applyPositionOverrides(result, config);
    result = _applyAllowFilter(result, config);
    result = _applyHiddenPositions(result, config);
    return result;
  }

  static Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>
      _buildInitialStructure(TContextualButtonsConfig config) {
    return {
      TContextualPosition.top: {
        TContextualVariation.primary: config.top.primary,
        TContextualVariation.secondary: config.top.secondary,
        TContextualVariation.tertiary: config.top.tertiary,
      },
      TContextualPosition.bottom: {
        TContextualVariation.primary: config.bottom.primary,
        TContextualVariation.secondary: config.bottom.secondary,
        TContextualVariation.tertiary: config.bottom.tertiary,
      },
      TContextualPosition.left: {
        TContextualVariation.primary: config.left.primary,
        TContextualVariation.secondary: config.left.secondary,
        TContextualVariation.tertiary: config.left.tertiary,
      },
      TContextualPosition.right: {
        TContextualVariation.primary: config.right.primary,
        TContextualVariation.secondary: config.right.secondary,
        TContextualVariation.tertiary: config.right.tertiary,
      },
    };
  }

  static Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>
      _applyActiveVariations(
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> input,
    TContextualButtonsConfig config,
  ) {
    final result =
        <TContextualPosition, Map<TContextualVariation, List<Widget>>>{};

    for (final position in TContextualPosition.values) {
      final contentByVariation =
          <TContextualVariation, List<Widget>>{...input[position]!};

      for (final variation in TContextualVariation.values) {
        if (!config.activeVariations.contains(variation)) {
          contentByVariation[variation] = const [];
        }
      }

      result[position] = contentByVariation;
    }

    return result;
  }

  static Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>
      _applyPositionOverrides(
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> input,
    TContextualButtonsConfig config,
  ) {
    final result =
        <TContextualPosition, Map<TContextualVariation, List<Widget>>>{};

    for (final position in TContextualPosition.values) {
      result[position] = Map.from(input[position]!);
    }

    for (final entry in config.positionOverrides.entries) {
      final source = entry.key;
      final target = entry.value;

      for (final variation in TContextualVariation.values) {
        final sourceContent = result[source]![variation] ?? const [];
        if (sourceContent.isNotEmpty) {
          result[target]![variation] = [
            ...(result[target]![variation] ?? const []),
            ...sourceContent,
          ];
          result[source]![variation] = const [];
        }
      }
    }

    return result;
  }

  static Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>
      _applyAllowFilter(
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> input,
    TContextualButtonsConfig config,
  ) {
    if (config.allowFilter == TContextualAllowFilter.all) {
      return input;
    }

    final targetPosition = TContextualPosition.values.firstWhere(
      (p) => p.name == config.allowFilter.name,
    );

    final result =
        <TContextualPosition, Map<TContextualVariation, List<Widget>>>{};

    for (final position in TContextualPosition.values) {
      result[position] = <TContextualVariation, List<Widget>>{};
    }

    for (final variation in TContextualVariation.values) {
      final allContent = <Widget>[
        ...input[TContextualPosition.top]![variation] ?? const [],
        ...input[TContextualPosition.bottom]![variation] ?? const [],
        ...input[TContextualPosition.left]![variation] ?? const [],
        ...input[TContextualPosition.right]![variation] ?? const [],
      ];

      for (final position in TContextualPosition.values) {
        result[position]![variation] = const [];
      }

      result[targetPosition]![variation] = allContent;
    }

    return result;
  }

  static Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>
      _applyHiddenPositions(
    Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> input,
    TContextualButtonsConfig config,
  ) {
    final result =
        <TContextualPosition, Map<TContextualVariation, List<Widget>>>{};

    for (final position in TContextualPosition.values) {
      if (config.hiddenPositions.contains(position)) {
        result[position] = const {};
      } else {
        result[position] = input[position]!;
      }
    }

    return result;
  }
}

/// Stateless widget that renders content for a position with animation.
class _TPositionContent extends StatelessWidget {
  const _TPositionContent({
    required this.contentByVariation,
    required this.position,
    required this.alignment,
    required this.mainAxisSize,
    required this.phase,
    required this.controller,
    required this.curve,
    this.builder,
  });

  final Map<TContextualVariation, List<Widget>> contentByVariation;
  final TContextualPosition position;
  final Alignment alignment;
  final MainAxisSize mainAxisSize;
  final _AnimationPhase phase;
  final AnimationController controller;
  final Curve curve;
  final Widget Function(List<Widget> children)? builder;

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

  bool get _isTopOrBottom =>
      position == TContextualPosition.top ||
      position == TContextualPosition.bottom;

  Axis get _variationStackAxis =>
      _isTopOrBottom ? Axis.vertical : Axis.horizontal;

  bool get _reverseVariationOrder =>
      position == TContextualPosition.bottom ||
      position == TContextualPosition.right;

  @override
  Widget build(BuildContext context) {
    final variationGroups = <Widget>[];
    for (final variation in TContextualVariation.values) {
      final widgets = contentByVariation[variation] ?? const [];
      if (widgets.isNotEmpty) {
        variationGroups.add(
          _VariationGroup(
            widgets: widgets,
            position: position,
            alignment: alignment,
            mainAxisSize: mainAxisSize,
            builder: builder,
          ),
        );
      }
    }

    if (variationGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    final Widget contentWidget;
    if (variationGroups.length == 1) {
      contentWidget = variationGroups.first;
    } else {
      final orderedGroups = _reverseVariationOrder
          ? variationGroups.reversed.toList()
          : variationGroups;

      contentWidget = SingleChildScrollView(
        scrollDirection: _variationStackAxis,
        child: Flex(
          direction: _variationStackAxis,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: _TPositionContent.alignmentToMainAxisAlignment(
            alignment,
            _isTopOrBottom,
          ),
          crossAxisAlignment: _TPositionContent.alignmentToCrossAxisAlignment(
            alignment,
            _isTopOrBottom,
          ),
          children: orderedGroups,
        ),
      );
    }

    return AnimatedBuilder(
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
      child: Semantics(
        container: true,
        liveRegion: true,
        label: _getPositionLabel(),
        child: contentWidget,
      ),
    );
  }

  String _getPositionLabel() {
    final variationLabels = <String>[];
    for (final variation in TContextualVariation.values) {
      final widgets = contentByVariation[variation] ?? const [];
      if (widgets.isNotEmpty) {
        variationLabels.add(variation.name);
      }
    }

    if (variationLabels.isEmpty) {
      return '${position.name} contextual content';
    }

    return '${position.name} contextual content: ${variationLabels.join(", ")}';
  }

  static MainAxisAlignment alignmentToMainAxisAlignment(
    Alignment alignment,
    bool isTopOrBottom,
  ) {
    final value = isTopOrBottom ? alignment.x : alignment.y;
    if (value < 0) return MainAxisAlignment.start;
    if (value > 0) return MainAxisAlignment.end;
    return MainAxisAlignment.center;
  }

  static CrossAxisAlignment alignmentToCrossAxisAlignment(
    Alignment alignment,
    bool isTopOrBottom,
  ) {
    final value = isTopOrBottom ? alignment.y : alignment.x;
    if (value < 0) return CrossAxisAlignment.start;
    if (value > 0) return CrossAxisAlignment.end;
    return CrossAxisAlignment.center;
  }
}

/// Stateless widget that renders a single variation group of widgets.
class _VariationGroup extends StatelessWidget {
  const _VariationGroup({
    required this.widgets,
    required this.position,
    required this.alignment,
    required this.mainAxisSize,
    this.builder,
  });

  final List<Widget> widgets;
  final TContextualPosition position;
  final Alignment alignment;
  final MainAxisSize mainAxisSize;
  final Widget Function(List<Widget> children)? builder;

  bool get _isTopOrBottom =>
      position == TContextualPosition.top ||
      position == TContextualPosition.bottom;

  Axis get _variationContentAxis =>
      _isTopOrBottom ? Axis.horizontal : Axis.vertical;

  @override
  Widget build(BuildContext context) {
    if (widgets.isEmpty) {
      return const SizedBox.shrink();
    }

    if (builder != null) {
      return builder!(widgets);
    } else if (widgets.length == 1) {
      return Align(
        alignment: alignment,
        child: widgets.first,
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: _variationContentAxis,
        child: Flex(
          direction: _variationContentAxis,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: _TPositionContent.alignmentToMainAxisAlignment(
            alignment,
            _isTopOrBottom,
          ),
          crossAxisAlignment: _TPositionContent.alignmentToCrossAxisAlignment(
            alignment,
            _isTopOrBottom,
          ),
          children: widgets,
        ),
      );
    }
  }
}
