import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/dtos/icon_label_dto.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_icon_label.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/config/t_form_field_config.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/typedefs/t_form_field_builder_def.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/widgets/t_error_label.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/widgets/t_form_field_builder.dart';

class TFormField<T> extends StatelessWidget {
  const TFormField({
    super.key,
    required this.builder,
    required this.formFieldConfig,
    this.child,
    this.errorPadding,
    this.iconLabelDto,
    this.description,
    this.labelTrailing,
    this.horizontalPadding,
  });

  final IconLabelDto? iconLabelDto;
  final String? description;
  final Widget? labelTrailing;
  final TFormFieldBuilderDef<T> builder;
  final TFormFieldConfig<T> formFieldConfig;
  final Widget? child;
  final EdgeInsets? errorPadding;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: formFieldConfig,
    builder: (context, listenableChild) {
      return StatelessTFormField(
        horizontalPadding: horizontalPadding,
        label: iconLabelDto,
        description: description,
        labelTrailing: labelTrailing,
        errorPadding: errorPadding,
        errorText: formFieldConfig.errorText,
        shouldValidate: formFieldConfig.shouldValidate,
        isEnabled: formFieldConfig.isEnabled,
        isReadOnly: formFieldConfig.isReadOnly,
        formFieldContent: TFormFieldBuilder(
          fieldConfig: formFieldConfig,
          builder: builder,
          child: child,
        ),
      );
    },
  );
}

class StatelessTFormField extends StatelessWidget {
  const StatelessTFormField({
    super.key,
    this.label,
    this.description,
    this.labelTrailing,
    this.errorPadding,
    this.errorText,
    required this.shouldValidate,
    required this.isEnabled,
    required this.isReadOnly,
    required this.formFieldContent,
    this.horizontalPadding,
  });

  final IconLabelDto? label;
  final String? description;
  final Widget? labelTrailing;
  final EdgeInsets? errorPadding;
  final String? errorText;
  final bool shouldValidate;
  final bool isEnabled;
  final bool isReadOnly;
  final Widget formFieldContent;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final formFieldSubLabelStyle = context.texts.muted;
    final subLabel = description;

    return AnimatedOpacity(
      duration: TDurations.animation,
      opacity: isEnabled ? 1 : TSizes.opacityDisabled,
      child: IgnorePointer(
        ignoring: !isEnabled || isReadOnly,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (label != null || subLabel != null || labelTrailing != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (horizontalPadding != null) TGap(horizontalPadding!),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (label != null)
                          TIconLabel.forFormField(
                            icon: label!.icon,
                            context: context,
                            text: label!.label,
                          ),
                        if (subLabel == null)
                          const Gap(4)
                        else ...[
                          if (label != null) const Gap(4),
                          Text(subLabel, style: formFieldSubLabelStyle),
                        ],
                      ],
                    ),
                  ),
                  if (labelTrailing != null) ...[
                    if (label != null || subLabel != null) const Gap(8),
                    labelTrailing!,
                    const Gap(8),
                  ],
                  if (horizontalPadding != null) TGap(horizontalPadding!),
                ],
              ),
              const Gap(6),
            ],
            formFieldContent,
            TErrorLabel(
              errorText: errorText,
              shouldValidate: shouldValidate,
              padding: errorPadding,
            ),
          ],
        ),
      ),
    );
  }
}
