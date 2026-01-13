import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:informers/informer.dart';
import 'package:loglytics/loglytics.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/enums/auth_view_mode.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/forms/forgot_password_form.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/forms/login_form.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/forms/register_form.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/auth_service.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/email_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/utils/mutex.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/config/t_form_field_config.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/toast_service.dart';
import 'package:veto/veto.dart';

class AuthViewModel extends BaseViewModel with Loglytics, BusyServiceManagement {
  AuthViewModel({
    required ToastService toastService,
    required EmailService emailService,
    required AuthService authService,
    required FirebaseAuth firebaseAuth,
    required LoginForm loginForm,
    required RegisterForm registerForm,
    required ForgotPasswordForm forgotPasswordForm,
  }) : _toastService = toastService,
       _emailService = emailService,
       _authService = authService,
       _firebaseAuth = firebaseAuth,
       _loginForm = loginForm,
       _registerForm = registerForm,
       _forgotPasswordForm = forgotPasswordForm;

  static AuthViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(
    () => AuthViewModel(
      toastService: ToastService.locate,
      emailService: EmailService.locate,
      authService: AuthService.locate,
      firebaseAuth: FirebaseAuth.instance,
      loginForm: LoginForm.locate,
      registerForm: RegisterForm.locate,
      forgotPasswordForm: ForgotPasswordForm.locate,
    ),
  );

  final ToastService _toastService;
  final EmailService _emailService;
  final AuthService _authService;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> initialise() async {
    await _authService.isReady;
    _authViewMode.addListener(_onAuthViewModeChanged);
    _onAuthViewModeChanged();
    super.initialise();
  }

  @override
  void dispose() {
    _authViewMode.removeListener(_onAuthViewModeChanged);
    loginButtonFocusNode.dispose();
    registerButtonFocusNode.dispose();
    sendForgotPasswordFocusNode.dispose();
    super.dispose();
  }

  final LoginForm _loginForm;
  final RegisterForm _registerForm;
  final ForgotPasswordForm _forgotPasswordForm;

  DateTime? _forgotPasswordAt;
  final FocusNode sendForgotPasswordFocusNode = FocusNode();
  final FocusNode loginButtonFocusNode = FocusNode();
  final FocusNode registerButtonFocusNode = FocusNode();
  final _authViewMode = Informer<AuthViewMode>(AuthViewMode.defaultValue);
  Timer? _resetPasswordTimer;
  bool _isResetPasswordCooldownActive = false;

  final _mutex = Mutex();
  static const _kResetPasswordCooldown = Duration(minutes: 1);

  int get _remainingSeconds => _forgotPasswordAt == null
      ? 0
      : _kResetPasswordCooldown.inSeconds - DateTime.now().difference(_forgotPasswordAt!).inSeconds;

  bool get isResetPasswordCooldownActive => _isResetPasswordCooldownActive;

  ValueListenable<AuthViewMode> get authViewMode => _authViewMode;

  TFormFieldConfig<String> get emailField {
    switch (_authViewMode.value) {
      case AuthViewMode.login:
        return _loginForm.email;
      case AuthViewMode.register:
        return _registerForm.email;
      case AuthViewMode.forgotPassword:
        return _forgotPasswordForm.email;
    }
  }

  TFormFieldConfig<String> get passwordField {
    switch (_authViewMode.value) {
      case AuthViewMode.login:
        return _loginForm.password;
      case AuthViewMode.register:
        return _registerForm.password;
      case AuthViewMode.forgotPassword:
        return _loginForm.password;
    }
  }

  TFormFieldConfig<String> get confirmPasswordField => _registerForm.confirmPassword;
  TFormFieldConfig<bool> get agreePrivacyField => _registerForm.agreePrivacy;

  void _updateAuthViewMode(AuthViewMode authViewMode) {
    FocusManager.instance.primaryFocus?.unfocus();
    _authViewMode.update(authViewMode);
  }

