import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_device_type.dart';
import 'package:turbo_flutter_template/core/ui/models/contextual_button_model.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_button.dart';

class ContextualNavButton extends StatelessWidget {
  const ContextualNavButton({
    required this.deviceType,
    required this.model,
    super.key,
  });

  final ContextualButtonModel model;
  final TDeviceType deviceType;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: model.tooltip,
    child: TButton(
      onPressed: model.onPressed,
      label: deviceType.showButtonLabel ? model.label : null,
      tooltip: model.tooltip,
      child: ShadIconButton.outline(
        icon: Icon(model.icon),
      ),
    ),
  );
}
