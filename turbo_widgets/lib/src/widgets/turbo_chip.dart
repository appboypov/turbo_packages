import 'package:flutter/material.dart';

/// A chip widget for displaying small pieces of information.
class TurboChip extends StatelessWidget {
  const TurboChip({
    super.key,
    required this.text,
    this.color,
    this.borderColor,
    this.textStyle,
    this.height = 24,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  final String text;
  final Color? color;
  final Color? borderColor;
  final TextStyle? textStyle;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: color ?? theme.cardColor,
        border: Border.all(color: borderColor ?? theme.dividerColor, width: 1),
      ),
      child: Padding(
        padding: padding,
        child: Center(
          child: Text(
            text,
            style:
                textStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  height: 1,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
