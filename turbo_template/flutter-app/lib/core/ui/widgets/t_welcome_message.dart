import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/seals/t_image_seal.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_card.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_image.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_margin.dart';

import 'color_extension.dart' show ColorExtension;

/// A reusable widget for displaying an empty or "no data" state.
class TWelcomeMessage extends StatelessWidget {
  /// Creates a stateless widget that displays a friendly empty-view message.
  const TWelcomeMessage({
    super.key,
    required this.title,
    this.subtitle,
    this.iconData,
    this.imageAsset,
    this.actionLabel,
    this.onActionPressed,
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

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TCard(
          icon: Icons.diamond_rounded,
          description: title,
          color: context.colors.card.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: ShadBorder.all(color: context.colors.border.asSoftText, width: 2),
          shadows: [
            BoxShadow(
              color: context.colors.border.asSoftText.withValues(alpha: 0.25),
              blurStyle: BlurStyle.outer,
              blurRadius: 12,
              offset: const Offset(0, 0),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (iconData != null)
                    TMargin.right(child: Icon(iconData, size: 48, color: context.colors.icon))
                  else if (imageAsset != null)
                    TMargin.right(
                      child: TImage(
                        image: TImageSvg(imageLocation: imageAsset!, height: 105, width: 105),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AutoSizeText(
                          title,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: context.texts.h5,
                        ),
                        if (hasSubtitle)
                          TMargin.top(
                            multiplier: 0.25,
                            child: Text(
                              subtitle!,
                              maxLines: 10,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: context.texts.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (onActionPressed != null && actionLabel != null)
                TMargin.top(
                  child: ShadButton.outline(onPressed: onActionPressed!, child: Text(actionLabel!)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
