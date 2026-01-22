import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_button.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class ContextualNavButton extends StatelessWidget {
  const ContextualNavButton({
    required this.deviceType,
    required this.config,
    super.key,
  });

  final TButtonConfig config;
  final TDeviceType deviceType;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: config.tooltip,
    child: TButton(
      onPressed: config.onPressed,
      label: deviceType.showButtonLabel ? config.label : null,
      tooltip: config.tooltip,
      child: ShadIconButton.outline(
        icon: Icon(config.icon),
        onPressed: config.onPressed,
      ),
    ),
  );
}
