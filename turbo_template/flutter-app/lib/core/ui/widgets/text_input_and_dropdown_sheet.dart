import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/context_def.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/dtos/icon_label_dto.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon_label.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_forms/turbo_forms.dart';

class TextInputAndDropdownSheet<T> extends StatelessWidget {
  const TextInputAndDropdownSheet({
    Key? key,
    required this.onOkButtonPressed,
    required this.textInputConfig,
    required this.dropdownConfig,
    required this.iconLabelDto,
    required this.textFieldHint,
    required this.dropdownLabel,
    required this.dropdownPlaceholder,
    this.itemLabelBuilder,
    required this.leadingIcon,
  }) : super(key: key);

  final ContextDef onOkButtonPressed;
  final TFormFieldConfig<String> textInputConfig;
  final TFormFieldConfig<T> dropdownConfig;

  final IconData leadingIcon;
  final IconLabelDto iconLabelDto;
  final String textFieldHint;
  final String dropdownLabel;
  final String dropdownPlaceholder;
  final String Function(T)? itemLabelBuilder;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TFormField(
        formFieldConfig: dropdownConfig,
        errorTextStyle: context.texts.smallDestructive,
        label: TIconLabel.forFormField(
          icon: iconLabelDto.icon,
          context: context,
          text: iconLabelDto.label,
        ),
        disabledOpacity: TSizes.opacityDisabled,
        animationDuration: TDurations.animation,
        builder: (context, config, child) {
          final itemCount = config.items?.length ?? 0;
          // Calculate height: ~40px per item + padding, max 5 items
          final maxHeight = (itemCount.clamp(1, 5) * 40.0) + 16.0;

          return ShadSelect<T>(
            placeholder: Text(dropdownPlaceholder),
            focusNode: config.focusNode,
            onChanged: config.silentUpdateValue,
            initialValue: config.initialValue,
            itemCount: itemCount,
            controller: config.selectController,
            enabled: config.isEnabled && !config.isReadOnly,
            maxHeight: maxHeight,
            optionsBuilder: (context, index) {
              final item = config.items![index];
              return ShadOption(
                value: item,
                child: Text(itemLabelBuilder?.call(item) ?? item.toString()),
              );
            },
            selectedOptionBuilder: (context, value) =>
                Text(itemLabelBuilder?.call(value) ?? value.toString()),
          );
        },
      ),
      const TGap.app(multiplier: 0.5),
      TFormField(
        formFieldConfig: textInputConfig,
        errorTextStyle: context.texts.smallDestructive,
        label: TIconLabel.forFormField(
          icon: iconLabelDto.icon,
          context: context,
          text: iconLabelDto.label,
        ),
        disabledOpacity: TSizes.opacityDisabled,
        animationDuration: TDurations.animation,
        builder: (context, config, child) => ShadInput(
          leading: TIconSmall(leadingIcon),
          placeholder: Text(textFieldHint),
          onSubmitted: (value) => onOkButtonPressed(context),
          controller: config.textEditingController,
          initialValue: config.initialValue,
          readOnly: config.isReadOnly,
          onChanged: (value) => config.silentUpdateValue(value),
          focusNode: config.focusNode,
          inputFormatters: config.inputFormatters,
        ),
      ),
    ],
  );
}
