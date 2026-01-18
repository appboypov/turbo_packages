/// Provides constants for various authentication-related error codes.
///
/// Prevents instantiation by having a private constructor and is abstract to discourage inheritance.
abstract class TAuthErrors {
  TAuthErrors._();

  /// Error code when an account already exists with different credentials.
  static const accountExistsWithDifferentCredentials = 'account-exists-with-different-credential';

  /// Error code when the captcha verification fails.
  static const captchaCheckFailed = 'captcha-check-failed';

  /// Error code when the credential is already associated with a different user account.
  static const credentialAlreadyInUse = 'credential-already-in-use';

  /// Error code when attempting to create an account with an email that is already in use.
  static const emailAlreadyInUse = 'email-already-in-use';

  /// Error code when the provided credential is malformed or has expired.
  static const invalidCredential = 'invalid-credential';

  /// Error code when the email address is not valid.
  static const invalidEmail = 'invalid-email';

  /// Error code when the phone number is not valid.
  static const invalidPhoneNumber = 'invalid-phone-number';

  /// Error code when the SMS verification code is not valid.
  static const invalidVerificationCode = 'invalid-verification-code';

  /// Error code when the verification ID for phone auth is not valid.
  static const invalidVerificationId = 'invalid-verification-id';

  /// Error code when the requested authentication operation is not allowed.
  static const operationNotAllowed = 'operation-not-allowed';

  /// Error code when attempting to link a provider that is already linked to the account.
  static const providerAlreadyLinked = 'provider-already-linked';

  /// Error code when the project's quota for the specified operation has been exceeded.
  static const quotaExceeded = 'quota-exceeded';

  /// Error code when the user account has been disabled by an administrator.
  static const userDisabled = 'user-disabled';

  /// Error code when the specified user account cannot be found.
  static const userNotFound = 'user-not-found';

  /// Error code when the password does not meet the minimum requirements.
  static const weakPassword = 'weak-password';

  /// Error code when the password is invalid for the specified email.
  static const wrongPassword = 'wrong-password';

  /// Error code when the login credentials are invalid.
  static const invalidLoginCredentials = 'INVALID_LOGIN_CREDENTIALS';
}
