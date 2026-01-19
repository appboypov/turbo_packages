import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/enums/t_contextual_allow_filter.dart';
import 'package:turbo_widgets/src/enums/t_contextual_position.dart';

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
    this.allowFilter = TContextualAllowFilter.all,
    this.positionOverrides = const {},
    this.topAlignment = Alignment.center,
    this.bottomAlignment = Alignment.center,
    this.leftAlignment = Alignment.center,
    this.rightAlignment = Alignment.center,
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

class _TContextualWrapperState extends State<TContextualWrapper>
    with TickerProviderStateMixin {
  late final Map<TContextualPosition, AnimationController> _controllers;
  final Map<TContextualPosition, _AnimationPhase> _phases = {};
  Map<TContextualPosition, List<Widget>> _displayedContent = {};
  Map<TContextualPosition, List<Widget>>? _pendingContent;
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

  bool _listEquals(List<Widget> a, List<Widget> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!identical(a[i], b[i])) return false;
    }
    return true;
  }

  Future<void> _animateContentChanges(
    Map<TContextualPosition, List<Widget>> newContent,
  ) async {
    if (_isAnimating) {
      _pendingContent = newContent;
      return;
    }

    _isAnimating = true;

    final positionsToAnimateOut = <TContextualPosition>[];
    final positionsToAnimateIn = <TContextualPosition>[];

    for (final position in TContextualPosition.values) {
      final oldContent = _displayedContent[position] ?? const [];
      final newPositionContent = newContent[position] ?? const [];

      if (!_listEquals(oldContent, newPositionContent)) {
        if (oldContent.isNotEmpty) {
          positionsToAnimateOut.add(position);
        }
        if (newPositionContent.isNotEmpty) {
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
        _displayedContent[position] = const [];
        _phases[position] = _AnimationPhase.idle;
      }
      setState(() {});
    }

    // Phase 2: Update displayed content and animate in positions gaining content
    if (positionsToAnimateIn.isNotEmpty) {
      for (final position in positionsToAnimateIn) {
        _displayedContent[position] = newContent[position] ?? const [];
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
      if (!positionsToAnimateOut.contains(position) &&
          !positionsToAnimateIn.contains(position)) {
        _displayedContent[position] = newContent[position] ?? const [];
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

  Map<TContextualPosition, List<Widget>> _resolveContent() {
    var result = <TContextualPosition, List<Widget>>{
      TContextualPosition.top: [...widget.topContent],
      TContextualPosition.bottom: [...widget.bottomContent],
      TContextualPosition.left: [...widget.leftContent],
      TContextualPosition.right: [...widget.rightContent],
    };

    // Apply overrides: move content from source to target position
    for (final entry in widget.positionOverrides.entries) {
      final source = entry.key;
      final target = entry.value;

      final sourceContent = result[source] ?? [];
      if (sourceContent.isNotEmpty) {
        result[target] = [...(result[target] ?? []), ...sourceContent];
        result[source] = [];
      }
    }

    // If allowFilter is not 'all', merge all content to the allowed position
    if (widget.allowFilter != TContextualAllowFilter.all) {
      final targetPosition = TContextualPosition.values.firstWhere(
        (p) => p.name == widget.allowFilter.name,
      );

      final allContent = <Widget>[
        ...result[TContextualPosition.top] ?? [],
        ...result[TContextualPosition.bottom] ?? [],
        ...result[TContextualPosition.left] ?? [],
        ...result[TContextualPosition.right] ?? [],
      ];

      result = {
        TContextualPosition.top: const [],
        TContextualPosition.bottom: const [],
        TContextualPosition.left: const [],
        TContextualPosition.right: const [],
      };
      result[targetPosition] = allContent;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content - not positioned so it sizes the Stack
        widget.child,

        // Top overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TPositionContent(
            content: _displayedContent[TContextualPosition.top] ?? const [],
            position: TContextualPosition.top,
            alignment: widget.topAlignment,
            builder: widget.topBuilder,
            phase: _phases[TContextualPosition.top]!,
            controller: _controllers[TContextualPosition.top]!,
            curve: widget.animationCurve,
          ),
        ),

        // Bottom overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _TPositionContent(
            content: _displayedContent[TContextualPosition.bottom] ?? const [],
            position: TContextualPosition.bottom,
            alignment: widget.bottomAlignment,
            builder: widget.bottomBuilder,
            phase: _phases[TContextualPosition.bottom]!,
            controller: _controllers[TContextualPosition.bottom]!,
            curve: widget.animationCurve,
          ),
        ),

        // Left overlay
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: _TPositionContent(
            content: _displayedContent[TContextualPosition.left] ?? const [],
            position: TContextualPosition.left,
            alignment: widget.leftAlignment,
            builder: widget.leftBuilder,
            phase: _phases[TContextualPosition.left]!,
            controller: _controllers[TContextualPosition.left]!,
            curve: widget.animationCurve,
          ),
        ),

        // Right overlay
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: _TPositionContent(
            content: _displayedContent[TContextualPosition.right] ?? const [],
            position: TContextualPosition.right,
            alignment: widget.rightAlignment,
            builder: widget.rightBuilder,
            phase: _phases[TContextualPosition.right]!,
            controller: _controllers[TContextualPosition.right]!,
            curve: widget.animationCurve,
          ),
        ),
      ],
    );
  }
}

/// Stateless widget that renders content for a position with animation.
class _TPositionContent extends StatelessWidget {
  const _TPositionContent({
    required this.content,
    required this.position,
    required this.alignment,
    required this.phase,
    required this.controller,
    required this.curve,
    this.builder,
  });

  final List<Widget> content;
  final TContextualPosition position;
  final Alignment alignment;
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

  bool get _isHorizontal =>
      position == TContextualPosition.top ||
      position == TContextualPosition.bottom;

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return const SizedBox.shrink();
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
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (builder != null) {
      return builder!(content);
    }

    if (content.length == 1) {
      return Align(
        alignment: alignment,
        child: content.first,
      );
    }

    return Flex(
      direction: _isHorizontal ? Axis.horizontal : Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: _alignmentToMainAxisAlignment(alignment),
      crossAxisAlignment: _alignmentToCrossAxisAlignment(alignment),
      children: content,
    );
  }

  MainAxisAlignment _alignmentToMainAxisAlignment(Alignment alignment) {
    final value = _isHorizontal ? alignment.x : alignment.y;
    if (value < 0) return MainAxisAlignment.start;
    if (value > 0) return MainAxisAlignment.end;
    return MainAxisAlignment.center;
  }

  CrossAxisAlignment _alignmentToCrossAxisAlignment(Alignment alignment) {
    final value = _isHorizontal ? alignment.y : alignment.x;
    if (value < 0) return CrossAxisAlignment.start;
    if (value > 0) return CrossAxisAlignment.end;
    return CrossAxisAlignment.center;
  }
}
