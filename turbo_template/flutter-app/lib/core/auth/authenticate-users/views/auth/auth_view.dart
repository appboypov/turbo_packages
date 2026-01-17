import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/enums/auth_view_mode.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/views/auth/auth_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/constants/routes.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/t_animated_gap.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/t_animated_text.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/k_widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_sizes.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/config/t_form_field_config.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/widgets/t_form_field.dart';
import 'package:turbo_flutter_template/l10n/globals/g_strings.dart';
import 'package:turbo_mvvm/data/models/turbo_view_model.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  static const String path = Routes.auth;

  @override
  Widget build(BuildContext context) => TurboViewModelBuilder<AuthViewModel>(
        builder: (context, model, isInitialised, child) {
          if (!isInitialised) return TWidgets.nothing;
          return ValueListenableBuilder(
            valueListenable: model.authViewMode,
            builder: (context, authViewMode, child) => Column(
              children: [
                TMargin(
                  child: TConstraints(
                    maxWidth: TSizes.dialogMaxWidth,
                    child: Stack(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: model.authViewMode,
                          builder: (context, value, child) {
                            final strings = context.strings;
                            return ShadCard(
                              title: TMargin.right(
                                right: 40,
                                child: TAnimatedText(
                                  curve: Curves.easeInOut,
                                  duration: TDurations.animationX0p5,
                                  text: authViewMode.isForgotPassword
                                      ? strings.forgotPassword
                                      : switch (authViewMode) {
                                          AuthViewMode.login => strings.welcome,
                                          AuthViewMode.register => strings.welcome,
                                          AuthViewMode.forgotPassword => strings.welcomeBack,
                                        },
                                ),
                              ),
                              description: TMargin.right(
                                child: Text(
                                  switch (authViewMode) {
                                    AuthViewMode.login => 'Please login to continue',
                                    AuthViewMode.register => 'Please register to continue',
                                    AuthViewMode.forgotPassword => 'Forgot, I',
                                  },
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const TGap.section(),
                                  TFocusOrder(
                                    order: 1,
                                    child: ExcludeFocus(
                                      excluding: false,
                                      child: TFormField<String>(
                                        formFieldConfig: model.emailField,
                                        iconLabelDto: IconLabelDto(
                                          icon: IconCollection.email,
                                          label: strings.email,
                                        ),
                                        builder: (context, config, child) => ShadInput(
                                          placeholder: Text(
                                            strings.emailHint,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.texts.muted,
                                          ),
                                          focusNode: model.emailField.focusNode,
                                          onSubmitted: (value) =>
                                              model.onEmailSubmitted(context: context),
                                          controller: config.textEditingController,
                                          onChanged: (value) => config.silentUpdateValue(value),
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
                                              label: strings.password,
                                            ),
                                            builder: (context, config, child) => ShadInput(
                                              obscureText: true,
                                              placeholder: Text(
                                                strings.enterYourPassword,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.texts.muted,
                                              ),
                                              focusNode: model.passwordField.focusNode,
                                              onSubmitted: (value) => model.onPasswordSubmitted(
                                                value: value,
                                                context: context,
                                              ),
                                              controller: config.textEditingController,
                                              onChanged: (value) => config.silentUpdateValue(value),
                                              trailing: AnimatedSwitcher(
                                                duration: kDurationsAnimation,
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
                                                            'Forgot, I',
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
                                  TAnimatedGap(!authViewMode.isLogin ? TSizes.elementGap : 0),
                                  VerticalShrink(
                                    show: authViewMode.isRegister,
                                    hideChild: const ExcludeFocus(child: Offstage()),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: TSizes.elementGap,
                                      ),
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
                                                  label: strings.confirmYourPassword,
                                                ),
                                                builder: (context, config, child) => ShadInput(
                                                  obscureText: true,
                                                  focusNode: model.confirmPasswordField.focusNode,
                                                  placeholder: Text(
                                                    strings.confirmYourPassword,
                                                    style: context.texts.muted,
                                                  ),
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
                                          ValueListenableBuilder<bool>(
                                            valueListenable: model.showAgreeToPrivacyCheckBox,
                                            builder: (
                                              context,
                                              showAgreeToPrivacyCheckBox,
                                              child,
                                            ) =>
                                                VerticalShrink(
                                              alignment: Alignment.bottomCenter,
                                              show: showAgreeToPrivacyCheckBox,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: TSizes.elementGap,
                                                ),
                                                child: TFormField(
                                                  formFieldConfig: model.agreePrivacyField,
                                                  builder: (context, config, child) => ShadCheckbox(
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Column(
                                    children: [
                                      TAnimatedGap(
                                        authViewMode.isLogin ? TSizes.elementGap : 0,
                                      ),
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
                                                    child: ShadButton(
                                                      child: Text(strings.send),
                                                      onPressed: () =>
                                                          model.onForgotPasswordSendPressed(
                                                        context: context,
                                                      ),
                                                      focusNode: model.sendForgotPasswordFocusNode,
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
                                                ShadButton(
                                                  width: double.infinity,
                                                  child: Text(strings.login),
                                                  onPressed: () => model.onLoginPressed(
                                                    authViewMode: authViewMode,
                                                    context: context,
                                                  ),
                                                  focusNode: model.loginButtonFocusNode,
                                                ).butWhen(
                                                  authViewMode.isForgotPassword,
                                                  (cValue) => ShadButton.ghost(
                                                    width: double.infinity,
                                                    child: Text(strings.back),
                                                    onPressed: () => model.onLoginPressed(
                                                      authViewMode: authViewMode,
                                                      context: context,
                                                    ),
                                                    focusNode: model.loginButtonFocusNode,
                                                  ),
                                                ),
                                                Gap(
                                                  switch (authViewMode) {
                                                    AuthViewMode.login => TSizes.elementGap,
                                                    AuthViewMode.register => 0,
                                                    AuthViewMode.forgotPassword => 0,
                                                  },
                                                ),
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
                                            child: ShadButton.ghost(
                                              width: double.infinity,
                                              child: Text(
                                                strings.register,
                                              ),
                                              focusNode: model.registerButtonFocusNode,
                                              onPressed: () => model.onRegisterPressed(
                                                authViewMode: authViewMode,
                                                context: context,
                                              ),
                                            ).butWhen(
                                              authViewMode.isRegister,
                                              (cValue) => ShadButton(
                                                width: double.infinity,
                                                child: Text(
                                                  strings.register,
                                                ),
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
                                          child: ShadButton.ghost(
                                            width: double.infinity,
                                            child: Text(strings.login),
                                            onPressed: () => model.onLoginPressed(
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
                            );
                          },
                        ),
                        const Positioned(
                          top: 32,
                          right: 32,
                          child: TLogo(
                            path: 'assets/pngs/logo-3.png',
                            width: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        viewModelBuilder: () => AuthViewModel.locate,
      );
}
