import 'package:flutter/material.dart';

class TShowcaseItem extends StatelessWidget {
  const TShowcaseItem({
    required this.title,
    required this.child,
    super.key,
    this.titleColor,
    this.titleTextColor,
    this.spacing = 16.0,
  });

  final String title;
  final Widget child;
  final Color? titleColor;
  final Color? titleTextColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = titleColor ?? theme.colorScheme.secondary;
    final textColor = titleTextColor ?? theme.colorScheme.onSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: badgeColor,
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: spacing),
        child,
      ],
    );
  }
}
