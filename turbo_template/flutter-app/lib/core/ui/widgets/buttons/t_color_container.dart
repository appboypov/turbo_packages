import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/typedefs/theme_config_def.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_row.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gradient.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';

class TColorContainer extends StatelessWidget {
  const TColorContainer({
    Key? key,
    required this.color,
    this.child,
    this.iconData,
    this.text,
    this.fillType = TFillType.opacity,
    this.iconTextColor,
    this.addShadows = true,
    TColorContainerType? type,
    this.borderColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.height,
    this.width,
  }) : type =
           type ??
           (text == null && child == null
               ? TColorContainerType.icon
               : TColorContainerType.chipButton),
       super(key: key);

  final Color? color;
  final Widget? child;
  final IconData? iconData;
  final String? text;
  final TColorContainerType type;
  final TFillType fillType;
  final ThemeConfigDef<Color?>? iconTextColor;
  final bool addShadows;
  final Color? borderColor;
  final BorderRadius borderRadius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final pColor = color ?? context.colors.icon;
    final container = AnimatedContainer(
      duration: TDurations.animation,
      alignment: Alignment.center,
      height: height ?? type.height,
      width: width ?? type.width,
      padding: type.isIcon ? null : const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: TGradient.topCenter(
          colors: switch (fillType) {
            TFillType.solid => pColor,
            TFillType.opacity => pColor.withValues(alpha: 0.5),
          }.asGradient(),
        ),
        borderRadius: borderRadius,
        boxShadow: addShadows ? [pColor.asShadow()] : null,
        border: Border.all(color: borderColor ?? pColor.withValues(alpha: 0.3)),
      ),
      child:
          child ??
          Builder(
            builder: (context) {
              final pIconTextColor =
                  iconTextColor?.call(context.themeMode, context.theme) ??
                  switch (type) {
                    TColorContainerType.icon => pColor.onColor,
                    TColorContainerType.chipButton =>
                      context.colors.background.onColor,
                    TColorContainerType.none =>
                      context.colors.background.onColor,
                  };
              return TRow(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (iconData != null)
                    TIconSmall.small(iconData!, color: pIconTextColor),
                  if (text != null)
                    AutoSizeText(
                      text!,
                      style: context.texts.button.copyWith(
                        color: pIconTextColor,
                      ),
                    ),
                ],
              );
            },
          ),
    );
    return container;
  }
}

enum TColorContainerType {
  icon,
  chipButton,
  none
  ;

  double? get height {
    switch (this) {
      case TColorContainerType.icon:
        return TSizes.iconButtonSize;
      case TColorContainerType.chipButton:
        return TSizes.chipButtonHeight;
      case TColorContainerType.none:
        return null;
    }
  }

  double? get width {
    switch (this) {
      case TColorContainerType.icon:
        return TSizes.iconButtonSize;
      case TColorContainerType.chipButton:
        return null;
      case TColorContainerType.none:
        return null;
    }
  }

  bool get isIcon => this == icon;
}

enum TFillType { solid, opacity }
