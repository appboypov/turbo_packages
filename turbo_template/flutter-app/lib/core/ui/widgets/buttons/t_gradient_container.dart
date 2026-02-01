import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/config/t_background.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/enums/button_width_behaviour.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gradient.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';

class TGradientContainer extends StatelessWidget {
  const TGradientContainer({
    Key? key,
    this.text,
    this.iconData,
    this.leading,
    this.padding,
    this.widthBehaviour = ButtonWidthBehavior.expand,
    this.width,
    this.isHovered,
    this.height,
    this.child,
    this.focusNode,
    required this.background,
  }) : assert(
         child != null || text != null,
         'Either child or text must be provided',
       ),
       super(key: key);

  final Widget? leading;
  final IconData? iconData;
  final String? text;
  final ButtonWidthBehavior widthBehaviour;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Widget? child;
  final FocusNode? focusNode;
  final bool? isHovered;
  final TBackground background;

  @override
  Widget build(BuildContext context) {
    final pIsHovered = isHovered == true;
    final colors = background.colors?.withReactiveHover(isHovered: pIsHovered);
    final button = AnimatedContainer(
      duration: TDurations.animationX0p5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.buttonBorderRadius),
        boxShadow: pIsHovered ? context.decorations.shadowButton : null,
        gradient: colors == null ? null : TGradient.topCenter(colors: colors),
        color: background.color,
      ),
      height: height,
      width: width,
      child:
          child ??
          Padding(
            padding: switch (iconData != null) {
              true => padding ?? const EdgeInsets.only(left: 12, right: 12),
              false => padding ?? const EdgeInsets.symmetric(horizontal: 12),
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) leading!,
                if (iconData != null) ...[
                  Icon(iconData, size: 16),
                  const Gap(6),
                ],
                Flexible(
                  child: Text(
                    text!,
                    style: context.texts.button,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
    );

    return button;
  }
}
