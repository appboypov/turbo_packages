import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/config/t_icon_vars.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_button.dart';
import 'package:roomy_mobile/ui/widgets/t_fancy_icon_container.dart';

class TFancyIconButton extends StatelessWidget {
  const TFancyIconButton({
    Key? key,
    required this.tBapIconButton,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.size,
    this.borderColor,
  }) : super(key: key);

  final TIconButtonVars tBapIconButton;
  final BorderRadius borderRadius;
  final double? size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => TButton(
    width: size,
    height: size,
    onPressed: tBapIconButton.onPressed,
    hoverBuilder: (context, isHovered, child) => TFancyIconContainer(
      borderRadius: borderRadius,
      borderColor: borderColor,
      iconData: tBapIconButton.iconData,
      bgColor: tBapIconButton.iconColor,
      size: size,
      isHovered: isHovered,
    ),
  );
}
