import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/apis/users_api.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/auth_service.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/user_service.dart';
import 'package:turbo_flutter_template/core/shared/exceptions/unexpected_state_exception.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/initialisable.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/firestore_collection.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbolytics/turbolytics.dart';

class AuthStepService extends Initialisable with Turbolytics {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static AuthStepService get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(AuthStepService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  AuthService get _authService => AuthService.locate;
  LocalStorageService get _localStorageService => LocalStorageService.locate;
  UserService get _userService => UserService.locate;
  UsersApi get _usersApi => UsersApi.locate;
  UserProfilesApi get _profilesApi => UserProfilesApi.locate;
  SettingsApi get _settingsApi => SettingsApi.locate;
  UsernamesApi get _usernamesApi => UsernamesApi.locate;
  SettingsService get _settingsService => SettingsService.locate;
  CoreRouter get _coreRouter => CoreRouter.locate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> initialise() async {
    try {
      await FirestoreCollection.isAppReady;
      super.initialise();
    } catch (error, stackTrace) {
      log.error(
        '$error caught while initialising AuthStepService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  String get _userId {
    final userId = _authService.userId;
    if (userId == null) {
      throw const UnexpectedStateException(
        reason: 'UserId can not be null when updating AUTH steps',
      );
    }
    return userId;
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<StepResult> updateStepHappenedAndHandleNextStep({required AuthStep authStep}) async =>
      await _manageNextStep(authStep: authStep);

  Future<void> tryUpdateStepHappened({required AuthStep authStep}) async {
    try {
      log.debug('Updating startup step happened: $authStep');
      await _localStorageService.isReady;
      await _localStorageService.updateDidHappen(id: authStep, didHappen: true, userId: _userId);
    } catch (error, stackTrace) {
      log.error(
        '$error caught while updating startup step happened: $authStep',
        error: error,
        stackTrace: stackTrace,
      );
      _coreRouter.goOopsView();
    }
  }

  /// Returns true if handled and thus navigated somewhere
  Future<StepResult> handleAuthStep({
    AuthStep authStep = AuthStep.first,
    DateTime? acceptedPrivacyAndTermsAt,
  }) async {
    try {
      log.info('Handling startup step: $authStep');

      // Ensure LocalStorageService is ready before proceeding
      await _localStorageService.isReady;
      log.debug('LocalStorageService is ready, proceeding with auth step handling');

      switch (authStep) {
        case AuthStep.createUserDoc:
          return await _manageCreateUserDoc(
            authStep,
            acceptedPrivacyAndTermsAt: acceptedPrivacyAndTermsAt,
          );
        case AuthStep.acceptPrivacy:
          return await _manageAcceptPrivacy(authStep);
        case AuthStep.createUsernameDoc:
          return await _manageCreateUsernameDoc(authStep);
        case AuthStep.createProfileDoc:
          return await _manageCreateProfileDoc(authStep);
        case AuthStep.verifyEmail:
          return await _manageVerifyEmail(authStep);
        case AuthStep.createHousehold:
          return await _manageCreateHousehold(authStep);
        case AuthStep.createSettingsDoc:
          return await _manageCreateSettingsDoc(authStep);
      }
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying handling the next startup step',
        error: error,
        stackTrace: stackTrace,
      );
      _coreRouter.goOopsView();
      return StepResult.didNothing;
    }
  }

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\

  Future<StepResult> _manageVerifyEmail(AuthStep authStep) async {
    log.info('Starting _manageVerifyEmail');
    final didNotVerifyEmail = !_localStorageService.didHappen(id: authStep, userId: _userId);

    // Check both time delay (24 hours) AND snooze count (max 1 time)
    final skippedDate = _settingsService.skippedVerifyEmailDate;
    final snoozeCount = _settingsService.verifyEmailSnoozeCount;
    final canShowVerifyEmail = (skippedDate?.isMoreThanHoursAgo(24) ?? true) || snoozeCount < 1;

    if (didNotVerifyEmail && canShowVerifyEmail) {
      log.debug('User did not verify email per local storage service, verifying email.');
      final hasVerifiedEmail = _authService.hasVerifiedEmail;
      if (await hasVerifiedEmail) {
        log.debug('User already verified email per auth service, continuing.');
        log.info('Finished _manageVerifyEmail');
        return await _manageNextStep(authStep: authStep);
      } else {
        log.debug(
          'User did not verify email per auth service, sending verification email and navigating to verify email view.',
        );
        await _authService.sendVerifyEmailEmail();
        _authStepRouter.goVerifyEmailView();
        log.info('Finished _manageVerifyEmail');
        return StepResult.didNavigate;
      }
    } else {
      log.debug('User skipped or already verified email per local storage service, continuing.');
      log.info('Finished _manageVerifyEmail');
      return await _manageNextStep(authStep: authStep);
    }
  }

  Future<StepResult> _manageCreateHousehold(AuthStep authStep) async {
    log.info('Starting _manageCreateHousehold');
    final didNotCreateHousehold = !_localStorageService.didHappen(
      userId: _userId,
      id: authStep.toString(),
    );
    if (didNotCreateHousehold) {
      log.debug('User did not create household per local storage service, creating household doc.');
      final hasHousehold = _householdService.hasRemoteHousehold;
      if (hasHousehold) {
        log.debug('User already has a household per firestore, continuing.');
        log.info('Finished _manageCreateHousehold');
        return await _manageNextStep(authStep: authStep);
      } else {
        log.debug('User does not have a household per firestore, creating household doc.');
        final randomService = RandomService.locateSingleton;
        final response = await _householdService.createHousehold(
          householdDto: (vars) => HouseholdDto.create(
            userId: vars.userId,
            id: vars.id,
            name: randomService.randomHouseholdName,
          ),
        );
        if (response.isSuccess) {
          log.debug('Successfully created household document.');

          // Update user's initialHouseholdId with the newly created household ID
          final householdId = response.result.id;
          log.debug('Setting user\'s initialHouseholdId to: $householdId');
          final updateResponse = await _userService.updateInitialHouseholdId(
            householdId: householdId,
          );

          if (!updateResponse.isSuccess) {
            throw const UnexpectedResultException(reason: 'Failed to update initialHouseholdId');
          }

          log.info('Finished _manageCreateHousehold');
          return await _manageNextStep(authStep: authStep);
        } else {
          log.debug('Failed to create household document.');
          log.info('Finished _manageCreateHousehold with error');
          throw const UnexpectedStateException(
            reason: 'User can not continue without creating a household document.',
          );
        }
      }
    } else {
      log.debug('User already created household doc per local storage service, continuing.');
      log.info('Finished _manageCreateHousehold');
      return await _manageNextStep(authStep: authStep);
    }
  }

  Future<StepResult> _manageCreateSettingsDoc(AuthStep authStep) async {
    log.info('Starting _manageCreateSettingsDoc');
    final didNotCreateSettingsDoc = !_localStorageService.didHappen(id: authStep, userId: _userId);
    if (didNotCreateSettingsDoc) {
      log.debug(
        'User did not create settings doc per local storage service, creating settings doc.',
      );
      final userId = gUserIdNotNull(when: 'creating settings document');
      final hasSettings = await _settingsApi.hasSettings(userId: userId);
      if (hasSettings) {
        log.debug('User already has a settings per firestore, continuing.');
        log.info('Finished _manageCreateSettingsDoc');
        return await _manageNextStep(authStep: authStep);
      } else {
        log.debug('User does not have a settings per firestore, creating settings doc.');
        final response = await _settingsService.createSettings(
          doc: (vars) => SettingsDto.create(vars: vars),
        );
        switch (response) {
          case Success():
            log.debug('Successfully created settings document.');
            log.info('Finished _manageCreateSettingsDoc');
            return await _manageNextStep(authStep: authStep);
          case Fail():
            log.debug('Failed to create settings document.');
            log.info('Finished _manageCreateSettingsDoc with error');
            throw const UnexpectedStateException(
              reason: 'User can not continue without creating a settings document.',
            );
        }
      }
    } else {
      log.debug('User already created profile doc per local storage service, continuing.');
      log.info('Finished _manageCreateSettingsDoc');
      return await _manageNextStep(authStep: authStep);
    }
  }

  Future<StepResult> _manageCreateProfileDoc(AuthStep authStep) async {
    log.info('Starting _manageCreateProfileDoc');
    final didNotCreateProfileDoc = !_localStorageService.didHappen(id: authStep, userId: _userId);
    if (didNotCreateProfileDoc) {
      log.debug('User did not create profile doc per local storage service, creating profile doc.');
      final userId = gUserIdNotNull(when: 'creating profile document');
      final hasProfile = await _profilesApi.profileExists(userId: userId);
      if (hasProfile) {
        log.debug('User already has a profile per firestore, continuing.');
        log.info('Finished _manageCreateProfileDoc');
        return await _manageNextStep(authStep: authStep);
      } else {
        log.debug('User does not have a profile per firestore, creating profile doc.');
        final username = await _usernamesApi.fetchUsername(userId: userId);
        if (username == null) {
          log.info('Finished _manageCreateProfileDoc with error');
          throw const UnexpectedNullException(
            reason: 'username should not be null when creating profile doc in startup step service',
          );
        }
        final response = await _profilesApi.createProfile(userId: userId, username: username);
        if (response.isSuccess) {
          log.debug('Successfully created profile document with username: $username');
          log.info('Finished _manageCreateProfileDoc');
          return await _manageNextStep(authStep: authStep);
        } else {
          log.debug('Failed to create profile document.');
          log.info('Finished _manageCreateProfileDoc with error');
          throw const UnexpectedStateException(
            reason: 'User can not continue without creating a profile document.',
          );
        }
      }
    } else {
      log.debug('User already created profile doc per local storage service, continuing.');
      log.info('Finished _manageCreateProfileDoc');
      return await _manageNextStep(authStep: authStep);
    }
  }

  Future<StepResult> _manageCreateUsernameDoc(AuthStep authStep) async {
    log.info('Starting _manageCreateUsernameDoc');
    final didNotCreateUsernameDoc = !_localStorageService.didHappen(id: authStep, userId: _userId);
    if (didNotCreateUsernameDoc) {
      log.debug(
        'User did not create username doc per local storage service, creating username doc.',
      );
      final userId = gUserIdNotNull(when: 'creating username doc');
      final hasUsername = (await _usernamesApi.fetchUsername(userId: userId)) != null;
      if (hasUsername) {
        log.debug('User already has a username per firestore, continuing.');
        log.info('Finished _manageCreateUsernameDoc');
        return await _manageNextStep(authStep: authStep);
      } else {
        log.debug(
          'User does not have a username per firestore, navigating to create username view.',
        );
        _authStepRouter.goCreateUsernameView();
        log.info('Finished _manageCreateUsernameDoc');
        return StepResult.didNavigate;
      }
    } else {
      log.debug('User already created username doc per local storage service, continuing.');
      log.info('Finished _manageCreateUsernameDoc');
      return await _manageNextStep(authStep: authStep);
    }
  }

  Future<StepResult> _manageAcceptPrivacy(
    AuthStep authStep, {
    DateTime? acceptedPrivacyAndTermsAt,
  }) async {
    log.info('Starting _manageAcceptPrivacy');
    final didNotAcceptPrivacy = !_localStorageService.didHappen(id: authStep, userId: _userId);
    if (didNotAcceptPrivacy) {
      log.debug('User did not accept privacy per local storage service, accepting privacy.');
      final localAcceptedPrivacyAndTermsAt =
          acceptedPrivacyAndTermsAt ?? _userService.acceptedPrivacyAndTermsAt;
      if (localAcceptedPrivacyAndTermsAt == null) {
        log.debug(
          'acceptedPrivacyAndTermsAt is null when accepting privacy in startup step service, navigating to accept privacy view',
        );
        _authStepRouter.goAcceptPrivacyView();
        log.info('Finished _manageAcceptPrivacy');
        return StepResult.didNavigate;
      } else {
        log.debug('User already accepted privacy per user service, continuing.');
        log.info('Finished _manageAcceptPrivacy');
        return await _manageNextStep(authStep: authStep);
      }
    } else {
      log.debug('User already accepted privacy per local storage service, continuing.');
      log.info('Finished _manageAcceptPrivacy');
      return await _manageNextStep(authStep: authStep);
    }
  }

  Future<StepResult> _manageCreateUserDoc(
    AuthStep authStep, {
    DateTime? acceptedPrivacyAndTermsAt,
  }) async {
    log.info('Starting _manageCreateUserDoc');
    final didNotCreatedUserDoc = !_localStorageService.didHappen(id: authStep, userId: _userId);
    if (didNotCreatedUserDoc) {
      log.debug('User did not create user doc per local storage service, creating user doc.');
      final userId = gUserIdNotNull(when: 'creating user doc in startup step service');
      final hasUserDocument = await _usersApi.userExists(userId: userId);
      if (!hasUserDocument) {
        log.debug('User does not have a user document per firestore, creating user document.');
        final email = _authService.email;
        if (email == null) {
          log.info('Finished _manageCreateUserDoc with error');
          throw const UnexpectedNullException(
            reason: 'email should not be null when creating user doc in startup step service',
          );
        }
        final response = await _userService.createUser(
          doc: (vars) => UserDto.create(
            userId: userId,
            email: email,
            acceptedPrivacyAndTermsAt: acceptedPrivacyAndTermsAt,
          ),
        );
        if (response.isSuccess) {
          log.debug('Successfully created user document.');
          log.info('Finished _manageCreateUserDoc');
          return await _manageNextStep(authStep: authStep);
        } else {
          log.info('Finished _manageCreateUserDoc with error');
          throw UnexpectedStateException(
            reason:
                'User can not continue without creating a user document. Error: ${response.error}',
          );
        }
      } else {
        log.debug('User already has a user document per firestore, continuing.');
        log.info('Finished _manageCreateUserDoc');
        return await _manageNextStep(authStep: authStep);
      }
    } else {
      log.debug('User already created user doc per local storage service, continuing.');
      log.info('Finished _manageCreateUserDoc');
      return await _manageNextStep(authStep: authStep);
    }
  }

  Future<StepResult> _manageNextStep({required AuthStep authStep}) async {
    log.debug('Handling next step for $authStep..');
    final nextStep = await _updateStepHappenedAndGetNextStep(authStep: authStep);
    log.debug('Next step is $nextStep.');
    if (nextStep != null) {
      return await handleAuthStep(authStep: nextStep);
    } else {
      // returning false means it did not handle any steps and we can continue
      return StepResult.didNothing;
    }
  }

  Future<AuthStep?> _updateStepHappenedAndGetNextStep({required AuthStep authStep}) async {
    await tryUpdateStepHappened(authStep: authStep);
    return authStep.next;
  }
}
