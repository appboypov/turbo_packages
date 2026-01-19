import 'package:flutter/material.dart';
import 'package:turbo_widgets/src/widgets/t_shrink.dart';

class TShowcaseSection extends StatefulWidget {
  const TShowcaseSection({
    required this.title,
    required this.child,
    super.key,
    this.initiallyExpanded = false,
    this.headerColor,
    this.headerTextColor,
    this.contentPadding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(left: 16, bottom: 16, right: 16),
    this.borderRadius = 16.0,
    this.animationDuration = const Duration(milliseconds: 225),
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final Color? headerColor;
  final Color? headerTextColor;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Duration animationDuration;

  @override
  State<TShowcaseSection> createState() => _TShowcaseSectionState();
}

class _TShowcaseSectionState extends State<TShowcaseSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = widget.headerColor ?? theme.colorScheme.primary;
    final headerTextColor =
        widget.headerTextColor ?? theme.colorScheme.onPrimary;

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: headerColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      padding: widget.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: _toggleExpanded,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                decoration: BoxDecoration(
                  color: headerColor,
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    const SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: headerTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: AnimatedRotation(
                        duration: widget.animationDuration,
                        turns: _isExpanded ? 0.5 : 0,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: headerTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TVerticalShrink(
            show: _isExpanded,
            sizeDuration: widget.animationDuration,
            fadeDuration: widget.animationDuration,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
