import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo_flutter_template/core/environment/enums/environment.dart';
import 'package:turbolytics/turbolytics.dart';

/// Configuration for connecting to Firebase emulators during development.
///
/// To use emulators, run your app with:
/// ```bash
/// flutter run --dart-define=env=emulators --dart-define=ip=YOUR_LOCAL_IP
/// ```
///
/// For physical devices or emulators, you must provide your development
/// machine's IP address. To find your IP on Mac: `ifconfig | grep "inet " | grep -v 127.0.0.1`
class EmulatorConfig {
  static const _localhost = 'localhost';
  static const _defaultHost = '127.0.0.1';

  static const _authPort = int.fromEnvironment('AUTH_PORT', defaultValue: 9099);
  static const _firestorePort = int.fromEnvironment('FIRESTORE_PORT', defaultValue: 8080);
  static const _functionsPort = int.fromEnvironment('FUNCTIONS_PORT', defaultValue: 5001);
  static const _storagePort = int.fromEnvironment('STORAGE_PORT', defaultValue: 9199);

  /// Whether emulators should be used for the current environment.
  static bool get _shouldUseEmulators => Environment.isEmulators || Environment.isDemo;

  /// Configures Firebase emulators if running in emulator or demo environment.
  ///
  /// Only configures emulators in debug mode when `env=emulators` or `env=demo` is set.
  static Future<void> tryConfigureEmulators() async {
    final log = TLog(location: 'EmulatorConfig');
    log.info('Checking if emulators should be configured...');
    log.info('Debug mode: $kDebugMode, Emulators enabled: $_shouldUseEmulators');

    if (kDebugMode && _shouldUseEmulators) {
      log.info('Configuring emulators...');

      final String host;

      if (kIsWeb) {
        host = _localhost;
        log.info('Using host for web: $host');
      } else if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        host = const String.fromEnvironment('ip', defaultValue: _defaultHost);
        log.info('Using host for mobile: $host');

        if (host == _defaultHost) {
          log.warning('Using default IP ($_defaultHost) which may not work on mobile devices.');
          log.warning(
            'Run with: flutter run --dart-define=ip=YOUR_IP --dart-define=env=emulators',
          );
        }
      } else {
        host = _defaultHost;
        log.info('Using host for desktop: $host');
      }

      try {
        log.info(
          'Using emulator ports -> auth:$_authPort firestore:$_firestorePort functions:$_functionsPort storage:$_storagePort',
        );

        log.info('Configuring Auth emulator at $host:$_authPort');
        await FirebaseAuth.instance.useAuthEmulator(host, _authPort);
        log.info('Auth emulator configured');

        log.info('Configuring Firestore emulator at $host:$_firestorePort');
        FirebaseFirestore.instance.useFirestoreEmulator(host, _firestorePort);
        log.info('Firestore emulator configured');

        log.info('Configuring Functions emulator at $host:$_functionsPort');
        FirebaseFunctions.instance.useFunctionsEmulator(host, _functionsPort);
        log.info('Functions emulator configured');

        log.info('Configuring Storage emulator at $host:$_storagePort');
        await FirebaseStorage.instance.useStorageEmulator(host, _storagePort);
        log.info('Storage emulator configured');

        final currentUser = FirebaseAuth.instance.currentUser;
        log.info(
          'Current auth state after emulator config: ${currentUser?.uid ?? "not authenticated"}',
        );

        log.info('All emulators configured successfully!');
      } catch (error, stackTrace) {
        log.error('Error configuring emulators!', error: error, stackTrace: stackTrace);
      }
    } else {
      log.info('Emulators not configured. Using production Firebase services.');
    }
  }
}
