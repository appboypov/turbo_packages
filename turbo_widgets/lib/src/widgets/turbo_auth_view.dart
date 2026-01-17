import 'package:flutter/material.dart';
import 'turbo_auth_view_model.dart';

/// A reusable stateless authentication view widget.
///
/// This widget provides a complete authentication UI that supports:
/// - Login mode
/// - Registration mode
/// - Forgot password mode
///
/// The widget accepts a [TurboAuthViewModel] interface that provides
/// all necessary state and callbacks. This makes it framework-agnostic
/// and reusable across different projects.
class TurboAuthView extends StatelessWidget {
  /// Creates an authentication view.
  const TurboAuthView({
    super.key,
    required this.viewModel,
    this.backgroundColor,
    this.maxWidth = 400.0,
    this.padding = const EdgeInsets.all(24),
  });

  /// The view model that provides state and handles callbacks.
  final TurboAuthViewModel viewModel;

  /// Background color for the scaffold.
  ///
  /// If null, uses the theme's scaffold background color.
  final Color? backgroundColor;

  /// Maximum width constraint for the form.
  final double maxWidth;

  /// Padding around the form content.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      body: ValueListenableBuilder<AuthViewMode>(
        valueListenable: viewModel.authViewMode,
        builder: (context, authViewMode, child) => Center(
          child: SingleChildScrollView(
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(context, authViewMode),
                  const SizedBox(height: 8),
                  _buildSubtitle(context, authViewMode),
                  const SizedBox(height: 32),
                  _buildEmailField(context, authViewMode),
                  _buildPasswordSection(context, authViewMode),
                  _buildRegisterSection(context, authViewMode),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, authViewMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, AuthViewMode authViewMode) {
    final theme = Theme.of(context);
    return Text(
      authViewMode.isForgotPassword
          ? 'Forgot Password'
          : authViewMode.isLogin
              ? 'Welcome'
              : 'Welcome',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, AuthViewMode authViewMode) {
    final theme = Theme.of(context);
    final subtitle = switch (authViewMode) {
      AuthViewMode.login => 'Please log in to continue',
      AuthViewMode.register => 'Please register to continue',
      AuthViewMode.forgotPassword => 'Please enter your email',
    };
    return Text(
      subtitle,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, AuthViewMode authViewMode) {
    return ValueListenableBuilder<TurboFormFieldState<String>>(
      valueListenable: viewModel.emailField,
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: state.controller,
            focusNode: state.focusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: state.errorText,
            ),
            onSubmitted: (_) => viewModel.onEmailSubmitted(context),
            onChanged: viewModel.onEmailChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection(
    BuildContext context,
    AuthViewMode authViewMode,
  ) {
    if (authViewMode.isForgotPassword) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        _buildPasswordField(context, authViewMode),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context, AuthViewMode authViewMode) {
    return ValueListenableBuilder<TurboFormFieldState<String>>(
      valueListenable: viewModel.passwordField,
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: state.controller,
            focusNode: state.focusNode,
            obscureText: state.obscureText,
            textInputAction: authViewMode.isLogin
                ? TextInputAction.done
                : TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: state.errorText,
            ),
            onSubmitted: (value) =>
                viewModel.onPasswordSubmitted(value, context),
            onChanged: viewModel.onPasswordChanged,
          ),
          if (authViewMode.isLogin) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: viewModel.onForgotPasswordPressed,
                child: const Text('Forgot password?'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegisterSection(
    BuildContext context,
    AuthViewMode authViewMode,
  ) {
    if (!authViewMode.isRegister) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        _buildConfirmPasswordField(context),
        const SizedBox(height: 16),
        _buildAgreePrivacyField(context),
      ],
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    final confirmPasswordField = viewModel.confirmPasswordField;
    if (confirmPasswordField == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<TurboFormFieldState<String>>(
      valueListenable: confirmPasswordField,
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: state.controller,
            focusNode: state.focusNode,
            obscureText: state.obscureText,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              errorText: state.errorText,
            ),
            onSubmitted: viewModel.onConfirmPasswordSubmitted,
            onChanged: viewModel.onConfirmPasswordChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAgreePrivacyField(BuildContext context) {
    final agreePrivacyField = viewModel.agreePrivacyField;
    if (agreePrivacyField == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return ValueListenableBuilder<TurboFormFieldState<bool>>(
      valueListenable: agreePrivacyField,
      builder: (context, state, child) => Row(
        children: [
          Checkbox(
            value: state.value ?? false,
            onChanged: (value) {
              if (value != null) {
                viewModel.onAgreePrivacyChanged(value);
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                viewModel.onAgreePrivacyChanged(!(state.value ?? false));
              },
              child: Text(
                'I agree to the privacy policy and terms of service',
                style: TextStyle(
                  color: state.errorText != null
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AuthViewMode authViewMode,
  ) {
    if (authViewMode.isForgotPassword) {
      return _buildSendButton(context);
    }

    return Column(
      children: [
        _buildLoginButton(context, authViewMode),
        if (authViewMode.isLogin) const SizedBox(height: 12),
        _buildRegisterButton(context, authViewMode),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthViewMode authViewMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            viewModel.onLoginPressed(authViewMode, context),
        focusNode: viewModel.loginButtonFocusNode,
        child: Text(authViewMode.isForgotPassword ? 'Back' : 'Login'),
      ),
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    AuthViewMode authViewMode,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () =>
            viewModel.onRegisterPressed(authViewMode, context),
        focusNode: viewModel.registerButtonFocusNode,
        child: Text(
          authViewMode.isRegister
              ? 'Already have an account? Login'
              : 'Register',
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => viewModel.onForgotPasswordSendPressed(context),
        focusNode: viewModel.sendForgotPasswordFocusNode,
        child: const Text('Send Reset Email'),
      ),
    );
  }
}
