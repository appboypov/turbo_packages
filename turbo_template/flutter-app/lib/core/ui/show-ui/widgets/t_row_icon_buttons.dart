import 'package:flutter/material.dart';
import 'package:roomy_mobile/feedback/globals/g_vibrate.dart';
import 'package:roomy_mobile/ui/config/t_icon_vars.dart';
import 'package:roomy_mobile/ui/widgets/t_row.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TRowIconButtons extends StatelessWidget {
  const TRowIconButtons({Key? key, required this.buttons}) : super(key: key);

  final List<TIconButtonVars> buttons;

  @override
  Widget build(BuildContext context) => TRow(
    children: [
      for (final config in buttons) ...[
        ShadButton.outline(
          child: Icon(config.iconData),
          onPressed: () {
            gVibrateSelection(); // Selection vibration for icon buttons
            config.onPressed?.call();
          },
        ),
      ],
    ],
  );
}
