import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/enums/auth_view_mode.dart';
import 'package:turbo_flutter_template/core/auth/widgets/accept_privacy_text.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/shrinks.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/t_animated_gap.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/dtos/icon_label_dto.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/icon_collection.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_card.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_constraints.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_focus_order.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_icon.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_logo.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_scaffold.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_scroll_view.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/widgets/t_form_field.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/utils/haptic_button_utils.dart';
import 'package:turbo_flutter_template/generated/assets.gen.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

import 'auth_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  static const String path = '';
  static const double _startupLogoWidth = 119;

  @override
  Widget build(BuildContext context) => TViewModelBuilder<AuthViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised)
        return TScaffold(
          backgroundColor: context.colors.background,
          showBackgroundPattern: true,
          child:
          Center(
            child: Image.asset(
              width: _startupLogoWidth,
              switch (context.themeMode) {
                TThemeMode.dark =>  const $AssetsPngsGen().logoDarkMode.path,
                TThemeMode.light => const $AssetsPngsGen().logoLightMode.path,
              },
            ),
          )
              .animate(onComplete: model.onComplete)
              .shimmer(
            color: Colors.white.withValues(alpha: 0.5),
            duration: TDurations.animationX4,
          ),
        );
      return TScaffold(
        backgroundColor: context.colors.background,
        showBackgroundPattern: true,
        child: ValueListenableBuilder(
          valueListenable: model.authViewMode,
          builder: (context, authViewMode, child) => Positioned.fill(
            child: Center(
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: TScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TMargin(
                        child: TConstraints(
                          maxWidth: TSizes.dialogMaxWidth,
                          child: TCard(
                            icon: Icons.diamond_rounded,
                            title: authViewMode.isForgotPassword
                                ? context.strings.forgotPassword
                                : switch (authViewMode) {
                              AuthViewMode.login => context.strings.welcome,
                              AuthViewMode.register => context.strings.welcome,
                              AuthViewMode.forgotPassword => context.strings.welcomeBack,
                            },
                            description: switch (authViewMode) {
                              AuthViewMode.login => context.strings.pleaseLogInToContinue,
                              AuthViewMode.register => context.strings.pleaseRegisterToContinue,
                              AuthViewMode.forgotPassword => context.strings.pleaseEnterYourEmail,
                            },
                            trailing: const SizedBox(height: 32, child: TLogo()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TFocusOrder(
                                  order: 1,
                                  child: ExcludeFocus(
                                    excluding: false,
                                    child: TFormField<String>(
                                      formFieldConfig: model.emailField,
                                      iconLabelDto: IconLabelDto(
                                        icon: IconCollection.email,
                                        label: context.strings.email,
                                      ),
                                      builder: (context, config, child) => Semantics(
                                        identifier: 'email_field',
                                        label: context.strings.emailInputFieldLabel,
                                        textField: true,
                                        child: ShadInput(
                                          placeholder: Text(
                                            context.strings.emailHint,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          leading: const TIconSmall(Icons.email_rounded),
                                          focusNode: model.emailField.focusNode,
                                          onSubmitted: (value) =>
                                              model.onEmailSubmitted(context: context),
                                          controller: config.textEditingController,
                                          onChanged: (value) => config.silentUpdateValue(value),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalShrink(
                                  show: !authViewMode.isForgotPassword,
                                  child: TMargin.only(
                                    top: TSizes.elementGap,
                                    child: TFocusOrder(
                                      order: 2,
                                      child: ExcludeFocus(
                                        excluding: authViewMode.isForgotPassword,
                                        child: TFormField<String>(
                                          formFieldConfig: model.passwordField,
                                          iconLabelDto: IconLabelDto(
                                            icon: IconCollection.password,
                                            label: context.strings.password,
                                          ),
                                          builder: (context, config, child) => Semantics(
                                            identifier: 'password_field',
                                            label: context.strings.passwordInputFieldLabel,
                                            textField: true,
                                            obscured: true,
                                            child: ShadInput(
                                              obscureText: true,
                                              placeholder: Text(
                                                context.strings.hiddenPass,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              leading: const TIconSmall(Icons.lock_rounded),
                                              focusNode: model.passwordField.focusNode,
                                              onSubmitted: (value) => model.onPasswordSubmitted(
                                                value: value,
                                                context: context,
                                              ),
                                              controller: config.textEditingController,
                                              onChanged: (value) => config.silentUpdateValue(value),
                                              trailing: AnimatedSwitcher(
                                                duration: TDurations.animation,
                                                child: authViewMode.isLogin
                                                    ? ExcludeFocus(
                                                  excluding: true,
                                                  child: ShadButton.ghost(
                                                    onPressed: model.onForgotPasswordPressed,
                                                    height: 16,
                                                    decoration: ShadDecoration(
                                                      border: ShadBorder(
                                                        radius: BorderRadius.circular(4),
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 8,
                                                    ),
                                                    child: Text(
                                                      context.strings.forgotPassword,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: context.colors.icon,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : const SizedBox.shrink(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TAnimatedGap(!authViewMode.isLogin ? TSizes.elementGap : 0),
                                VerticalShrink(
                                  show: authViewMode.isRegister,
                                  hideChild: const ExcludeFocus(child: Offstage()),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: TSizes.elementGap),
                                    child: Column(
                                      children: [
                                        TFocusOrder(
                                          order: authViewMode.isRegister ? 3 : null,
                                          child: ExcludeFocus(
                                            excluding: !authViewMode.isRegister,
                                            child: TFormField(
                                              formFieldConfig: model.confirmPasswordField,
                                              iconLabelDto: IconLabelDto(
                                                icon: IconCollection.confirmPassword,
                                                label: context.strings.confirmYourPassword,
                                              ),
                                              builder: (context, config, child) => Semantics(
                                                identifier: 'confirm_password_field',
                                                label: context.strings.confirmYourPassword,
                                                textField: true,
                                                obscured: true,
                                                child: ShadInput(
                                                  obscureText: true,
                                                  focusNode: model.confirmPasswordField.focusNode,
                                                  placeholder: Text(context.strings.hiddenPass),
                                                  leading: const TIconSmall(Icons.lock_rounded),
                                                  onSubmitted: model.onConfirmPasswordSubmitted,
                                                  controller: config.textEditingController,
                                                  onChanged: (value) {
                                                    config.silentUpdateValue(value);
                                                    model.onConfirmPasswordChanged(value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: model.showAgreeToPrivacyCheckBox,
                                          builder:
                                              (
                                              context,
                                              showAgreeToPrivacyCheckBox,
                                              child,
                                              ) => VerticalShrink(
                                            alignment: Alignment.bottomCenter,
                                            show: showAgreeToPrivacyCheckBox,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: TSizes.elementGap,
                                              ),
                                              child: TFormField<bool>(
                                                formFieldConfig: model.agreePrivacyField,
                                                builder: (context, config, child) => Semantics(
                                                  identifier: 'agree_privacy_checkbox',
                                                  label: context.strings.privacyPolicy,
                                                  button: true,
                                                  child: ShadCheckbox(
                                                    value: config.cValue ?? false,
                                                    onChanged: (value) =>
                                                        config.silentUpdateValue(value),
                                                    label: AcceptPrivacyText(
                                                      onPrivacyPolicyTap: () =>
                                                          model.onPrivacyPolicyPressed(
                                                            context: context,
                                                          ),
                                                      onTermsOfServiceTap: () =>
                                                          model.onTermsOfServicePressed(
                                                            context: context,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Column(
                                  children: [
                                    TAnimatedGap(authViewMode.isLogin ? TSizes.elementGap : 0),
                                    VerticalShrink(
                                      show: authViewMode.isForgotPassword,
                                      hideChild: const ExcludeFocus(child: Offstage()),
                                      child: TFocusOrder(
                                        order: 3,
                                        child: ExcludeFocus(
                                          excluding: !authViewMode.isForgotPassword,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: TSizes.elementGap,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Semantics(
                                                    identifier: 'send_reset_password_button',
                                                    label: context.strings.send,
                                                    button: true,
                                                    child: ShadButton(
                                                      child: Text(context.strings.send),
                                                      onPressed: withMediumHaptic(
                                                            () => model.onForgotPasswordSendPressed(
                                                          context: context,
                                                        ),
                                                      ),
                                                      focusNode: model.sendForgotPasswordFocusNode,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    VerticalShrink(
                                      show: !authViewMode.isRegister,
                                      hideChild: const ExcludeFocus(child: Offstage()),
                                      child: TFocusOrder(
                                        order: 3,
                                        child: ExcludeFocus(
                                          excluding: authViewMode.isRegister,
                                          child: Column(
                                            children: [
                                              Semantics(
                                                identifier: 'login_button',
                                                label: context.strings.loginButtonLabel,
                                                button: true,
                                                child: ShadButton(
                                                  width: double.infinity,
                                                  child: Text(context.strings.login),
                                                  onPressed: withMediumHaptic(
                                                        () => model.onLoginPressed(
                                                      authViewMode: authViewMode,
                                                      context: context,
                                                    ),
                                                  ),
                                                  focusNode: model.loginButtonFocusNode,
                                                ),
                                              ).butWhen(
                                                authViewMode.isForgotPassword,
                                                    (cValue) => ShadButton.ghost(
                                                  width: double.infinity,
                                                  child: Text(context.strings.back),
                                                  onPressed: () => model.onLoginPressed(
                                                    authViewMode: authViewMode,
                                                    context: context,
                                                  ),
                                                  focusNode: model.loginButtonFocusNode,
                                                ),
                                              ),
                                              Gap(switch (authViewMode) {
                                                AuthViewMode.login => TSizes.elementGap,
                                                AuthViewMode.register => 0,
                                                AuthViewMode.forgotPassword => 0,
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    VerticalShrink(
                                      show: !authViewMode.isForgotPassword,
                                      hideChild: const ExcludeFocus(child: Offstage()),
                                      child: TFocusOrder(
                                        order: 4,
                                        child: ExcludeFocus(
                                          excluding: authViewMode.isForgotPassword,
                                          child:
                                          Semantics(
                                            identifier: 'register_button',
                                            label: context.strings.registerButtonLabel,
                                            button: true,
                                            child: ShadButton.ghost(
                                              width: double.infinity,
                                              child: Text(context.strings.register),
                                              focusNode: model.registerButtonFocusNode,
                                              onPressed: () => model.onRegisterPressed(
                                                authViewMode: authViewMode,
                                                context: context,
                                              ),
                                            ),
                                          ).butWhen(
                                            authViewMode.isRegister,
                                                (cValue) => ShadButton(
                                              width: double.infinity,
                                              child: Text(context.strings.register),
                                              focusNode: model.registerButtonFocusNode,
                                              onPressed: () => model.onRegisterPressed(
                                                authViewMode: authViewMode,
                                                context: context,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalShrink(
                                  show: authViewMode.isRegister,
                                  alignment: Alignment.bottomCenter,
                                  hideChild: const ExcludeFocus(child: Offstage()),
                                  child: TMargin.only(
                                    top: TSizes.elementGap,
                                    child: TFocusOrder(
                                      order: 7,
                                      child: ExcludeFocus(
                                        excluding: !authViewMode.isRegister,
                                        child: Semantics(
                                          identifier: 'login_link_button',
                                          label: context.strings.switchToLoginLabel,
                                          button: true,
                                          child: ShadButton.ghost(
                                            width: double.infinity,
                                            child: Text(context.strings.login),
                                            onPressed: () => model.onLoginPressed(
                                              authViewMode: authViewMode,
                                              context: context,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
    viewModelBuilder: () => AuthViewModel.locate,
  );
}
