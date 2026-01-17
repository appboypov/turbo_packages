import 'package:flutter/material.dart';
import 't_column.dart';
import 't_gap.dart';
import 't_margin.dart';

/// A reusable widget for displaying an empty or "no data" state.
class TEmptyPlaceholder extends StatelessWidget {
  const TEmptyPlaceholder({
    super.key,
    required this.title,
    this.subtitle,
    this.iconData,
    this.imageAsset,
    this.actionLabel,
    this.onActionPressed,
    this.actionSemanticIdentifier,
    this.iconSize = 48,
    this.imageSize = 120,
  }) : assert(
         iconData == null || imageAsset == null,
         'Provide only iconData OR imageAsset, not both.',
       );

  /// Main heading text, e.g. "No items found"
  final String title;

  /// Optional secondary text, e.g. "Add a new item to get started"
  final String? subtitle;

  /// Optionally show an icon (instead of imageAsset).
  final IconData? iconData;

  /// Optionally show an image asset path.
  final String? imageAsset;

  /// Text for the optional button (e.g. "Retry" or "Add Item").
  final String? actionLabel;

  /// Callback when the user presses the optional action button.
  final VoidCallback? onActionPressed;

  /// Optional semantic identifier for the action button.
  final String? actionSemanticIdentifier;

  /// Size of the icon
  final double iconSize;

  /// Size of the image
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return TMargin(
      child: TColumn(
        spacing: 0,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Optional icon or image
          if (iconData != null) ...[
            Icon(iconData, size: iconSize, color: theme.iconTheme.color),
            const TGap.app(multiplier: 0.5),
          ] else if (imageAsset != null) ...[
            Image.asset(imageAsset!, height: imageSize, width: imageSize),
            const TGap.app(multiplier: 0.5),
          ],

          // Title
          Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),

          if (hasSubtitle) ...[
            const TGap(8),
            Text(
              subtitle!,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],

          // Optional Action
          if (onActionPressed != null && actionLabel != null) ...[
            const TGap.app(),
            if (actionSemanticIdentifier != null)
              Semantics(
                identifier: actionSemanticIdentifier,
                button: true,
                child: _ActionButton(
                  onPressed: onActionPressed!,
                  label: actionLabel!,
                ),
              )
            else
              _ActionButton(onPressed: onActionPressed!, label: actionLabel!),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
