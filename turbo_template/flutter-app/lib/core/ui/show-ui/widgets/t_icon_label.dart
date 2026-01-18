import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/color_extension.dart';

class TIconLabel extends StatelessWidget {
  const TIconLabel({
    Key? key,
    required this.iconData,
    required this.size,
    required this.text,
    required this.textStyle,
  }) : super(key: key);

  final IconData? iconData;
  final double size;
  final String text;
  final TextStyle textStyle;

  factory TIconLabel.forCard({
    Key? key,
    required IconData icon,
    required String text,
    required BuildContext context,
  }) => TIconLabel(key: key, iconData: icon, size: 16, text: text, textStyle: context.texts.list);

  factory TIconLabel.forFormField({
    Key? key,
    required IconData? icon,
    required String text,
    required BuildContext context,
  }) => TIconLabel(key: key, iconData: icon, size: 14, text: text, textStyle: context.texts.small);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (iconData != null) ...[
        Icon(iconData, size: size, color: context.colors.icon),
        const Gap(8),
      ],
      Text(
        text,
        style: textStyle.copyWith(
          color: context.colors.background.onColor,
        ),
      ),
    ],
  );
}
