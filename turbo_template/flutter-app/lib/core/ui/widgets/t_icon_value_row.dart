import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/models/icon_value_model.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_row.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_flex.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon.dart';

enum TIconValueUseCase { listItem, button }

class TIconValueRow extends StatelessWidget {
  const TIconValueRow({
    Key? key,
    required this.iconValueModel,
    required this.useCase,
    this.spacing = TFlex.spacingDefault,
    this.isHovered = false,
    this.onColorSource,
  }) : super(key: key);

  final IconValueModel iconValueModel;
  final TIconValueUseCase useCase;
  final double spacing;
  final bool isHovered;
  final Color? onColorSource;

  @override
  Widget build(BuildContext context) {
    final text = switch (useCase) {
      TIconValueUseCase.listItem => Text(
        iconValueModel.value,
        style: context.texts.list.copyWith(height: 1),
      ),
      TIconValueUseCase.button => Text(
        iconValueModel.value,
        style: context.texts.button.copyWith(height: 1),
      ),
    };
    final rightPadding = switch (useCase) {
      TIconValueUseCase.listItem => 0.0,
      TIconValueUseCase.button => 4.0,
    };

    final iconRow = TRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: spacing,
      children: [
        TIconSmall.small(iconValueModel.iconData, color: context.colors.icon),
        Padding(
          padding: EdgeInsets.only(right: rightPadding),
          child: text,
        ),
      ],
    );

    final onPressed = iconValueModel.onPressed;
    final ignoreButton = onPressed == null;
    if (ignoreButton) {
      return iconRow;
    }
    return GestureDetector(
      onTap: () => onPressed(iconValueModel.value),
      child: iconRow,
    );
  }
}
