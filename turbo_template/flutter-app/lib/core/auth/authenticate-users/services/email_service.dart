import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/mixins/firebase_auth_exception_handler.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbolytics/turbolytics.dart';

class EmailService with Turbolytics, FirebaseAuthExceptionHandler {
  static EmailService get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(EmailService.new);

  final _firebaseAuth = FirebaseAuth.instance;

  Future<TurboResponse<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      log.info('Logging in user with email: $email and password.');
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user != null) {
        log.info('Logging in user with email and password was successful!');
        return TurboResponse.success(title: 'Login successful', result: user);
      } else {
        log.error('Logging in user with email and password failed!');
        return const TurboResponse.failAsBool(
          title: 'Login failed',
          message: 'An unknown error occurred.',
        );
      }
    } on FirebaseAuthException catch (error) {
      final code = error.code;
      log.warning('Unable to login user! Reason: $code.');
      return tryHandleFirebaseAuthException(firebaseAuthException: error, log: log);
    } catch (error, stackTrace) {
      log.error(
        'Unknown exception caught while trying to login.',
        error: error,
        stackTrace: stackTrace,
      );
      return const TurboResponse.failAsBool(
        title: 'Login failed',
        message: 'An unknown error occurred.',
      );
    }
  }

  Future<TurboResponse<User>> register({
    required String email,
    required String password,
  }) async {
    try {
      log.info('Registering user with email: $email and password..');
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user != null) {
        log.info('Registering user with email and password was successful!');
        return TurboResponse.success(title: 'Account created', result: user);
      } else {
        log.error('Registering user with email and password failed!');
        return const TurboResponse.failAsBool(
          title: 'Registration failed',
          message: 'An unknown error occurred.',
        );
      }
    } on FirebaseAuthException catch (error) {
      final code = error.code;
      log.warning('Unable to register user! Reason: $code.');
      return tryHandleFirebaseAuthException(firebaseAuthException: error, log: log);
    } catch (error, stackTrace) {
      log.error(
        'Unknown exception caught while trying to register.',
        error: error,
        stackTrace: stackTrace,
      );
      return const TurboResponse.failAsBool(
        title: 'Registration failed',
        message: 'An unknown error occurred.',
      );
    }
  }
}

