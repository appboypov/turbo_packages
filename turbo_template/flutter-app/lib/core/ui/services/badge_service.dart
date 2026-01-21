import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/services/user_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/version_comparator_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/completer_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/utils/throttler.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_flutter_template/core/environment/enums/environment.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbolytics/turbolytics.dart';

/// A service that manages badge states across the application.
///
/// This service tracks various badge indicators including:
/// - Unread changelog notifications
/// - Household invites
/// - Shopping list counts
/// - Inbox badge visibility
///
/// The service coordinates with other services to determine when badges
/// should be shown or hidden based on application state.
class BadgeService with Turbolytics {
  /// Creates a new instance of [BadgeService] and initializes it.
  BadgeService() {
    initialise();
  }

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  /// Returns the singleton instance of [BadgeService].
  static BadgeService get locate => GetIt.I.get();

  /// Registers [BadgeService] as a lazy singleton in the GetIt service locator.
  ///
  /// Ensures proper disposal when the service is no longer needed.
  static void registerLazySingleton() =>
      GetIt.I.registerLazySingleton(BadgeService.new, dispose: (param) => param.dispose());

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final _localStorageService = LocalStorageService.locate;
  final _userService = UserService.locate;
  final _versionComparatorService = VersionComparatorService.locate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  /// Initializes the badge service by setting up dependencies and initial state.
  ///
  /// Waits for required services to be ready before checking badge states.
  /// Sets up listeners for household invites and checks for unread changelog.
  /// Completes the [_isReady] completer when initialization is done.
  Future<void> initialise() async {
    try {
      log.debug('Initializing BadgeService');
      log.debug('Waiting for local storage to be ready');
      await _localStorageService.isReady;

      log.debug('Waiting for user service to be ready');
      await _userService.isReady;

      log.debug('Checking for unread changelog');
      unawaited(manageHasUnreadChangelog());
    } catch (error, stackTrace) {
      log.error(
        '$error caught while initialising ${runtimeType.toString()}',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isReady.completeIfNotComplete();
      log.debug('BadgeService initialization complete');
    }
  }

  /// Cleans up resources used by the service.
  ///
  /// Removes listeners and resets the [_isReady] completer to ensure
  /// the service can be properly reinitialized if needed.
  void dispose() {
    log.debug('Disposing BadgeService');
    _isReady = Completer();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final _hasUnreadChangelog = TNotifier<bool>(false);
  final _showInboxBadge = TNotifier<bool>(false);
  var _isReady = Completer();

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  final _throttler = Throttler();

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  /// Whether there are unread changelog entries.
  ValueListenable<bool> get hasUnreadChangelog => _hasUnreadChangelog;

  /// Whether the inbox badge should be shown.
  ValueListenable<bool> get showInboxBadge => _showInboxBadge;

  /// A future that completes when the service is ready for use.
  Future get isReady => _isReady.future;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  /// Updates the inbox badge visibility based on unread changelog, household invites, and notifications.
  ///
  /// Uses throttling to prevent excessive updates when multiple state changes occur.
  void _manageShowInboxBadge() => _throttler.run(
    () => _showInboxBadge.update(
      _hasUnreadChangelog.value,
    ),
  );

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Determines whether to show the unread changelog badge.
  ///
  /// Compares the current app version with the last version where the user
  /// read the changelog. The comparison considers both local and remote
  /// (user profile) version records, using the more recent of the two.
  ///
  /// Updates [_hasUnreadChangelog] based on whether the current version
  /// is newer than the last read version.
  Future<void> manageHasUnreadChangelog() async {
    try {
      await _localStorageService.isReady;
      final currentVersion = Environment.currentVersion;
      if (currentVersion == null) {
        log.warning('Environment.currentVersion is null, cannot check for unread release notes');
        _hasUnreadChangelog.update(false);
        return;
      }

      final localVersion = _localStorageService.lastChangelogVersionRead;
      final remoteVersion = _userService.userDto.value?.lastChangelogVersionRead;

      log.debug('Current app version: $currentVersion');
      log.debug('Local lastChangelogVersionRead: $localVersion');
      log.debug('Remote lastChangelogVersionRead: $remoteVersion');

      // Determine effective last read version (newer of local/remote)
      String? effectiveLastReadVersion = localVersion;
      if (remoteVersion != null) {
        final isRemoteNewer =
            localVersion == null ||
            _versionComparatorService.isNewerVersion(
              currentVersion: remoteVersion,
              lastReadVersion: localVersion,
            );

        if (isRemoteNewer) {
          effectiveLastReadVersion = remoteVersion;
        }
      }

      log.debug('Effective last read version: $effectiveLastReadVersion');

      // Show badge if current version is newer than effective last read version
      final shouldShowBadge =
          effectiveLastReadVersion == null ||
          _versionComparatorService.isNewerVersion(
            currentVersion: currentVersion,
            lastReadVersion: effectiveLastReadVersion,
          );

      log.debug('Should show badge: $shouldShowBadge');
      _hasUnreadChangelog.update(shouldShowBadge);
    } catch (error, stackTrace) {
      log.error(
        '$error caught while managing unread changelog',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _manageShowInboxBadge();
    }
  }
}
