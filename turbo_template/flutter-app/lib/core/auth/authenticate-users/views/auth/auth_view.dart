import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/enums/auth_view_mode.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/views/auth/auth_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/constants/routes.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/extensions/animation_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/t_animated_gap.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/t_animated_text.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/vertical_shrink.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/k_widgets.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/config/t_form_field_config.dart';
import 'package:veto/veto.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  static const String path = Routes.auth;

  @override
  Widget build(BuildContext context) => ViewModelBuilder<AuthViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) return kWidgetsNothing;

      return Scaffold(
        backgroundColor: context.colors.background,
        body: ValueListenableBuilder<AuthViewMode>(
          valueListenable: model.authViewMode,
          builder: (context, authViewMode, child) => Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TAnimatedText(
                      text: authViewMode.isForgotPassword
                          ? 'Forgot Password'
                          : authViewMode.isLogin
                          ? 'Welcome'
                          : 'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(switch (authViewMode) {
                      AuthViewMode.login => 'Please log in to continue',
                      AuthViewMode.register => 'Please register to continue',
                      AuthViewMode.forgotPassword => 'Please enter your email',
                    }, style: TextStyle(color: context.colors.mutedForeground),),
                    const SizedBox(height: 32),
                    _buildEmailField(context, model, authViewMode),
                    VerticalShrink(
                      show: !authViewMode.isForgotPassword,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildPasswordField(context, model, authViewMode),
                        ],
                      ),
                    ),
                    VerticalShrink(
                      show: authViewMode.isRegister,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildConfirmPasswordField(context, model),
                          const SizedBox(height: 16),
                          _buildAgreePrivacyField(context, model),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    VerticalShrink(
                      show: authViewMode.isForgotPassword,
                      child: _buildSendButton(context, model),
                    ),
                    VerticalShrink(
                      show: !authViewMode.isForgotPassword,
                      child: Column(
                        children: [
                          _buildLoginButton(context, model, authViewMode),
                          TAnimatedGap(authViewMode.isLogin ? 12 : 0),
                          _buildRegisterButton(context, model, authViewMode),
                        ],
                      ),
                    ),
                  ],
                ).slideBottomUpWithFade(),
              ),
            ),
          ),
        ),
      );
    },
    viewModelBuilder: () => AuthViewModel.locate,
  );

  Widget _buildEmailField(BuildContext context, AuthViewModel model, AuthViewMode authViewMode) {
    final emailField = model.emailField;
    return ValueListenableBuilder<TFormFieldState<String>>(
      valueListenable: emailField,
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShadInput(
            placeholder: const Text('Email'),
            controller: emailField.textEditingController,
            focusNode: emailField.focusNode,
            onSubmitted: (_) => model.onEmailSubmitted(context: context),
            onChanged: (value) => emailField.silentUpdateValue(value),
          ),
          if (state.errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              state.errorText!,
              style: TextStyle(color: context.colors.destructive, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context, AuthViewModel model, AuthViewMode authViewMode) {
    final passwordField = model.passwordField;
    return ValueListenableBuilder<TFormFieldState<String>>(
      valueListenable: passwordField,
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShadInput(
            placeholder: const Text('Password'),
            obscureText: true,
            controller: passwordField.textEditingController,
            focusNode: passwordField.focusNode,
            onSubmitted: (value) => model.onPasswordSubmitted(value: value, context: context),
            onChanged: (value) => passwordField.silentUpdateValue(value),
          ),
          if (state.errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              state.errorText!,
              style: TextStyle(color: context.colors.destructive, fontSize: 12),
            ),
          ],
          if (authViewMode.isLogin) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ShadButton.ghost(
                onPressed: model.onForgotPasswordPressed,
                child: const Text('Forgot password?'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, AuthViewModel model) {
    final confirmPasswordField = model.confirmPasswordField;
    return ValueListenableBuilder<TFormFieldState<String>>(
      valueListenable: confirmPasswordField,
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShadInput(
            placeholder: const Text('Confirm Password'),
            obscureText: true,
            controller: confirmPasswordField.textEditingController,
            focusNode: confirmPasswordField.focusNode,
            onSubmitted: model.onConfirmPasswordSubmitted,
            onChanged: (value) => confirmPasswordField.silentUpdateValue(value),
          ),
          if (state.errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              state.errorText!,
              style: TextStyle(color: context.colors.destructive, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgreePrivacyField(BuildContext context, AuthViewModel model) {
    final agreePrivacyField = model.agreePrivacyField;
    return ValueListenableBuilder<TFormFieldState<bool>>(
      valueListenable: agreePrivacyField,
      builder: (context, state, child) => Row(
        children: [
          ShadCheckbox(
            value: state.value ?? false,
            onChanged: (value) => agreePrivacyField.silentUpdateValue(value),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => agreePrivacyField.silentUpdateValue(!(state.value ?? false)),
              child: Text(
                'I agree to the privacy policy and terms of service',
                style: TextStyle(
                  color: state.errorText != null
                      ? context.colors.destructive
                      : context.colors.foreground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthViewModel model, AuthViewMode authViewMode) {
    return ShadButton(
      width: double.infinity,
      onPressed: authViewMode.isForgotPassword
          ? () => model.onLoginPressed(authViewMode: authViewMode, context: context)
          : () => model.onLoginPressed(authViewMode: authViewMode, context: context),
      focusNode: model.loginButtonFocusNode,
      child: Text(authViewMode.isForgotPassword ? 'Back' : 'Login'),
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    AuthViewModel model,
    AuthViewMode authViewMode,
  ) {
    return ShadButton.ghost(
      width: double.infinity,
      onPressed: () => model.onRegisterPressed(authViewMode: authViewMode, context: context),
      focusNode: model.registerButtonFocusNode,
      child: Text(authViewMode.isRegister ? 'Already have an account? Login' : 'Register'),
    );
  }

  Widget _buildSendButton(BuildContext context, AuthViewModel model) {
    return ShadButton(
      width: double.infinity,
      onPressed: () => model.onForgotPasswordSendPressed(context: context),
      focusNode: model.sendForgotPasswordFocusNode,
      child: const Text('Send Reset Email'),
    );
  }
}
