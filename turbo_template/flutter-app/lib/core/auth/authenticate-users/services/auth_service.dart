import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:informers/informer.dart';
import 'package:loglytics/loglytics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/sync_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/completer_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/utils/mutex.dart';
import 'package:turbo_response/turbo_response.dart';

class AuthService extends SyncService<User?> with Loglytics {
  AuthService() : super(initialiseStream: true);

  static AuthService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(
    AuthService.new,
    dispose: (param) async {
      await param.dispose();
    },
  );

  final _firebaseAuth = FirebaseAuth.instance;

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
              _hasAuth.update(true);
              _hasLoggedOut = false;
              return;
            } else {
              _hasAuth.update(false);
              if (_hasLoggedOut) {
                _hasLoggedOut = false;
                return;
              }
              if (_lastUser != null) {
                log.warning('User was unexpectedly logged out');
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

  User? _lastUser;
  bool _hasLoggedOut = false;
  final _currentUser = BehaviorSubject<User?>();
  final _hasAuth = Informer<bool>(false);

  final _isReady = Completer<bool>();
  final _mutex = Mutex();

  Future<bool> get hasReadyAuth async {
    await isReady;
    return _hasAuth.value;
  }

  Future<User?> get readyUser async {
    await isReady;
    return user;
  }

  Future<bool> get isReady => _isReady.future;
  Stream<User?> get currentUserStream => _currentUser.stream;
  String? get userId => user?.uid;
  User? get user => _currentUser.valueOrNull;
  ValueListenable<bool> get hasAuth => _hasAuth;

  Future<bool> get hasVerifiedEmail async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return false;

    try {
      await currentUser.reload();
      final refreshedUser = _firebaseAuth.currentUser;
      return refreshedUser?.emailVerified ?? false;
    } catch (error, stackTrace) {
      log.error('Error reloading user', error: error, stackTrace: stackTrace);
      return currentUser.emailVerified;
    }
  }

  String? get email => user?.email;

  Future<void> logout() async {
    return _mutex.lockAndRun(
      run: (unlock) async {
        try {
          _hasLoggedOut = true;
          await _firebaseAuth.signOut();
          _hasLoggedOut = _firebaseAuth.currentUser == null;
        } catch (error, stackTrace) {
          log.error(
            '${error.runtimeType} caught while logging out.',
            error: error,
            stackTrace: stackTrace,
          );
          _hasLoggedOut = _firebaseAuth.currentUser == null;
        } finally {
          unlock();
        }
      },
    );
  }

  Future<TurboResponse> sendVerifyEmailEmail() async {
    try {
      log.info('Sending verify email email..');
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const TurboResponse.failAsBool(title: 'Error', message: 'No user is currently signed in.');
      }
      await user.sendEmailVerification();
      return const TurboResponse.successAsBool(
        title: 'Verification email sent',
        message: 'Please check your email to verify your account.',
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
