import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Enum representing the different authentication view modes.
enum AuthViewMode {
  /// Login mode - user can sign in with email and password.
  login,

  /// Register mode - user can create a new account.
  register,

  /// Forgot password mode - user can request a password reset.
  forgotPassword;

  /// Default authentication view mode.
  static const defaultValue = AuthViewMode.login;

  /// Returns true if the current mode is login.
  bool get isLogin => this == AuthViewMode.login;

  /// Returns true if the current mode is register.
  bool get isRegister => this == AuthViewMode.register;

  /// Returns true if the current mode is forgot password.
  bool get isForgotPassword => this == AuthViewMode.forgotPassword;
}

/// State for a form field with generic value type.
class TurboFormFieldState<T> {
  /// Creates a form field state.
  const TurboFormFieldState({
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.value,
    this.obscureText = false,
  });

  /// Text editing controller for the field.
  final TextEditingController controller;

  /// Focus node for the field.
  final FocusNode focusNode;

  /// Error text to display if validation fails.
  final String? errorText;

  /// Current value of the field.
  final T? value;

  /// Whether the field text should be obscured (e.g., for passwords).
  final bool obscureText;
}

/// Abstract interface for authentication view models.
///
/// Implement this interface in your view model to use [TurboAuthView].
/// The view model should provide all necessary state and callbacks
/// for the authentication flow.
abstract class TurboAuthViewModel {
  /// Current authentication view mode.
  ValueListenable<AuthViewMode> get authViewMode;

  /// Email field state.
  ValueListenable<TurboFormFieldState<String>> get emailField;

  /// Password field state.
  ValueListenable<TurboFormFieldState<String>> get passwordField;

  /// Confirm password field state (nullable, used in register mode).
  ValueListenable<TurboFormFieldState<String>>? get confirmPasswordField;

  /// Privacy agreement checkbox state (nullable, used in register mode).
  ValueListenable<TurboFormFieldState<bool>>? get agreePrivacyField;

  /// Focus node for the login button.
  FocusNode get loginButtonFocusNode;

  /// Focus node for the register button.
  FocusNode get registerButtonFocusNode;

  /// Focus node for the send forgot password button.
  FocusNode get sendForgotPasswordFocusNode;

  /// Called when the email field is submitted.
  void onEmailSubmitted(BuildContext context);

  /// Called when the password field is submitted.
  ///
  /// [value] is the current password value.
  void onPasswordSubmitted(String value, BuildContext context);

  /// Called when the confirm password field is submitted.
  ///
  /// [value] is the current confirm password value.
  void onConfirmPasswordSubmitted(String? value);

  /// Called when the login button is pressed.
  ///
  /// [authViewMode] is the current authentication view mode.
  void onLoginPressed(AuthViewMode authViewMode, BuildContext context);

  /// Called when the register button is pressed.
  ///
  /// [authViewMode] is the current authentication view mode.
  void onRegisterPressed(AuthViewMode authViewMode, BuildContext context);

  /// Called when the forgot password link is pressed.
  void onForgotPasswordPressed();

  /// Called when the send reset email button is pressed.
  void onForgotPasswordSendPressed(BuildContext context);

  /// Called when the email field value changes.
  ///
  /// [value] is the new email value.
  void onEmailChanged(String value);

  /// Called when the password field value changes.
  ///
  /// [value] is the new password value.
  void onPasswordChanged(String value);

  /// Called when the confirm password field value changes.
  ///
  /// [value] is the new confirm password value.
  void onConfirmPasswordChanged(String value);

  /// Called when the privacy agreement checkbox value changes.
  ///
  /// [value] is the new checkbox value.
  void onAgreePrivacyChanged(bool value);
}
