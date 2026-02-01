import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/l10n/globals/g_context.dart';
import 'package:turbo_flutter_template/core/l10n/globals/g_strings.dart';
import 'package:turbo_flutter_template/core/shared/extensions/duration_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/context_def.dart';
import 'package:turbo_flutter_template/core/ui/constants/spacings.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/dtos/icon_label_dto.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/widgets/dialog_constraints.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon_label.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ui/widgets/text_input_and_dropdown_sheet.dart';
import 'package:turbo_flutter_template/core/ux/utils/haptic_button_utils.dart';
import 'package:turbo_forms/turbo_forms.dart';
import 'package:turbolytics/turbolytics.dart';

class DialogService with Turbolytics {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static DialogService get locate => GetIt.I.get();
  static DialogService Function() get lazyLocate =>
      () => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(DialogService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  Future<void> _silentReset(TFormFieldConfig formFieldConfig) async {
    await TDurations.animation.asFuture;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => formFieldConfig.silentReset(),
    );
  }

  void _requestFocus(TFormFieldConfig<String> formFieldConfig) => WidgetsBinding
      .instance
      .addPostFrameCallback((_) => formFieldConfig.requestFocus());

  Future<bool?> showCustomDialog({
    BuildContext? context,
    String? title,
    String? message,
    String? cancelText,
    String? okButtonText,
    WidgetBuilder? content,
    WidgetBuilder? builder,
    VoidCallback? onOkButtonPressed,
    VoidCallback? onCancelPressed,
    VoidCallback? onClosePressed,
    List<Widget>? actions,
    // Dialog Method Parameters
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    // Dialog Parameters
    ShadPosition? closeIconPosition,
    BorderRadius? radius,
    Color? backgroundColor,
    bool? expandActionsWhenTiny,
    EdgeInsets? padding,
    double? gap,
    BoxConstraints? constraints,
    BoxBorder? border,
    List<BoxShadow>? shadows,
    bool? removeBorderRadiusWhenTiny,
    Axis actionsAxis = Axis.horizontal,
    MainAxisSize? actionsMainAxisSize,
    MainAxisAlignment? actionsMainAxisAlignment,
    VerticalDirection? actionsVerticalDirection,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextAlign? titleTextAlign,
    TextAlign? descriptionTextAlign,
    Alignment? alignment,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    bool? scrollable,
    EdgeInsets? scrollPadding,
  }) async {
    final pContext = context ?? gContext;
    if (pContext == null) {
      log.warning('Context is null, cannot show dialog');
      return null;
    }

    return showDialog<bool?>(
      context: pContext,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
      builder: builder != null
          ? (context) => DialogConstraints(child: builder(context))
          : (context) => DialogConstraints(
              child: ShadDialog(
                title: title == null ? null : Text(title),
                child: content?.call(context),
                constraints: constraints,
                padding: padding,
                gap: gap,
                scrollable: scrollable,
                scrollPadding: scrollPadding,
                backgroundColor: backgroundColor,
                border: border,
                radius: radius,
                shadows: shadows,
                removeBorderRadiusWhenTiny: removeBorderRadiusWhenTiny,
                description: message == null
                    ? null
                    : Text(message, style: context.texts.muted),
                crossAxisAlignment: crossAxisAlignment,
                actionsAxis: actionsAxis,
                actionsMainAxisAlignment: actionsMainAxisAlignment,
                actionsMainAxisSize: actionsMainAxisSize,
                actionsVerticalDirection: actionsVerticalDirection,
                expandActionsWhenTiny: expandActionsWhenTiny,
                titleStyle: titleStyle,
                descriptionStyle: descriptionStyle,
                titleTextAlign: titleTextAlign,
                descriptionTextAlign: descriptionTextAlign,
                alignment: alignment,
                mainAxisAlignment: mainAxisAlignment,
                closeIcon: TButton(
                  child: TMargin(
                    top: 16,
                    right: 16,
                    left: 16,
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: context.colors.icon,
                    ),
                  ),
                  onPressed: onClosePressed ?? () => pContext.pop(),
                ),
                closeIconPosition: closeIconPosition,
                actions: [
                  if (actions != null) ...actions,
                  if (onCancelPressed != null)
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: withLightHaptic(() => onCancelPressed()),
                        child: Text(cancelText ?? context.strings.cancel),
                      ),
                    ),
                  if (onOkButtonPressed != null)
                    Expanded(
                      child: ShadButton(
                        onPressed: withMediumHaptic(() {
                          onOkButtonPressed();
                        }),
                        child: Text(okButtonText ?? context.strings.ok),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<bool?> showOkDialog({
    String? okText,
    required BuildContext? context,
    required String title,
    required String message,
  }) async {
    final pContext = context ?? gContext;
    if (pContext == null) {
      log.warning('Context is null, cannot show dialog');
      return null;
    }
    final strings = context?.strings ?? gStrings;
    return showCustomDialog(
      title: title,
      message: message,
      context: pContext,
      onOkButtonPressed: () => pContext.pop(true),
      onClosePressed: () => pContext.pop(),
      okButtonText: okText ?? strings.ok,
    );
  }

  Future<bool?> showOkCancelDialog({
    String? cancelText,
    String? okText,
    required BuildContext? context,
    required String title,
    required String message,
  }) async {
    final pContext = context ?? gContext;
    if (pContext == null) {
      log.warning('Context is null, cannot show dialog');
      return null;
    }
    final strings = context?.strings ?? gStrings;
    return showCustomDialog(
      context: pContext,
      title: title,
      message: message,
      okButtonText: okText ?? strings.ok,
      cancelText: cancelText ?? strings.cancel,
      onClosePressed: () => pContext.pop(),
      onOkButtonPressed: () => pContext.pop(true),
      onCancelPressed: () => pContext.pop(false),
    );
  }

  Future<void> showSomethingWentWrongDialog({
    required BuildContext? context,
  }) async {
    final strings = context?.strings ?? gStrings;
    await showOkDialog(
      context: context,
      title: strings.somethingWentWrong,
      message: strings.somethingWentWrongPleaseTryAgainLater,
    );
  }

  Future<void> showUnknownErrorDialog({required BuildContext? context}) async {
    final strings = context?.strings ?? gStrings;
    await showOkDialog(
      context: context,
      title: strings.unknownError,
      message: strings.anUnknownErrorOccurredPleaseTryAgainLater,
    );
  }

  Future<void> showTextInputDialog({
    required TFormFieldConfig<String> formFieldConfig,
    required IconData leadingIcon,
    required BuildContext context,
    required ContextDef onOkButtonPressed,
    ContextDef? onClosePressed,
    required String title,
    required String message,
    required String okButtonText,
    required IconLabelDto iconLabelDto,
    required String formFieldHint,
  }) async {
    _requestFocus(formFieldConfig);
    await showCustomDialog(
      context: context,
      title: title,
      message: message,
      okButtonText: okButtonText,
      gap: Spacings.labelGap,
      onOkButtonPressed: () => onOkButtonPressed(context),
      onClosePressed: onClosePressed == null
          ? null
          : () {
              context.tryPop();
              onClosePressed(context);
            },
      content: (context) => TFormField<String>(
        formFieldConfig: formFieldConfig,
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
          enabled: config.isEnabled && !config.isReadOnly,
          placeholder: Text(formFieldHint),
          onSubmitted: (_) => onOkButtonPressed(context),
          controller: config.textEditingController,
          initialValue: config.initialValue,
          readOnly: config.isReadOnly,
          onChanged: (value) => config.silentUpdateValue(value),
          focusNode: config.focusNode,
        ),
      ),
    );
    unawaited(_silentReset(formFieldConfig));
  }

  Future<void> showTextAreaInputDialog({
    required TFormFieldConfig<String> formFieldConfig,
    required BuildContext context,
    required ContextDef onOkButtonPressed,
    required ContextDef? onClosePressed,
    required String title,
    required String message,
    required String okButtonText,
    required IconLabelDto iconLabelDto,
    required String formFieldHint,
    required IconData leadingIcon,
    int minLines = 3,
    int maxLines = 6,
  }) async {
    _requestFocus(formFieldConfig);
    await showCustomDialog(
      context: context,
      title: title,
      message: message,
      okButtonText: okButtonText,
      gap: Spacings.labelGap,
      onOkButtonPressed: () => onOkButtonPressed(context),
      onClosePressed: onClosePressed == null
          ? null
          : () {
              context.tryPop();
              onClosePressed(context);
            },
      content: (context) => TFormField<String>(
        formFieldConfig: formFieldConfig,
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
          minLines: minLines,
          maxLines: maxLines,
          enabled: config.isEnabled && !config.isReadOnly,
          placeholder: Text(formFieldHint),
          onSubmitted: (_) => onOkButtonPressed(context),
          controller: config.textEditingController,
          initialValue: config.initialValue,
          readOnly: config.isReadOnly,
          onChanged: (value) => config.silentUpdateValue(value),
          focusNode: config.focusNode,
        ),
      ),
    );
    unawaited(_silentReset(formFieldConfig));
  }

  Future<void> showTextInputAndDropdownDialog<T>({
    required TFormFieldConfig<String> textInputConfig,
    required TFormFieldConfig<T> formFieldConfig,
    required BuildContext context,
    required ContextDef onOkButtonPressed,
    ContextDef? onClosePressed,
    required String title,
    required String message,
    required String okButtonText,
    required IconLabelDto iconLabelDto,
    required String formFieldHint,
    required String dropdownLabel,
    required String dropdownPlaceholder,
    required IconData leadingIcon,
    String Function(T)? itemLabelBuilder,
  }) async {
    _requestFocus(textInputConfig);
    await showCustomDialog(
      context: context,
      message: message,
      okButtonText: okButtonText,
      gap: Spacings.labelGap,
      onOkButtonPressed: () => onOkButtonPressed(context),
      onClosePressed: onClosePressed == null
          ? null
          : () {
              context.tryPop();
              onClosePressed(context);
            },
      title: title,
      content: (context) => TextInputAndDropdownSheet<T>(
        leadingIcon: leadingIcon,
        iconLabelDto: iconLabelDto,
        textFieldHint: formFieldHint,
        dropdownLabel: dropdownLabel,
        dropdownPlaceholder: dropdownPlaceholder,
        onOkButtonPressed: onOkButtonPressed,
        textInputConfig: textInputConfig,
        dropdownConfig: formFieldConfig,
        itemLabelBuilder: itemLabelBuilder,
      ),
    );
    unawaited(_silentReset(formFieldConfig));
  }
}
