import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/state/typedefs/context_def.dart';
import 'package:roomy_mobile/state/widgets/unfocusable.dart';
import 'package:roomy_mobile/typography/widgets/t_auto_size_text.dart';
import 'package:roomy_mobile/ui/config/t_icon_vars.dart';
import 'package:roomy_mobile/ui/enums/t_color_container.dart';
import 'package:roomy_mobile/ui/extensions/color_extension.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_button.dart';
import 'package:roomy_mobile/ui/widgets/t_gap.dart';
import 'package:roomy_mobile/ui/widgets/t_margin.dart';
import 'package:roomy_mobile/ui/widgets/t_row.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TDialog extends StatelessWidget {
  const TDialog({
    Key? key,
    required this.title,
    this.subtitle,
    this.content,
    this.onConfirmedPressed,
    this.onCancelPressed,
    this.onBackPressed,
    this.okButtonText,
    this.cancelText,
    this.trailing,
    this.leading,
    this.showCloseButton = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(32)),
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final WidgetBuilder? content;
  final ContextDef? onConfirmedPressed;
  final ContextDef? onCancelPressed;
  final ContextDef? onBackPressed;
  final String? okButtonText;
  final String? cancelText;
  final List<TButtonVars>? trailing;
  final List<TButtonVars>? leading;
  final bool showCloseButton;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final pLeading = leading ?? <TButtonVars>[];
    final pTrailing = trailing ?? <TButtonVars>[];
    final horizontalIconCount = max(pLeading.length + (showCloseButton ? 1 : 0), pTrailing.length);
    final hasButtons = onCancelPressed != null || onConfirmedPressed != null;
    return Unfocusable(
      child: ShadDialog(
        padding: const EdgeInsets.all(TSizes.appPaddingX0p5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TMargin(
              multiplier: 0.5,
              bottom: 0,
              child: Stack(
                children: [
                  SizedBox(
                    height: TSizes.iconButtonSize,
                    child: TRow(
                      spacing: 0,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (showCloseButton)
                          Builder(
                            builder: (context) {
                              return ShadButton.ghost(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Icon(Icons.arrow_back),
                              );
                            },
                          ),
                        for (final buttonBap in pLeading)
                          switch (buttonBap) {
                            final TIconButtonVars iconBap => ShadButton.ghost(
                              onPressed: iconBap.onPressed,
                              child: Icon(iconBap.pIconData),
                            ),
                            final TTextButtonVars textBap => TButton.scale(
                              child: Text(style: context.texts.button, textBap.text),
                              onPressed: textBap.onPressed,
                            ),
                            final TIconTextButtonVars iconTextBap => TButton(
                              onPressed: iconTextBap.onPressed,
                              hoverBuilder: (context, isHovered, child) => TColorContainer(
                                color: iconTextBap
                                    .pIconColor(context: context)
                                    .withReactiveHover(isHovered: isHovered),
                                iconData: iconTextBap.iconData,
                              ),
                            ),
                          },
                        const Spacer(),
                        for (final buttonBap in pTrailing)
                          switch (buttonBap) {
                            final TIconButtonVars iconBap => ShadButton.ghost(
                              onPressed: iconBap.onPressed,
                              child: Icon(iconBap.pIconData),
                            ),
                            final TTextButtonVars textBap => TButton.scale(
                              child: Text(textBap.text),
                              onPressed: textBap.onPressed,
                            ),
                            final TIconTextButtonVars iconTextBap => TButton(
                              onPressed: iconTextBap.onPressed,
                              hoverBuilder: (context, isHovered, child) => TColorContainer(
                                color: iconTextBap
                                    .pIconColor(context: context)
                                    .withReactiveHover(isHovered: isHovered),
                                iconData: iconTextBap.iconData,
                              ),
                            ),
                          },
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: TMargin.horizontal(
                        left: TSizes.iconButtonSize * horizontalIconCount,
                        right: TSizes.iconButtonSize * horizontalIconCount,
                        child: TAutoSizeText(
                          title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: context.texts.h4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (subtitle != null)
              TMargin.app(
                top: TSizes.appPadding / 2,
                bottom: 0,
                child: Text(style: context.texts.small, subtitle!, textAlign: TextAlign.center),
              ),
            if (content != null) ...[
              Builder(
                builder: (context) {
                  return TMargin.app(bottom: 0, child: content!.call(context));
                },
              ),
            ],
            if (hasButtons) ...[
              const TGap.app(multiplier: 0.5),
              TMargin.app(
                child: TRow(
                  spacing: 24,
                  children: [
                    if (onCancelPressed != null)
                      Expanded(
                        child: ShadButton.secondary(
                          child: Text(cancelText ?? context.strings.cancel),
                          onPressed: () => onCancelPressed?.call(context),
                        ),
                      ),
                    if (onConfirmedPressed != null)
                      Expanded(
                        child: ShadButton(
                          child: Text(
                            okButtonText ?? context.strings.save,
                            style: context.texts.button,
                          ),
                          onPressed: () => onConfirmedPressed!(context),
                        ),
                      ),
                  ],
                ),
              ),
            ] else
              const TGap.app(),
          ],
        ),
      ),
    );
  }
}
