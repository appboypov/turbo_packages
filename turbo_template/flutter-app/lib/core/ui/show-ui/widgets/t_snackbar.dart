import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/text_style_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TSnackbar extends StatelessWidget {
  const TSnackbar({
    required this.iconData,
    required this.title,
    required this.subtitle,
    this.onPressedText,
    required this.onPressed,
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 2,
    super.key,
  });

  final IconData iconData;
  final String title;
  final String? subtitle;
  final String? onPressedText;
  final VoidCallback? onPressed;

  final int titleMaxLines;
  final int subtitleMaxLines;

  @override
  Widget build(BuildContext context) {
    final pOnPressedText = onPressedText ?? context.strings.view;
    final hasOnPressed = onPressed != null;
    final hasSubtitle = subtitle?.isNotEmpty == true;
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(iconData, color: context.colors.card.onColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: context.texts.p.bold.copyWith(height: 1),
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        if (hasSubtitle) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: context.texts.muted,
            maxLines: subtitleMaxLines,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
    return TMargin.only(
      top: TSizes.appPadding,
      left: TSizes.appPadding,
      right: TSizes.appPadding,
      child: ShadCard(
        radius: hasSubtitle ? null : BorderRadius.circular(12),
        shadows: context.decorations.outerShadow,
        padding: const EdgeInsets.all(16),
        child: hasOnPressed
            ? Row(
                crossAxisAlignment: hasSubtitle
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.center,
                children: [
                  Expanded(child: column),
                  TButton(
                    onPressed: onPressed,
                    child: ShadBadge(child: Text(pOnPressedText), onPressed: onPressed),
                  ),
                ],
              )
            : column,
      ),
    );
  }
}
