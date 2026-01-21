import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_color_container.dart';

class TColorButton extends StatelessWidget {
  const TColorButton({
    Key? key,
    this.label,
    required this.iconData,
    required this.onPressed,
    this.height,
    this.width,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  final String? label;
  final IconData iconData;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Color? color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => TButton(
    height: height,
    width: width,
    onPressed: onPressed,
    hoverBuilder: (context, isHovered, child) => TColorContainer(
      borderRadius: borderRadius,
      color: color?.withReactiveHover(isHovered: isHovered) ?? context.colors.icon,
      iconData: iconData,
      text: label,
      iconTextColor: (themeMode, theme) => context.colors.background.onColor,
    ),
  );
}
