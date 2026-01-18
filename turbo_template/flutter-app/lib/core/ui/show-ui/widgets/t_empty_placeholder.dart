import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/seals/t_image_seal.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_add_button.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_column.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_image.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/generated/l10n.dart';

/// A reusable widget for displaying an empty or "no data" state.
class TEmptyPlaceholder extends StatelessWidget {
  /// Creates a stateless widget that displays a friendly empty-view message.
  const TEmptyPlaceholder({
    super.key,
    required this.title,
    this.subtitle,
    this.iconData,
    this.imageAsset,
    this.actionLabel,
    this.onActionPressed,
    this.actionSemanticIdentifier,
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

  /// Optionally show an image asset, e.g. from svgs or pngs.
  /// Provide a path relative to your assets, or use the project’s constants.
  final String? imageAsset;

  /// Text for the optional button (e.g. "Retry" or "Add Item").
  final String? actionLabel;

  /// Callback when the user presses the optional action button.
  final VoidCallback? onActionPressed;

  /// Optional semantic identifier for the action button.
  final String? actionSemanticIdentifier;

  /// Quickly build a placeholder for Inbox screens.
  ///
  /// Example usage:
  /// ```
  /// TEmptyPlaceholder.inboxItems(
  ///   onActionPressed: () => doSomething(),
  /// )
  /// ```
  factory TEmptyPlaceholder.inboxItems({required S strings}) => TEmptyPlaceholder(
    title: strings.inbox,
    subtitle: strings.emptyPlaceholderNothingHere,
    iconData: Icons.inbox_rounded,
  );

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    return TMargin(
      child: TColumn(
        spacing: 0,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Optional icon or image
          if (iconData != null) ...[
            Icon(iconData, size: 48, color: context.colors.icon),
            const TGap.app(multiplier: 0.5),
          ] else if (imageAsset != null) ...[
            // Display image from asset
            TImage(image: TImageSvg(imageLocation: imageAsset!, height: 120, width: 120)),
            const TGap.app(multiplier: 0.5),
          ],

          // Title
          Text(title, maxLines: 2, textAlign: TextAlign.center, style: context.texts.h4),

          if (hasSubtitle) ...[
            const TGap(8),
            Text(
              subtitle!,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.texts.muted,
            ),
          ],

          // Optional Action
          if (onActionPressed != null && actionLabel != null) ...[
            const TGap.app(),
            if (actionSemanticIdentifier != null)
              Semantics(
                identifier: actionSemanticIdentifier,
                button: true,
                child: TAddButton(onPressed: onActionPressed!, text: actionLabel!),
              )
            else
              TAddButton(onPressed: onActionPressed!, text: actionLabel!),
          ],
        ],
      ),
    );
  }
}