  void _restoreFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      switch (_authViewMode.value) {
        case AuthViewMode.login:
          if (_loginForm.email.valueTrimIsEmpty != null) {
            _loginForm.email.requestFocus();
          } else if (_loginForm.password.valueTrimIsEmpty != null) {
            _loginForm.password.requestFocus();
          } else {
            loginButtonFocusNode.requestFocus();
          }
          break;
        case AuthViewMode.register:
          if (_registerForm.email.valueTrimIsEmpty != null) {
            _registerForm.email.requestFocus();
          } else if (_registerForm.password.valueTrimIsEmpty != null) {
            _registerForm.password.requestFocus();
          } else if (_registerForm.confirmPassword.valueTrimIsEmpty != null) {
            _registerForm.confirmPassword.requestFocus();
          } else {
            registerButtonFocusNode.requestFocus();
          }
          break;
        case AuthViewMode.forgotPassword:
          if (_forgotPasswordForm.email.valueTrimIsEmpty != null) {
            _forgotPasswordForm.email.requestFocus();
          } else {
            sendForgotPasswordFocusNode.requestFocus();
          }
          break;
      }
    });
  }

  void _onAuthViewModeChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (_authViewMode.value) {
        case AuthViewMode.login:
          loginButtonFocusNode.skipTraversal = false;
          _loginForm.email.focusNode.skipTraversal = false;
          _loginForm.password.focusNode.skipTraversal = false;
          registerButtonFocusNode.skipTraversal = false;
          _registerForm.confirmPassword.focusNode.skipTraversal = true;
          sendForgotPasswordFocusNode.skipTraversal = true;
          _registerForm.agreePrivacy.focusNode.skipTraversal = true;
          break;
        case AuthViewMode.register:
          _registerForm.email.focusNode.skipTraversal = false;
          _registerForm.password.focusNode.skipTraversal = false;
          _registerForm.confirmPassword.focusNode.skipTraversal = false;
          registerButtonFocusNode.skipTraversal = false;
          _registerForm.agreePrivacy.focusNode.skipTraversal = false;
          loginButtonFocusNode.skipTraversal = true;
          sendForgotPasswordFocusNode.skipTraversal = true;
          break;
        case AuthViewMode.forgotPassword:
          _forgotPasswordForm.email.focusNode.skipTraversal = false;
          sendForgotPasswordFocusNode.skipTraversal = false;
          loginButtonFocusNode.skipTraversal = false;
          _loginForm.password.focusNode.skipTraversal = true;
          _registerForm.password.focusNode.skipTraversal = true;
          _registerForm.confirmPassword.focusNode.skipTraversal = true;
          registerButtonFocusNode.skipTraversal = true;
          _registerForm.agreePrivacy.focusNode.skipTraversal = true;
          break;
      }
    });
  }

  Future<void> onLoginPressed({
    required AuthViewMode authViewMode,
    required BuildContext context,
  }) async {
    if (isBusy) {
      return;
    }
    await _mutex.lockAndRun(
      run: (unlock) async {
        try {
          switch (authViewMode) {
            case AuthViewMode.login:
              if (_loginForm.isValid) {
                setBusy(true, busyType: BusyType.indicatorBackdropIgnorePointer);

                final email = _loginForm.email.cValue!;
                final password = _loginForm.password.cValue!;
                final authResponse = await _emailService.login(email: email, password: password);

                authResponse.when(
                  success: (response) {
                    _toastService.showToast(
                      context: context,
                      title: 'Logged in',
                      subtitle: 'Welcome back!',
                    );
                  },
                  fail: (response) {
                    _toastService.showToast(
                      context: context,
                      title: 'Failed to log in',
                      subtitle: response.message,
                    );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _loginForm.password.requestFocus();
                    });
                  },
                );
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!_loginForm.email.isValid) {
                    _loginForm.email.requestFocus();
                  } else if (!_loginForm.password.isValid) {
                    _loginForm.password.requestFocus();
                  }
                });
              }
              break;
            case AuthViewMode.register:
              _updateAuthViewMode(AuthViewMode.login);
              _loginForm.email.updateValue(_registerForm.email.cValue);
              _loginForm.password.updateValue(_registerForm.password.cValue);
              break;
            case AuthViewMode.forgotPassword:
              _updateAuthViewMode(AuthViewMode.login);
              _loginForm.email.updateValue(_forgotPasswordForm.email.cValue);
              break;
          }
        } catch (error, stackTrace) {
          log.error(
            'Exception caught while trying to login!',
            error: error,
            stackTrace: stackTrace,
          );
        } finally {
          unlock();
          setBusy(false);
          _restoreFocus();
        }
      },
    );
  }

  Future<void> onRegisterPressed({
    required AuthViewMode authViewMode,
    required BuildContext context,
  }) async {
    await _mutex.lockAndRun(
      run: (unlock) async {
        try {
          switch (authViewMode) {
            case AuthViewMode.login:
              _updateAuthViewMode(AuthViewMode.register);
              _registerForm.email.updateValue(_loginForm.email.cValue);
              _registerForm.password.updateValue(_loginForm.password.cValue);
              break;
            case AuthViewMode.register:
              try {
                if (_registerForm.isValid) {
                  setBusy(true, busyType: BusyType.indicatorBackdropIgnorePointer);

                  final email = _registerForm.email.cValue!;
                  final password = _registerForm.password.cValue!;
                  final authResponse = await _emailService.register(
                    email: email,
                    password: password,
                  );

                  await authResponse.when(
                    success: (response) async {
                      _toastService.showToast(context: context, title: 'Account created');
                    },
                    fail: (response) {
                      _toastService.showToast(
                        context: context,
                        title: 'Account creation failed',
                        subtitle: response.message,
                      );
                    },
                  );
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!_registerForm.email.isValid) {
                      _registerForm.email.requestFocus();
                    } else if (!_registerForm.password.isValid) {
                      _registerForm.password.requestFocus();
                    } else if (!_registerForm.confirmPassword.isValid) {
                      _registerForm.confirmPassword.requestFocus();
                    } else if (!_registerForm.agreePrivacy.isValid) {
                      _registerForm.agreePrivacy.requestFocus();
                    }
                  });
                }
              } catch (error, stackTrace) {
                log.error(
                  'Unexpected ${error.runtimeType} caught while registering with email',
                  error: error,
                  stackTrace: stackTrace,
                );
              }
              break;
            case AuthViewMode.forgotPassword:
              _updateAuthViewMode(AuthViewMode.login);
              _loginForm.email.updateValue(_forgotPasswordForm.email.cValue);
              break;
          }
        } catch (error, stackTrace) {
          log.error(
            'Exception caught while trying to register!',
            error: error,
            stackTrace: stackTrace,
          );
        } finally {
          unlock();
          setBusy(false);
          _restoreFocus();
        }
      },
    );
  }

  Future<void> onForgotPasswordPressed() async {
    await _mutex.lockAndRun(
      run: (unlock) async {
        try {
          _updateAuthViewMode(AuthViewMode.forgotPassword);
          _forgotPasswordForm.email.updateValue(_loginForm.email.cValue);
        } catch (error, stackTrace) {
          log.error(
            'Exception caught while switching to forgot password mode',
            error: error,
            stackTrace: stackTrace,
          );
        } finally {
          unlock();
          setBusy(false);
          _restoreFocus();
        }
      },
    );
  }

  Future<void> onForgotPasswordSendPressed({required BuildContext context}) async {
    try {
      if (_isResetPasswordCooldownActive) {
        final minutes = _remainingSeconds ~/ 60;
        final seconds = _remainingSeconds % 60;
        final message = minutes > 0
            ? 'Please wait $minutes ${minutes == 1 ? 'minute' : 'minutes'} and $seconds ${seconds == 1 ? 'second' : 'seconds'} before requesting another password reset.'
            : 'Please wait $seconds ${seconds == 1 ? 'second' : 'seconds'} before requesting another password reset.';

        _toastService.showToast(context: context, title: 'Please wait', subtitle: message);
        return;
      }

      if (_forgotPasswordForm.email.isValid) {
        log.info('Sending password reset email.');
        _isResetPasswordCooldownActive = true;
        _forgotPasswordAt = DateTime.now();
        _resetPasswordTimer?.cancel();
        _resetPasswordTimer = Timer(_kResetPasswordCooldown, () {
          _isResetPasswordCooldownActive = false;
        });

        unawaited(_firebaseAuth.sendPasswordResetEmail(email: _forgotPasswordForm.email.cValue!));

        _toastService.showToast(
          context: context,
          title: 'Reset password',
          subtitle:
              'If registered, we will send a password reset email to ${_forgotPasswordForm.email.cValue!}',
        );
        if (context.mounted) {
          _updateAuthViewMode(AuthViewMode.login);
        }
        log.info('Password reset email sent.');
        _restoreFocus();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _forgotPasswordForm.email.requestFocus();
        });
      }
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while sending password reset email.',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      setBusy(false);
    }
  }

  void onEmailSubmitted({required BuildContext context}) {
    switch (_authViewMode.value) {
      case AuthViewMode.login:
        if (_loginForm.email.isValid) {
          _loginForm.password.requestFocus();
        }
        break;
      case AuthViewMode.register:
        if (_registerForm.email.isValid) {
          _registerForm.password.requestFocus();
        }
        break;
      case AuthViewMode.forgotPassword:
        if (_forgotPasswordForm.email.isValid) {
          onForgotPasswordSendPressed(context: context);
        }
        break;
    }
  }

  void onPasswordSubmitted({required String value, required BuildContext context}) {
    switch (_authViewMode.value) {
      case AuthViewMode.login:
        if (_loginForm.password.isValid) {
          onLoginPressed(authViewMode: _authViewMode.value, context: context);
        }
        break;
      case AuthViewMode.register:
        if (_registerForm.password.isValid) {
          _registerForm.confirmPassword.requestFocus();
        }
        break;
      case AuthViewMode.forgotPassword:
        break;
    }
  }

  void onConfirmPasswordSubmitted(String? _) {
    if (_registerForm.confirmPassword.isValid) {
      _registerForm.agreePrivacy.requestFocus();
    }
  }
}
