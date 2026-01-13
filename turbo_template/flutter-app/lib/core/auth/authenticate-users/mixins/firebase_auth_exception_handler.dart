import 'package:firebase_auth/firebase_auth.dart';
import 'package:loglytics/loglytics.dart';
import 'package:turbo_response/turbo_response.dart';

mixin FirebaseAuthExceptionHandler {
  TurboResponse<T> tryHandleFirebaseAuthException<T>({
    required FirebaseAuthException firebaseAuthException,
    required Log log,
  }) {
    log.debug('Starting to handle FirebaseAuthException');
    log.error('FirebaseAuthException code: ${firebaseAuthException.code}');
    log.error('FirebaseAuthException message: ${firebaseAuthException.message}');

    return switch (firebaseAuthException.code) {
      'invalid-credential' => const TurboResponse.failAsBool(
        title: 'Invalid credentials',
        message: 'The email or password you entered is incorrect.',
      ),
      'network-request-failed' => const TurboResponse.failAsBool(
        title: 'Network error',
        message:
            'Unable to connect to the authentication service. Please check your internet connection.',
      ),
      'account-exists-with-different-credential' => const TurboResponse.failAsBool(
        title: 'Account already in use',
        message: 'An account already exists with this email address.',
      ),
      'operation-not-allowed' => const TurboResponse.failAsBool(
        title: 'Operation not allowed',
        message: 'This type of account is not enabled. Please try again.',
      ),
      'user-disabled' => const TurboResponse.failAsBool(
        title: 'Account disabled',
        message: 'This account has been disabled.',
      ),
      'user-not-found' => const TurboResponse.failAsBool(
        title: 'Account not found',
        message: 'No account found with this email address.',
      ),
      'wrong-password' => const TurboResponse.failAsBool(
        title: 'Wrong password',
        message: 'The password you entered is incorrect.',
      ),
      'invalid-verification-code' => const TurboResponse.failAsBool(
        title: 'Invalid verification code',
        message: 'The verification code you entered is invalid.',
      ),
      'invalid-verification-id' => const TurboResponse.failAsBool(
        title: 'Invalid verification ID',
        message: 'The verification ID is invalid.',
      ),
      'invalid-email' => const TurboResponse.failAsBool(
        title: 'Invalid email',
        message: 'Please enter a valid email address.',
      ),
      'email-already-in-use' => const TurboResponse.failAsBool(
        title: 'Email already in use',
        message: 'An account already exists with this email address.',
      ),
      'weak-password' => const TurboResponse.failAsBool(
        title: 'Weak password',
        message: 'Please choose a stronger password.',
      ),
      'invalid-phone-number' => const TurboResponse.failAsBool(
        title: 'Invalid phone number',
        message: 'Please enter a valid phone number.',
      ),
      'captcha-check-failed' => const TurboResponse.failAsBool(
        title: 'Captcha check failed',
        message: 'The reCAPTCHA verification failed. Please try again.',
      ),
      'quota-exceeded' => const TurboResponse.failAsBool(
        title: 'Quota exceeded',
        message: 'The quota has been exceeded. Please try again later.',
      ),
      'provider-already-linked' => const TurboResponse.failAsBool(
        title: 'Provider already linked',
        message: 'This provider is already linked to your account.',
      ),
      'credential-already-in-use' => const TurboResponse.failAsBool(
        title: 'Credential already in use',
        message: 'This credential is already in use.',
      ),
      _ => const TurboResponse.failAsBool(
        title: 'Unknown error',
        message: 'An unknown error occurred. Please try again.',
      ),
    };
  }
}

