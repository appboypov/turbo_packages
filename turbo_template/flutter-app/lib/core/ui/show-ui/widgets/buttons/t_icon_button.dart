import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_icon.dart';
import 'release_scale_button.dart';

class TIconButton extends StatelessWidget {
  const TIconButton({
    Key? key,
    this.iconData,
    this.padding,
    this.icon,
    required this.onPressed,
    this.tIconDecoration = TIconContainer.defaultTurboIconDecoration,
    this.margin = ReleaseScaleButton.defaultPadding,
    this.borderRadius,
    this.size,
    this.label,
    this.gradient,
    this.borderWidth,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow = const [],
    this.iconColor,
  }) : assert(iconData != null || icon != null, 'Either iconData or icon must be provided'),
       super(key: key);

  final EdgeInsets margin;
  final EdgeInsets? padding;
  final IconData? iconData;
  final Widget? icon;
  final String? label;
  final TIconDecoration tIconDecoration;
  final VoidCallback? onPressed;
  final double? size;
  final BorderRadius? borderRadius;
  final List<Color>? gradient;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) => TButton(
    onPressed: onPressed,
    height: size,
    width: label != null ? null : size,
    child: Padding(
      padding: margin,
      child: TIconContainer(
        padding: padding,
        iconColor: iconColor,
        boxShadow: boxShadow,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        icon: icon,
        borderWidth: borderWidth,
        iconData: iconData,
        tIconDecoration: tIconDecoration,
        borderRadius: borderRadius,
        size: size,
        label: label,
        gradient: gradient,
      ),
    ),
  );
}
