import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/enums/t_contextual_allow_filter.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';
import 'package:turbo_widgets/src/enums/t_contextual_variation.dart';

/// A wrapper widget that displays contextual content at configurable positions
/// (top, bottom, left, right) as overlays on top of the main content.
///
/// Content at each position animates with a sequential out-then-in transition:
/// old content animates out completely before new content animates in.
///
/// Use [allowFilter] to restrict which positions can display content.
/// For example, setting [TContextualAllowFilter.left] will only show left content,
/// useful for forcing side navigation on web.
///
/// Use [positionOverrides] to move content from one position to another.
/// For example, move bottom navigation to left side on web:
/// ```dart
/// positionOverrides: {
///   TContextualPosition.bottom: TContextualPosition.left,
/// }
/// ```
///
/// Example:
/// ```dart
/// TContextualWrapper(
///   child: mainContent,
///   topContent: [AppBar(...)],
///   bottomContent: [BottomNavBar(...)],
///   leftContent: [SideNav(...)],
///   allowFilter: TContextualAllowFilter.all,
///   topAlignment: Alignment.center,
/// )
/// ```
class TContextualWrapper extends StatefulWidget {
  const TContextualWrapper({
    required this.child,
    super.key,
    this.topContent = const [],
    this.bottomContent = const [],
    this.leftContent = const [],
    this.rightContent = const [],
    this.topSecondaryContent = const [],
    this.topTertiaryContent = const [],
    this.bottomSecondaryContent = const [],
    this.bottomTertiaryContent = const [],
    this.leftSecondaryContent = const [],
    this.leftTertiaryContent = const [],
    this.rightSecondaryContent = const [],
    this.rightTertiaryContent = const [],
    this.activeVariations = const {
      TContextualVariation.primary,
      TContextualVariation.secondary,
      TContextualVariation.tertiary,
    },
    this.allowFilter = TContextualAllowFilter.all,
    this.positionOverrides = const {},
    this.topAlignment = Alignment.center,
    this.bottomAlignment = Alignment.center,
    this.leftAlignment = Alignment.center,
    this.rightAlignment = Alignment.center,
    this.topMainAxisSize = MainAxisSize.min,
    this.bottomMainAxisSize = MainAxisSize.min,
    this.leftMainAxisSize = MainAxisSize.min,
    this.rightMainAxisSize = MainAxisSize.min,
    this.topBuilder,
    this.bottomBuilder,
    this.leftBuilder,
    this.rightBuilder,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  /// The main content that fills the wrapper.
  final Widget child;

  /// Content to display at the top (overlays main content).
  final List<Widget> topContent;

  /// Content to display at the bottom (overlays main content).
  final List<Widget> bottomContent;

  /// Content to display on the left (overlays main content).
  final List<Widget> leftContent;

  /// Content to display on the right (overlays main content).
  final List<Widget> rightContent;

  /// Secondary content to display at the top (overlays main content).
  final List<Widget> topSecondaryContent;

  /// Tertiary content to display at the top (overlays main content).
  final List<Widget> topTertiaryContent;

  /// Secondary content to display at the bottom (overlays main content).
  final List<Widget> bottomSecondaryContent;

  /// Tertiary content to display at the bottom (overlays main content).
  final List<Widget> bottomTertiaryContent;

  /// Secondary content to display on the left (overlays main content).
  final List<Widget> leftSecondaryContent;

  /// Tertiary content to display on the left (overlays main content).
  final List<Widget> leftTertiaryContent;

  /// Secondary content to display on the right (overlays main content).
  final List<Widget> rightSecondaryContent;

  /// Tertiary content to display on the right (overlays main content).
  final List<Widget> rightTertiaryContent;

  /// Set of active variations to display.
  ///
  /// Only variations in this set will be rendered. If multiple variations
  /// are active for the same position, they are stacked according to the
  /// position's axis (vertical for top/bottom, horizontal for left/right).
  final Set<TContextualVariation> activeVariations;

  /// Filter to restrict which positions can display content.
  ///
  /// When set to [TContextualAllowFilter.all], all positions are allowed.
  /// When set to a specific position, only that position is allowed.
  final TContextualAllowFilter allowFilter;

  /// Overrides to move content from one position to another.
  ///
  /// Key is the source position, value is the target position.
  /// Content from the source position will be displayed at the target position.
  final Map<TContextualPosition, TContextualPosition> positionOverrides;

  /// Alignment for top content.
  final Alignment topAlignment;

  /// Alignment for bottom content.
  final Alignment bottomAlignment;

  /// Alignment for left content.
  final Alignment leftAlignment;

  /// Alignment for right content.
  final Alignment rightAlignment;

  /// Main axis size for top content.
  final MainAxisSize topMainAxisSize;

  /// Main axis size for bottom content.
  final MainAxisSize bottomMainAxisSize;

  /// Main axis size for left content.
  final MainAxisSize leftMainAxisSize;

  /// Main axis size for right content.
  final MainAxisSize rightMainAxisSize;

  /// Builder to wrap top content with custom widgets (e.g., padding, margin).
  final Widget Function(List<Widget> children)? topBuilder;

  /// Builder to wrap bottom content with custom widgets (e.g., padding, margin).
  final Widget Function(List<Widget> children)? bottomBuilder;

  /// Builder to wrap left content with custom widgets (e.g., padding, margin).
  final Widget Function(List<Widget> children)? leftBuilder;

  /// Builder to wrap right content with custom widgets (e.g., padding, margin).
  final Widget Function(List<Widget> children)? rightBuilder;

  /// Total duration for the animation (split 50/50 between out and in phases).
  final Duration animationDuration;

  /// Curve applied to both out and in animation phases.
  final Curve animationCurve;

  @override
  State<TContextualWrapper> createState() => _TContextualWrapperState();
}

enum _AnimationPhase { idle, animatingOut, animatingIn }

class _TContextualWrapperState extends State<TContextualWrapper> with TickerProviderStateMixin {
  late final Map<TContextualPosition, AnimationController> _controllers;
  final Map<TContextualPosition, _AnimationPhase> _phases = {};
  Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> _displayedContent = {};
  Map<TContextualPosition, Map<TContextualVariation, List<Widget>>>? _pendingContent;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    final halfDuration = Duration(
      milliseconds: widget.animationDuration.inMilliseconds ~/ 2,
    );

    _controllers = {
      for (final position in TContextualPosition.values)
        position: AnimationController(duration: halfDuration, vsync: this),
    };

    for (final position in TContextualPosition.values) {
      _phases[position] = _AnimationPhase.idle;
    }

    _displayedContent = _resolveContent();
  }

  @override
  void didUpdateWidget(TContextualWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationDuration != widget.animationDuration) {
      final halfDuration = Duration(
        milliseconds: widget.animationDuration.inMilliseconds ~/ 2,
      );
      for (final controller in _controllers.values) {
        controller.duration = halfDuration;
      }
    }

    final newContent = _resolveContent();
    if (!_contentMapsEqual(_displayedContent, newContent)) {
      _animateContentChanges(newContent);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
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
    if (_isAnimating) {
      _pendingContent = newContent;
      return;
    }

    _isAnimating = true;

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
      setState(() {});

      final outFutures = <Future<void>>[];
      for (final position in positionsToAnimateOut) {
        outFutures.add(
          _controllers[position]!.forward().orCancel.catchError((_) {}),
        );
      }
      await Future.wait(outFutures);

      if (!mounted) {
        _isAnimating = false;
        return;
      }

      // Clear content from positions that animated out
      for (final position in positionsToAnimateOut) {
        _displayedContent[position] = const {};
        _phases[position] = _AnimationPhase.idle;
      }
      setState(() {});
    }

    // Phase 2: Update displayed content and animate in positions gaining content
    if (positionsToAnimateIn.isNotEmpty) {
      for (final position in positionsToAnimateIn) {
        _displayedContent[position] = Map.from(newContent[position] ?? const {});
        _phases[position] = _AnimationPhase.animatingIn;
        _controllers[position]!.reset();
      }
      setState(() {});

      final inFutures = <Future<void>>[];
      for (final position in positionsToAnimateIn) {
        inFutures.add(
          _controllers[position]!.forward().orCancel.catchError((_) {}),
        );
      }
      await Future.wait(inFutures);

      if (!mounted) {
        _isAnimating = false;
        return;
      }
    }

    // Update remaining positions that changed without animation
    for (final position in TContextualPosition.values) {
      if (!positionsToAnimateOut.contains(position) && !positionsToAnimateIn.contains(position)) {
        _displayedContent[position] = Map.from(newContent[position] ?? const {});
      }
    }

    // Reset all phases to idle
    for (final position in TContextualPosition.values) {
      _phases[position] = _AnimationPhase.idle;
    }

    _isAnimating = false;
    setState(() {});

    // Process pending content if any
    if (_pendingContent != null && mounted) {
      final pending = _pendingContent!;
      _pendingContent = null;
      await _animateContentChanges(pending);
    }
  }

