import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/buttons/t_row.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

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
  final List<Widget> actions;
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
                    for (final action in actions) action,
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
