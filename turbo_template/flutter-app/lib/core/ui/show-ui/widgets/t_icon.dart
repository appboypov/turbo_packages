import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_gradient.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

enum IconSize {
  xSmall,
  small,
  medium;

  double get size {
    switch (this) {
      case IconSize.xSmall:
        return 12;
      case IconSize.small:
        return 18;
      case IconSize.medium:
        return 24;
    }
  }
}

enum TIconDecoration {
  gradient,
  background,
  border,
  borderWithBackground,
  transparant;

  bool get isBorder => this == TIconDecoration.border;
}

class TIconContainer extends StatelessWidget {
  const TIconContainer({
    Key? key,
    this.iconData,
    this.padding,
    this.icon,
    this.tIconDecoration = defaultTurboIconDecoration,
    this.label,
    this.borderRadius,
    this.size,
    this.gradient,
    this.borderWidth,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.iconColor,
  }) : assert(iconData != null || icon != null, 'Either iconData or icon must be provided'),
       super(key: key);

  final IconData? iconData;
  final Widget? icon;
  final String? label;
  final TIconDecoration tIconDecoration;
  final BorderRadius? borderRadius;
  final double? size;
  final List<Color>? gradient;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final Color? iconColor;
  final EdgeInsets? padding;

  static const defaultTurboIconDecoration = TIconDecoration.gradient;

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColor;
    final Gradient? backgroundGradient;
    final List<BoxShadow>? boxShadow;
    final BoxBorder? border;

    final borderWidth = this.borderWidth ?? TSizes.borderWidth;
    switch (tIconDecoration) {
      case TIconDecoration.gradient:
        backgroundColor = null;
        backgroundGradient = gradient == null
            ? TGradient.topCenter(colors: context.colors.primaryButtonGradient)
            : TGradient.topCenter(colors: gradient!);
        boxShadow = this.boxShadow ?? context.decorations.outerShadow;
        border = null;
        break;
      case TIconDecoration.background:
        backgroundColor = this.backgroundColor ?? context.colors.background;
        backgroundGradient = gradient == null ? null : TGradient.topCenter(colors: gradient!);
        boxShadow = this.boxShadow ?? context.decorations.outerShadow;
        border = null;
        break;
      case TIconDecoration.border:
        backgroundColor = this.backgroundColor;
        backgroundGradient = gradient == null ? null : TGradient.topCenter(colors: gradient!);
        boxShadow = null;
        border = Border.all(
          color: borderColor ?? context.colors.focus,
          strokeAlign: BorderSide.strokeAlignInside,
          width: borderWidth,
        );
        break;
      case TIconDecoration.borderWithBackground:
        backgroundColor = this.backgroundColor ?? context.colors.background;
        backgroundGradient = gradient == null ? null : TGradient.topCenter(colors: gradient!);
        boxShadow = null;
        border = Border.all(
          color: borderColor ?? context.colors.focus,
          strokeAlign: BorderSide.strokeAlignInside,
          width: borderWidth,
        );
        break;
      case TIconDecoration.transparant:
        backgroundColor = null;
        backgroundGradient = null;
        boxShadow = null;
        border = null;
        break;
    }

    final height = size ?? TSizes.iconButtonSize;
    final hasLabel = label != null;
    final width = hasLabel ? null : height;
    final iconSize = height * 0.4;
    final borderRadius = this.borderRadius ?? BorderRadius.circular(TSizes.smallCardButtonRadius);

    final icon =
        this.icon ??
        Icon(
          iconData,
          size: iconSize,
          color:
              iconColor ??
              (hasLabel
                  ? context.colors.icon
                  : backgroundColor?.onColor ?? backgroundGradient?.colors.onColor),
        );
    return Container(
      height: height,
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      padding: padding,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: borderRadius,
        shape: BoxShape.rectangle,
        gradient: backgroundGradient,
        boxShadow: boxShadow,
      ),
      child: hasLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const Gap(8),
                Text(
                  '${label!}',
                  style: context.texts.button.copyWith(
                    color: backgroundColor?.onColor ?? backgroundGradient?.colors.onColor,
                    height: 1,
                  ),
                ),
              ],
            )
          : icon,
    );
  }
}

class TIconSmall extends StatelessWidget {
  const TIconSmall(this.iconData, {Key? key, this.iconSize = IconSize.small, this.color})
    : super(key: key);

  const TIconSmall.small(this.iconData, {super.key, this.color}) : iconSize = IconSize.small;

  const TIconSmall.xSmall(this.iconData, {super.key, this.color}) : iconSize = IconSize.xSmall;

  final IconData iconData;
  final IconSize iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) => Icon(
    iconData,
    shadows: context.decorations.shadow,
    color: color ?? context.colors.icon,
    size: iconSize.size,
  );
}
