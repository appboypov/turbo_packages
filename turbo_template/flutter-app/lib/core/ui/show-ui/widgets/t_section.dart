import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/ui/config/t_icon_vars.dart';
import 'package:roomy_mobile/ui/enums/emoji.dart';
import 'package:roomy_mobile/ui/widgets/t_column.dart';
import 'package:roomy_mobile/ui/widgets/t_margin.dart';
import 'package:roomy_mobile/ui/widgets/t_section_header.dart';

class TSection extends StatelessWidget {
  const TSection({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.actions = const [],
    this.topSectionGap = 0,
    this.bottomSectionGap = TSizes.sectionGap,
    this.childPadding = 16.0,
    this.leftMargin,
    this.rightMargin,
    this.titleBuilder,
    this.subtitleBuilder,
    this.actionsBuilder,
    this.emoji,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final List<TIconTextButtonVars> actions;
  final double topSectionGap;
  final double bottomSectionGap;
  final double childPadding;
  final double? leftMargin;
  final double? rightMargin;
  final Widget Function(Widget title)? titleBuilder;
  final Widget Function(Widget subtitle)? subtitleBuilder;
  final Widget Function(Widget actions)? actionsBuilder;
  final Emoji? emoji;

  @override
  Widget build(BuildContext context) {
    return TMargin(
      top: topSectionGap,
      bottom: bottomSectionGap,
      left: leftMargin ?? (context.data.deviceType.isMobile ? TSizes.appPadding : TSizes.appPadding / 2),
      right: rightMargin ?? (context.data.deviceType.isMobile ? TSizes.appPadding : TSizes.appPadding),
      child: TColumn(
        spacing: 0,
        children: [
          TSectionHeader(
            title: title,
            subtitle: subtitle,
            emoji: emoji,
            actions: actions,
            titleBuilder: titleBuilder,
            subtitleBuilder: subtitleBuilder,
            actionsBuilder: actionsBuilder,
          ),
          Padding(
            padding: EdgeInsets.only(top: childPadding),
            child: child,
          ),
        ],
      ),
    );
  }
}
