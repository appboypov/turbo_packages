import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/enums/auth_view_mode.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/toast_service.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:veto/veto.dart';

class AuthViewModel extends BaseViewModel with Turbolytics, BusyServiceManagement {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static AuthViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(AuthViewModel.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final _toastService = ToastService.locate;
  final _urlLauncherService = UrlLauncherService.locate;
  final _emailService = EmailService.locate;
  final _authService = AuthService.locate;
  final _localStorageService = LocalStorageService.locate;
  final _authStepService = AuthStepService.locate;
  final _homeRouter = HomeRouter.locate;
  final _firebaseAuth = FirebaseAuth.instance;
  DialogService get _dialogService => DialogService.locate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> initialise() async {
    await _authService.isReady;
    await _canInit.future;
    if (_authService.hasAuth.value) {
      await _authStepService.isReady;
      final result = await _authStepService.handleAuthStep();
      switch (result) {
        case StepResult.didNavigate:
          break;
        case StepResult.didNothing:
          _homeRouter.goHomeView();
          return;
      }
      log.info('Startup step handled!');
    }
    _authViewMode.addListener(_onAuthViewModeChanged);
    _showAgreeToPrivacyCheckBox.addListener(_onShowAgreePrivacyCheckbox);
    _onAuthViewModeChanged();
    _onShowAgreePrivacyCheckbox();
    super.initialise();
  }

  @override
  void dispose() {
    _authViewMode.removeListener(_onAuthViewModeChanged);
    _showAgreeToPrivacyCheckBox.removeListener(_onShowAgreePrivacyCheckbox);
    loginButtonFocusNode.dispose();
    registerButtonFocusNode.dispose();
    _resetPasswordTimer?.cancel();
    super.dispose();
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final Completer _canInit = Completer();
  DateTime? _forgotPasswordAt;
  final FocusNode sendForgotPasswordFocusNode = FocusNode();
  final FocusNode loginButtonFocusNode = FocusNode();
  final FocusNode registerButtonFocusNode = FocusNode();
  final _authViewMode = Informer<AuthViewMode>(AuthViewMode.defaultValue);
  final _showAgreeToPrivacyCheckBox = Informer<bool>(false);
  final _loginForm = LoginForm.locate;
  final _registerForm = RegisterForm.locate;
  final _forgotPasswordForm = ForgotPasswordForm.locate;
  Timer? _resetPasswordTimer;
  bool _isResetPasswordCooldownActive = false;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  final _mutex = Mutex();
  final _animationDurationCompleter = MinDurationCompleter(TDurations.animation);
  static const _kResetPasswordCooldown = Duration(minutes: 1);

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  int get _remainingSeconds => _forgotPasswordAt == null
      ? 0
      : _kResetPasswordCooldown.inSeconds - gNow.difference(_forgotPasswordAt!).inSeconds;

  bool canPop({required BuildContext context}) => context.canPop();

  DateTime? get acceptedPrivacyAndTermsAt =>
      (_registerForm.agreePrivacy.data.value ?? false) ? gNow : null;

  ValueListenable<bool> get showAgreeToPrivacyCheckBox => _showAgreeToPrivacyCheckBox;
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

  bool get isResetPasswordCooldownActive => _isResetPasswordCooldownActive;

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\

  void _updateAuthViewMode(AuthViewMode authViewMode) {
    // Clear focus immediately before changing mode
    FocusManager.instance.primaryFocus?.unfocus();
    _authViewMode.update(authViewMode);
  }

  void _restoreFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!kIsWeb) {
        await TDurations.animation.asFuture;
      }
      switch (authViewMode.value) {
        case AuthViewMode.login:
          if (_loginForm.email.valueTrimIsEmpty) {
            _loginForm.email.requestFocus();
          } else if (_loginForm.password.valueTrimIsEmpty) {
            _loginForm.password.requestFocus();
          } else {
            loginButtonFocusNode.requestFocus();
          }
          break;
        case AuthViewMode.register:
          if (_registerForm.email.valueTrimIsEmpty) {
            _registerForm.email.requestFocus();
          } else if (_registerForm.password.valueTrimIsEmpty) {
            _registerForm.password.requestFocus();
          } else if (_registerForm.confirmPassword.valueTrimIsEmpty) {
            _registerForm.confirmPassword.requestFocus();
          } else {
            registerButtonFocusNode.requestFocus();
          }
          break;
        case AuthViewMode.forgotPassword:
          if (_forgotPasswordForm.email.valueTrimIsEmpty) {
            _forgotPasswordForm.email.requestFocus();
          } else {
            sendForgotPasswordFocusNode.requestFocus();
          }
          break;
      }
    });
  }

  Future<void> _tryCreateUserDocAndNextView({required String userId, required String email}) async {
    await _authService.isReady;
    await _localStorageService.isReady;
    await _authStepService.isReady;
    final result = await _authStepService.handleAuthStep(
      acceptedPrivacyAndTermsAt: acceptedPrivacyAndTermsAt,
    );
    switch (result) {
      case StepResult.didNavigate:
        break;
      case StepResult.didNothing:
        _homeRouter.goHomeView();
        break;
    }
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void _onShowAgreePrivacyCheckbox() =>
      _registerForm.agreePrivacy.focusNode.skipTraversal = !_showAgreeToPrivacyCheckBox.value;

  void _onAuthViewModeChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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

  Future<void> onPrivacyPolicyPressed({required BuildContext context}) async {
    try {
      final shouldVisit = await _dialogService.showOkCancelDialog(
        title: context.strings.privacyPolicy,
        message: context.strings.doYouWantToVisitThePrivacyPolicy,
        context: context,
      );
      if (shouldVisit != true) return;

      setBusy(isBusy, busyType: BusyType.indicatorBackdropIgnorePointer);
      await _urlLauncherService.tryLaunchUrl(url: kValuesPrivacyPolicyUrl);
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to launch privacy policy url!',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> onTermsOfServicePressed({required BuildContext context}) async {
    try {
      final shouldVisit = await _dialogService.showOkCancelDialog(
        title: context.strings.termsOfService,
        message: context.strings.doYouWantToVisitTheTermsOfService,
        context: context,
      );
      if (shouldVisit != true) return;

      setBusy(isBusy, busyType: BusyType.indicatorBackdropIgnorePointer);
      await _urlLauncherService.tryLaunchUrl(url: kValuesTermsOfServiceUrl);
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to launch terms of service url!',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> onForgotPasswordBackPressed() async {
    _updateAuthViewMode(AuthViewMode.login);
    _animationDurationCompleter.start();

    _loginForm.email.updateValue(_forgotPasswordForm.email.cValue);

    await _animationDurationCompleter.future;
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
                      context: gContext ?? context,
                      title: context.strings.loggedInTitle,
                      subtitle: context.strings.welcomeBackTitle,
                    );
                  },
                  fail: (response) {
                    _toastService.showToast(
                      context: context,
                      title: context.strings.failedToLogInTitle,
                      subtitle: response.message,
                    );
                  },
                );

                if (authResponse.isSuccess) {
                  await _tryCreateUserDocAndNextView(userId: authResponse.result.uid, email: email);
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _loginForm.password.requestFocus();
                  });
                }
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_loginForm.email.isNotValid) {
                    _loginForm.email.requestFocus();
                  } else if (_loginForm.password.isNotValid) {
                    _loginForm.password.requestFocus();
                  }
                });
              }
              break;
            case AuthViewMode.register:
              _updateAuthViewMode(AuthViewMode.login);
              _animationDurationCompleter.start();

              _loginForm.email.updateValue(_registerForm.email.cValue);
              _loginForm.password.updateValue(_registerForm.password.cValue);

              await _animationDurationCompleter.future;
              break;
            case AuthViewMode.forgotPassword:
              await onForgotPasswordBackPressed();
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

  Future<void> onRegisterPressed({
    required AuthViewMode authViewMode,
    required BuildContext context,
  }) async => await _mutex.lockAndRun(
    run: (unlock) async {
      try {
        switch (authViewMode) {
          case AuthViewMode.login:
            _updateAuthViewMode(AuthViewMode.register);
            _animationDurationCompleter.start();

            _registerForm.email.updateValue(_loginForm.email.cValue);
            _registerForm.password.updateValue(_loginForm.password.cValue);

            await _animationDurationCompleter.future;
            break;
          case AuthViewMode.register:
            try {
              if (_registerForm.isValid) {
                setBusy(true, busyType: BusyType.indicatorBackdropIgnorePointer);

                final email = _registerForm.email.cValue!;
                final password = _registerForm.password.cValue!;
                final authResponse = await _emailService.register(email: email, password: password);

                authResponse.when(success: (response) {}, fail: (response) {});

                await authResponse.when(
                  success: (response) async {
                    _toastService.showToast(
                      context: context,
                      title: context.strings.accountCreatedTitle,
                    );
                    final userId = authResponse.result.uid;
                    await _tryCreateUserDocAndNextView(userId: userId, email: email);
                  },
                  fail: (response) {
                    _toastService.showToast(
                      context: context,
                      title: context.strings.accountCreationFailedTitle,
                      subtitle: response.message,
                    );
                  },
                );
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_registerForm.email.isNotValid) {
                    _registerForm.email.requestFocus();
                  } else if (_registerForm.password.isNotValid) {
                    _registerForm.password.requestFocus();
                  } else if (_registerForm.confirmPassword.isNotValid) {
                    _registerForm.confirmPassword.requestFocus();
                  } else if (_registerForm.agreePrivacy.isNotValid) {
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
            _animationDurationCompleter.start();

            _loginForm.email.updateValue(_forgotPasswordForm.email.cValue);

            await _animationDurationCompleter.future;
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

  Future<void> onForgotPasswordPressed() async {
    await _mutex.lockAndRun(
      run: (unlock) async {
        try {
          _updateAuthViewMode(AuthViewMode.forgotPassword);
          _animationDurationCompleter.start();
          _forgotPasswordForm.email.updateValue(_loginForm.email.cValue);
          await _animationDurationCompleter.future;
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
            ? context.strings.resetPasswordCooldownMessage(
          minutes.toString(),
          minutes == 1 ? context.strings.minute : context.strings.minutes,
          seconds.toString(),
          seconds == 1 ? context.strings.second : context.strings.seconds,
        )
            : context.strings.resetPasswordCooldownMessageSeconds(
          seconds.toString(),
          seconds == 1 ? context.strings.second : context.strings.seconds,
        );

        await _dialogService.showOkDialog(
          context: context,
          title: context.strings.pleaseWait,
          message: message,
        );
        return;
      }

      if (_forgotPasswordForm.email.isValid) {
        log.info('Sending password reset email.');
        _isResetPasswordCooldownActive = true;
        _forgotPasswordAt = gNow;
        _resetPasswordTimer?.cancel();
        _resetPasswordTimer = Timer(_kResetPasswordCooldown, () {
          _isResetPasswordCooldownActive = false;
        });

        unawaited(_firebaseAuth.sendPasswordResetEmail(email: _forgotPasswordForm.email.cValue!));

        await _dialogService.showOkDialog(
          context: context,
          title: context.strings.resetPassword,
          message: context.strings.ifRegisteredWeSend(_forgotPasswordForm.email.cValue!),
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

  void onConfirmPasswordChanged(String? value) =>
      _showAgreeToPrivacyCheckBox.update(value?.isNotEmpty == true);

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

  void onAppleAuthPressed() {}

  void onGoogleAuthPressed() {}

  Future<void> onComplete(AnimationController _) async {
    await TDurations.animation.asFuture;
    _canInit.completeIfNotComplete();
  }
}
