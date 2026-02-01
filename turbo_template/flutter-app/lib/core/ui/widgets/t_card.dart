import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class TCard extends StatelessWidget {
  const TCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.border,
    this.shadows,
    this.borderRadius,
    this.color,
    this.height,
    this.title,
    required this.description,
    this.trailing,
    this.children = const [],
    required this.icon,
    this.showDivider = false,
    this.childSpacing = 12.0,
  });

  factory TCard.border({
    required BuildContext context,
    Key? key,
    Widget? child,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    BorderRadius? borderRadius,
    double? height,
    String? title,
    String? description,
    Widget? trailing,
    required IconData icon,
    List<Widget> children = const [],
  }) => TCard(
    key: key,
    children: children,
    icon: icon,
    child: child,
    padding: padding,
    border: ShadBorder.all(
      color: context.colors.border.lighten(),
    ),
    shadows: [
      ...context.decorations.shadow,
    ],
    borderRadius: borderRadius,
    color: Colors.transparent,
    height: height,
    title: title,
    description: description,
    trailing: trailing,
  );

  final Widget? child;
  final List<Widget> children;
  final EdgeInsets padding;
  final List<BoxShadow>? shadows;
  final ShadBorder? border;
  final BorderRadius? borderRadius;
  final Color? color;
  final double? height;
  final String? title;
  final String? description;
  final Widget? trailing;
  final IconData icon;
  final bool showDivider;
  final double childSpacing;

  @override
  Widget build(BuildContext context) {
    const borderBorderRadius = Radius.circular(0);
    final borderSide = BorderSide(
      color: context.colors.cardBorder,
      width: 1,
    );
    final shadBorderSide = ShadBorderSide(
      color: context.colors.cardBorder,
      width: 1,
    );
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
                top: padding.top,
              ),
              decoration: BoxDecoration(
                color: context.colors.card.lighten(2),
                border: Border(
                  top: borderSide,
                  left: borderSide,
                  right: borderSide,
                ),
                boxShadow: context.decorations.cardShadow,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: borderBorderRadius,
                  bottomRight: borderBorderRadius,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: description == null ? 32 : 40,
                  ),
                  const TGap(12),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (title != null)
                                    Text(
                                      title!,
                                      style: context.texts.large.copyWith(
                                        height: 1,
                                      ),
                                    ),
                                  if (description != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        description!,
                                        style: context.texts.muted.copyWith(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (((title != null && title!.isNotEmpty) ||
                                (description != null &&
                                    description!.isNotEmpty)) &&
                            (children.isNotEmpty || child != null))
                          ...[],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              Positioned(
                child: trailing!,
                top: 16,
                right: 16,
              ),
          ],
        ),
        Divider(
          color: context.colors.cardBorder,
          indent: 2,
          endIndent: 2,
          height: 0.0,
        ),
        Stack(
          children: [
            ShadCard(
              padding: padding,
              height: height,
              backgroundColor: color,
              radius:
                  borderRadius ??
                  const BorderRadius.only(
                    topLeft: borderBorderRadius,
                    topRight: borderBorderRadius,
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
              border:
                  border ??
                  ShadBorder(
                    bottom: shadBorderSide,
                    left: shadBorderSide,
                    right: shadBorderSide,
                  ),
              shadows: shadows ?? context.decorations.cardShadow,
              child:
                  child ??
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...children,
                    ],
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class TCardFlex extends StatelessWidget {
  const TCardFlex({
    super.key,
    required this.deviceType,
    required this.child,
    required this.icon,
    this.description,
  });

  final TDeviceType deviceType;
  final Widget child;
  final IconData icon;
  final String? description;

  @override
  Widget build(BuildContext context) => switch (deviceType) {
    TDeviceType.mobile => TMargin(child: child),
    TDeviceType.tablet || TDeviceType.desktop => TMargin(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: TSizes.dialogMaxWidth),
        child: TCard(
          description: description,
          icon: icon,
          child: child,
        ),
      ),
    ),
  };
}