  TContextualPosition _positionFromAllowFilter(TContextualAllowFilter filter) {
    return TContextualPosition.values.firstWhere(
      (p) => p.name == filter.name,
    );
  }

  Map<TContextualPosition, Map<TContextualVariation, List<Widget>>> _resolveContent() {
    // Step 1: Build initial structure for each position with 3 variation buckets
    var result = <TContextualPosition, Map<TContextualVariation, List<Widget>>>{
      TContextualPosition.top: {
        TContextualVariation.primary: [...widget.topContent],
        TContextualVariation.secondary: [...widget.topSecondaryContent],
        TContextualVariation.tertiary: [...widget.topTertiaryContent],
      },
      TContextualPosition.bottom: {
        TContextualVariation.primary: [...widget.bottomContent],
        TContextualVariation.secondary: [...widget.bottomSecondaryContent],
        TContextualVariation.tertiary: [...widget.bottomTertiaryContent],
      },
      TContextualPosition.left: {
        TContextualVariation.primary: [...widget.leftContent],
        TContextualVariation.secondary: [...widget.leftSecondaryContent],
        TContextualVariation.tertiary: [...widget.leftTertiaryContent],
      },
      TContextualPosition.right: {
        TContextualVariation.primary: [...widget.rightContent],
        TContextualVariation.secondary: [...widget.rightSecondaryContent],
        TContextualVariation.tertiary: [...widget.rightTertiaryContent],
      },
    };

    // Step 2: Apply activeVariations by zeroing out inactive variation lists
    for (final position in TContextualPosition.values) {
      final contentByVariation = result[position]!;
      for (final variation in TContextualVariation.values) {
        if (!widget.activeVariations.contains(variation)) {
          contentByVariation[variation] = const [];
        }
      }
    }

    // Step 3: Apply positionOverrides per variation
    for (final entry in widget.positionOverrides.entries) {
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

    // Step 4: Apply allowFilter (if not 'all') per variation
    if (widget.allowFilter != TContextualAllowFilter.all) {
      final targetPosition = _positionFromAllowFilter(widget.allowFilter);

      for (final variation in TContextualVariation.values) {
        final allContent = <Widget>[
          ...result[TContextualPosition.top]![variation] ?? const [],
          ...result[TContextualPosition.bottom]![variation] ?? const [],
          ...result[TContextualPosition.left]![variation] ?? const [],
          ...result[TContextualPosition.right]![variation] ?? const [],
        ];

        // Clear all positions for this variation
        for (final position in TContextualPosition.values) {
          result[position]![variation] = const [];
        }

        // Assign to target position
        result[targetPosition]![variation] = allContent;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              contentByVariation: _displayedContent[TContextualPosition.top] ?? const {},
              position: TContextualPosition.top,
              alignment: widget.topAlignment,
              mainAxisSize: widget.topMainAxisSize,
              builder: widget.topBuilder,
              phase: _phases[TContextualPosition.top]!,
              controller: _controllers[TContextualPosition.top]!,
              curve: widget.animationCurve,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              contentByVariation: _displayedContent[TContextualPosition.bottom] ?? const {},
              position: TContextualPosition.bottom,
              alignment: widget.bottomAlignment,
              mainAxisSize: widget.bottomMainAxisSize,
              builder: widget.bottomBuilder,
              phase: _phases[TContextualPosition.bottom]!,
              controller: _controllers[TContextualPosition.bottom]!,
              curve: widget.animationCurve,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              contentByVariation: _displayedContent[TContextualPosition.left] ?? const {},
              position: TContextualPosition.left,
              alignment: widget.leftAlignment,
              mainAxisSize: widget.leftMainAxisSize,
              builder: widget.leftBuilder,
              phase: _phases[TContextualPosition.left]!,
              controller: _controllers[TContextualPosition.left]!,
              curve: widget.animationCurve,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: _TPositionContent(
              contentByVariation: _displayedContent[TContextualPosition.right] ?? const {},
              position: TContextualPosition.right,
              alignment: widget.rightAlignment,
              mainAxisSize: widget.rightMainAxisSize,
              builder: widget.rightBuilder,
              phase: _phases[TContextualPosition.right]!,
              controller: _controllers[TContextualPosition.right]!,
              curve: widget.animationCurve,
            ),
          ),
        ),
      ],
    );
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
      position == TContextualPosition.top || position == TContextualPosition.bottom;

