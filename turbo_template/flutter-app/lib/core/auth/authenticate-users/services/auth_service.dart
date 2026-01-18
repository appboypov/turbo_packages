import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/analytics/user_analytics.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/mixins/firebase_auth_exception_handler.dart';
import 'package:turbo_flutter_template/core/auth/enums/user_level.dart';
import 'package:turbo_flutter_template/core/infrastructure/inject-dependencies/services/locator_service.dart';
import 'package:turbo_flutter_template/core/shared/exceptions/unexpected_null_exception.dart';
import 'package:turbo_flutter_template/core/shared/exceptions/unexpected_state_exception.dart';
import 'package:turbo_flutter_template/core/shared/extensions/map_extension.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/sync_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/annotations/called_by_mutex.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/utils/debouncer.dart';
import 'package:turbo_flutter_template/core/state/manage-state/utils/mutex.dart';
import 'package:turbo_flutter_template/environment/enums/environment.dart';
import 'package:turbo_flutter_template/generated/l10n.dart';
import 'package:turbo_notifiers/turbo_notifier.dart';
import 'package:turbo_notifiers/turbo_notifier.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbolytics/turbolytics.dart';

import '../../../state/manage-state/extensions/completer_extension.dart';

class AuthService extends SyncService<User?>
    with Turbolytics<UserAnalytics>, FirebaseAuthExceptionHandler {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static AuthService get locate => GetIt.I.get();
  static AuthService Function() get lazyLocate =>
      () => GetIt.I.get<AuthService>();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(
    AuthService.new,
    dispose: (param) async {
      await param.dispose();
    },
  );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final _firebaseAuth = FirebaseAuth.instance;
  LocatorService get _locatorService => LocatorService.locate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  Stream<User?> Function() get stream => _firebaseAuth.userChanges;

  @override
  void Function(User? value) get onData =>
      (user) => _mutex.lockAndRun(
        run: (unlock) async {
          try {
            log.debug('New user data received, user: ${user?.uid}');
            _lastUser = _currentUser.valueOrNull;
            _currentUser.add(user);
            if (user != null) {
              analytics.setUserId(userId: user.uid);
              _hasAuth.update(true);
              _tryManageUserLevel(user);
              _hasLoggedOut = false;
              return;
            } else {
              _hasAuth.update(false);
              _claimsUserLevel.update(UserLevel.unknown);
              if (_hasLoggedOut) {
                _hasLoggedOut = false;
                return;
              }
              if (_lastUser != null) {
                throw UnexpectedStateException(
                  reason: 'User was unexpectedly logged out. _hasLoggedOut: $_hasLoggedOut',
                );
              }
            }
          } catch (error, stackTrace) {
            log.error(
              'Exception caught while processing received data in the auth service.',
              error: error,
              stackTrace: stackTrace,
            );
          } finally {
            _isReady.completeIfNotComplete(true);
            unlock();
          }
        },
      );

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  User? _lastUser;
  bool _hasLoggedOut = false;
  final _claimsUserLevel = TNotifier<UserLevel>(UserLevel.unknown);
  final _currentUser = BehaviorSubject<User?>();
  final _didManageUserLevel = Completer();
  final _hasAuth = TNotifier<bool>(false);

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  final _debouncer = Debouncer(duration: const Duration(milliseconds: 600));
  final _isReady = Completer<bool>();
  final _mutex = Mutex();
  int _claimsRetryCount = 0;

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  Future<bool> get hasReadyAuth async {
    await isReady;
    return _hasAuth.value;
  }

  Future<User?> get readyUser async {
    await isReady;
    return user;
  }

  Future get didManageUserLevel => _didManageUserLevel.future;
  Future<bool> get isReady => _isReady.future;
  Stream<User?> get currentUserStream => _currentUser.stream;
  String? get userId => user?.uid;
  User? get user => _currentUser.valueOrNull;
  ValueListenable<UserLevel> get claimsUserLevel => _claimsUserLevel;
  ValueListenable<bool> get hasAuth => _hasAuth;
  Future<bool> get hasVerifiedEmail async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return false;

    try {
      await currentUser.reload();
      final refreshedUser = _firebaseAuth.currentUser;
      return _getEmailVerificationStatus(refreshedUser);
    } catch (error, stackTrace) {
      log.error('Failed to reload user for email verification check', error: error, stackTrace: stackTrace);
      return _getEmailVerificationStatus(currentUser);
    }
  }

  bool get hasVerifiedPhoneNumber => user?.phoneNumber?.nullIfEmpty != null;
  String? get email => user?.email;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  /// Determines email verification status from user data.
  ///
  /// Pure function for business logic that can be unit tested.
  /// Returns false if user is null or emailVerified is null.
  static bool _getEmailVerificationStatus(User? user) {
    return user?.emailVerified ?? false;
  }

  @CalledByMutex()
  void _tryManageUserLevel(User user) {
    if (_didManageUserLevel.isCompleted) return;
    _debouncer.run(() async {
      try {
        if (_didManageUserLevel.isCompleted) return;
        log.debug('Getting claims user level..');
        log.debug('Environment: ${Environment.current}, isEmulators: ${Environment.isEmulators}');
        log.debug('User ID: ${user.uid}');
        // In emulator/mobile scenarios, services may not be ready immediately at app start.
        if (Environment.isEmulators &&
            (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android) &&
            _claimsRetryCount == 0) {
          await Future.delayed(const Duration(milliseconds: 600));
        }
        // Avoid forcing token refresh against the Auth emulator to prevent intermittent
        // internal-error on iOS simulator. Prefer a non-refresh fetch in emulator mode.
        if (Environment.isEmulators) {
          try {
            await user.getIdToken(false);
          } catch (_) {
            // Proceed; we'll still attempt to read existing token result
          }
        } else {
          await user.getIdToken(true);
        }
        final decodedToken = await user.getIdTokenResult();
        final claims = decodedToken.claims;
        _claimsUserLevel.update(claims?.userLevel ?? UserLevel.free);
        analytics.setUserLevel(userLevel: _claimsUserLevel.value);
        _didManageUserLevel.completeIfNotComplete();
        log.debug('Claims user level: ${_claimsUserLevel.value}');
        _claimsRetryCount = 0;
      } catch (error, stackTrace) {
        // Retry on transient errors; internal-error can occur in both emulator and production
        if (error is FirebaseAuthException &&
            (error.code == 'network-request-failed' || error.code == 'internal-error') &&
            _claimsRetryCount < 3) {
          _claimsRetryCount += 1;
          log.warning(
            'Firebase auth error (${error.code}) while fetching ID token (attempt $_claimsRetryCount). Retrying shortly...',
          );
          // Exponential backoff
          Future.delayed(
            Duration(milliseconds: 500 * _claimsRetryCount),
            () => _tryManageUserLevel(user),
          );
          return;
        }
        // Fallback: if we still fail with internal-error, default to free and continue app flow
        if (error is FirebaseAuthException && error.code == 'internal-error') {
          log.warning(
            'Token fetch failed with internal-error after retries. Defaulting claims user level to free.',
          );
          _claimsUserLevel.update(UserLevel.free);
          analytics.setUserLevel(userLevel: _claimsUserLevel.value);
          _didManageUserLevel.completeIfNotComplete();
          return;
        }
        log.error(
          '$error caught while trying to get claims user level.',
          error: error,
          stackTrace: stackTrace,
        );
        _didManageUserLevel.completeIfNotComplete();
      }
    });
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<TurboResponse> deleteAccount({required Strings strings}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UnexpectedNullException(
          reason: 'user should not be null when trying to delete account.',
        );
      }
      await user.delete();
      return TurboResponse.successAsBool(
        title: strings.accountDeletedTitle,
        message: strings.accountDeletedMessage,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to delete account.',
        error: error,
        stackTrace: stackTrace,
      );
      return TurboResponse.fail(
        error: error,
        title: strings.failedToDeleteAccountTitle,
        message: strings.failedToDeleteAccountMessage,
      );
    }
  }

  Future<void> requestVerificationCode({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? forceResendingToken,
  }) async {
    try {
      log.info('Verifying phone number..');
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        forceResendingToken: forceResendingToken,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to verify phone number.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<TurboResponse> linkAuthCredential({
    required AuthCredential authCredential,
    required Strings strings,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const UnexpectedNullException(
          reason: 'currentUser should not be null when trying to link phone auth credential.',
        );
      }
      await currentUser.linkWithCredential(authCredential);
      return TurboResponse.successAsBool(
        title: strings.accountLinkedTitle,
        message: strings.accountLinkedMessage,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to link phone auth credential.',
        error: error,
        stackTrace: stackTrace,
      );
      return TurboResponse.fail(error: error);
    }
  }

  Future<void> _onLogout({required BuildContext context}) async {
    try {
      log.info('Resetting services via LocatorService...');
      await _locatorService.reset();
      log.info('Services reset and re-registered.');

      log.info('Triggering Phoenix rebirth...');
      if (context.mounted) {
        Phoenix.rebirth(context);
        log.info('Phoenix rebirth triggered.');
      } else {
        log.warning('Context was unmounted before Phoenix.rebirth could be called.');
      }
    } catch (error, stackTrace) {
      log.error(
        'Error during GetIt reset or Phoenix rebirth',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<TurboResponse> logout({required BuildContext context}) async {
    return _mutex.lockAndRun(
      run: (unlock) async {
        try {
          _hasLoggedOut = true;
          await _firebaseAuth.signOut();
          await _onLogout(context: context);
          _hasLoggedOut = _firebaseAuth.currentUser == null;
          final strings = context.strings;
          if (_hasLoggedOut) {
            return TurboResponse.successAsBool(
              title: strings.logoutSuccessfulTitle,
              message: strings.logoutSuccessfulMessage,
            );
          } else {
            throw const UnexpectedStateException(
              reason: 'User should have been logged out, but was not.',
            );
          }
        } catch (error, stackTrace) {
          log.error(
            '${error.runtimeType} caught while logging out.',
            error: error,
            stackTrace: stackTrace,
          );
          _hasLoggedOut = _firebaseAuth.currentUser == null;
          final strings = context.strings;
          return TurboResponse.fail(
            error: error,
            title: strings.logoutFailedTitle,
            message:
                'An unknown error occurred.${_hasLoggedOut ? ' But we were still able to log you out.' : 'We were not able to log you out.'}',
          );
        } finally {
          unlock();
        }
      },
    );
  }

  Future<TurboResponse> sendVerifyEmailEmail({required Strings strings}) async {
    try {
      log.info('Sending verify email email..');
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UnexpectedNullException(
          reason: 'user should not be null when trying to send verify email email.',
        );
      }
      await user.sendEmailVerification();
      return TurboResponse.successAsBool(
        title: strings.verifyEmailSentTitle,
        message: strings.verifyEmailSentMessage,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to send verify email email.',
        error: error,
        stackTrace: stackTrace,
      );
      return const TurboResponse.failAsBool();
    }
  }
}
