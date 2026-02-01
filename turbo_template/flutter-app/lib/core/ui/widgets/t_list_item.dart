import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide DateFormat;
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/utils/haptic_button_utils.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_row.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';

class TListItem extends StatelessWidget {
  const TListItem({
    super.key,
    required this.title,
    this.leading = const [],
    this.subtitle,
    this.isEmpty = false,
    this.trailing = const [],
    this.spacing = TSizes.itemGap,
    this.onPressed,
    this.onTrailingArrowPressed,
    this.onTitlePressed,
    this.trailingTitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> leading;
  final List<Widget> trailing;
  final double spacing;
  final VoidCallback? onPressed;
  final VoidCallback? onTrailingArrowPressed;
  final VoidCallback? onTitlePressed;
  final Widget? trailingTitle;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final row = TRow(
      spacing: spacing,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final leadingItem in leading) leadingItem,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(2),
              if (onTitlePressed != null)
                TButton.opacity(
                  onPressed: onTitlePressed,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: context.texts.list.copyWith(height: 1),
                        ),
                      ),
                      if (trailingTitle != null) ...[
                        const SizedBox(width: 8),
                        trailingTitle!,
                      ],
                    ],
                  ),
                )
              else
                Text(title, style: context.texts.list.copyWith(height: 1)),
              const TGap(4),
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: isEmpty
                      ? context.texts.xMuted.copyWith(
                          height: 1,
                        )
                      : context.texts.xMuted.copyWith(height: 1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        ...trailing,
        if (onTrailingArrowPressed != null) ...[
          ShadIconButton.outline(
            onPressed: withSelectionHaptic(onTrailingArrowPressed),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: TSizes.iconSizeX0p75,
            ),
            width: 32,
            height: 32,
          ),
        ],
      ],
    );
    return onPressed == null
        ? row
        : TButton.opacity(child: row, onPressed: onPressed);
  }
}

class TListItemAvatar extends TListItem {
  const TListItemAvatar({
    super.key,
    required super.title,
    super.subtitle,
    required this.avatar,
    super.trailing,
  });

  final CircleAvatar avatar;

  @override
  Widget build(BuildContext context) =>
      TListItem(title: title, leading: [avatar]);
}
