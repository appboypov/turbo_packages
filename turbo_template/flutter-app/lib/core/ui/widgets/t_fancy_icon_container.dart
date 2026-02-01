import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_color_container.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon.dart';

class TFancyIconContainer extends StatelessWidget {
  const TFancyIconContainer({
    Key? key,
    required this.iconData,
    this.bgColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.size,
    this.isHovered = false,
    this.borderColor,
  }) : super(key: key);

  final Color? bgColor;
  final IconData iconData;
  final BorderRadius borderRadius;
  final double? size;
  final bool isHovered;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => switch (context.themeMode) {
    TThemeMode.dark => TColorContainer(
      addShadows: false,
      borderRadius: borderRadius,
      fillType: TFillType.opacity,
      width: size,
      height: size,
      borderColor: borderColor,
      color:
          bgColor ??
          context.colors.primary.withReactiveHover(isHovered: isHovered),
      iconData: iconData,
    ),
    TThemeMode.light => Builder(
      builder: (context) {
        final color = bgColor ?? context.colors.cardMidground;
        return Container(
          child: TIconSmall.small(iconData, color: color.onColor),
          width: size ?? TColorContainerType.icon.height,
          height: size ?? TColorContainerType.icon.height,
          decoration: BoxDecoration(
            color: color.withReactiveHover(isHovered: isHovered),
            border: Border.all(
              color: borderColor ?? context.colors.border,
              width: 1,
            ),
            borderRadius: borderRadius,
          ),
        );
      },
    ),
  };
}
