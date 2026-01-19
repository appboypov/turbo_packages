import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:roomy_mobile/data/extensions/object_extension.dart';
import 'package:roomy_mobile/data/extensions/string_extension.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/ui/config/t_icon_vars.dart';
import 'package:roomy_mobile/ui/enums/emoji.dart';
import 'package:roomy_mobile/ui/enums/t_color_container.dart';
import 'package:roomy_mobile/ui/extensions/color_extension.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_button.dart';
import 'package:roomy_mobile/ui/widgets/t_row.dart';

class TSectionHeader extends StatelessWidget {
  const TSectionHeader({
    super.key,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.titleBuilder,
    this.subtitleBuilder,
    this.actionsBuilder,
    this.emoji,
    this.trailingTitle,
  });

  final Emoji? emoji;
  final String? title;
  final String? subtitle;
  final List<TIconTextButtonVars> actions;
  final Widget Function(Widget title)? titleBuilder;
  final Widget Function(Widget subtitle)? subtitleBuilder;
  final Widget Function(Widget actions)? actionsBuilder;
  final List<Widget>? trailingTitle;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null;
    final hasSubtitle = subtitle != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle)
          Builder(
            builder: (context) {
              final titleWidget =
                  titleBuilder?.call(
                    Text(
                      title!.butWhen(emoji != null, (cValue) => cValue.withLeadingEmoji(emoji)),
                      style: context.texts.large,
                    ),
                  ) ??
                  Text(
                    title!.butWhen(emoji != null, (cValue) => cValue.withLeadingEmoji(emoji)),
                    style: context.texts.large,
                  );
              return trailingTitle == null
                  ? titleWidget
                  : Row(
                      children: [
                        Flexible(child: titleWidget),
                        ...trailingTitle!,
                      ],
                    );
            },
          ),
        if (hasSubtitle)
          Padding(
            padding: title == null ? EdgeInsets.zero : const EdgeInsets.only(top: 2),
            child:
                subtitleBuilder?.call(Text(subtitle!, style: context.texts.muted)) ??
                Text(subtitle!, style: context.texts.muted),
          ),
        if (actions.isNotEmpty)
          Builder(
            builder: (context) {
              final row = Padding(
                padding: (hasTitle || hasSubtitle)
                    ? const EdgeInsets.only(top: TSizes.appPadding)
                    : EdgeInsets.zero,
                child: TRow(
                  children: [
                    for (final action in actions)
                      TButton(
                        height: null,
                        onPressed: action.onPressed,
                        hoverBuilder: (context, isHovered, child) => TColorContainer(
                          color: action
                              .pIconColor(context: context)
                              .withReactiveHover(isHovered: isHovered),
                          iconData: action.iconData,
                          text: action.text,
                          iconTextColor: action.textColor,
                        ),
                      ),
                  ],
                ),
              );
              return actionsBuilder?.call(row) ?? row;
            },
          ),
      ],
    );
  }
}