  Axis get _variationStackAxis => _isTopOrBottom ? Axis.vertical : Axis.horizontal;

  Axis get _variationContentAxis => _isTopOrBottom ? Axis.horizontal : Axis.vertical;

  bool get _reverseVariationOrder =>
      position == TContextualPosition.bottom || position == TContextualPosition.right;

  Widget _buildVariationGroup(List<Widget> widgets) {
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
          mainAxisAlignment: _alignmentToMainAxisAlignment(alignment),
          crossAxisAlignment: _alignmentToCrossAxisAlignment(alignment),
          children: widgets,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build variation groups
    final variationGroups = <Widget>[];
    for (final variation in TContextualVariation.values) {
      final widgets = contentByVariation[variation] ?? const [];
      if (widgets.isNotEmpty) {
        variationGroups.add(_buildVariationGroup(widgets));
      }
    }

    if (variationGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    // If only one variation group, use it directly
    final Widget contentWidget;
    if (variationGroups.length == 1) {
      contentWidget = variationGroups.first;
    } else {
      // Multiple variation groups: stack them
      final orderedGroups =
          _reverseVariationOrder ? variationGroups.reversed.toList() : variationGroups;

      contentWidget = SingleChildScrollView(
        scrollDirection: _variationStackAxis,
        child: Flex(
          direction: _variationStackAxis,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: _alignmentToMainAxisAlignment(alignment),
          crossAxisAlignment: _alignmentToCrossAxisAlignment(alignment),
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
          opacity: opacity.clamp(0.0, 1.0),
          child: FractionalTranslation(
            translation: offset,
            child: child,
          ),
        );
      },
      child: contentWidget,
    );
  }

  MainAxisAlignment _alignmentToMainAxisAlignment(Alignment alignment) {
    final value = _isTopOrBottom ? alignment.x : alignment.y;
    if (value < 0) return MainAxisAlignment.start;
    if (value > 0) return MainAxisAlignment.end;
    return MainAxisAlignment.center;
  }

  CrossAxisAlignment _alignmentToCrossAxisAlignment(Alignment alignment) {
    final value = _isTopOrBottom ? alignment.y : alignment.x;
    if (value < 0) return CrossAxisAlignment.start;
    if (value > 0) return CrossAxisAlignment.end;
    return CrossAxisAlignment.center;
  }
}
