import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:loglytics/loglytics.dart';
import 'package:turbo_flutter_template/environment/enums/environment.dart';

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

  /// Port configuration keys (lowercase to match shell scripts)
  static const _authPortKey = 'authPort';
  static const _firestorePortKey = 'firestorePort';
  static const _functionsPortKey = 'functionsPort';
  static const _storagePortKey = 'storagePort';

  /// Default ports matching firebase/firebase.json
  static const _defaultAuthPort = 9199;
  static const _defaultFirestorePort = 9180;
  static const _defaultFunctionsPort = 5001;
  static const _defaultStoragePort = 9199;

  static int _readPort(String key, int defaultValue) {
    final value = String.fromEnvironment(key, defaultValue: '$defaultValue');
    return int.tryParse(value) ?? defaultValue;
  }

  /// Whether emulators should be used for the current environment.
  static bool get _shouldUseEmulators => Environment.isEmulators || Environment.isDemo;

  /// Configures Firebase emulators if running in emulator or demo environment.
  ///
  /// Only configures emulators in debug mode when `env=emulators` or `env=demo` is set.
  static Future<void> tryConfigureEmulators() async {
    final log = Log(location: 'EmulatorConfig');
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
        final authPort = _readPort(_authPortKey, _defaultAuthPort);
        final firestorePort = _readPort(_firestorePortKey, _defaultFirestorePort);
        final functionsPort = _readPort(_functionsPortKey, _defaultFunctionsPort);
        final storagePort = _readPort(_storagePortKey, _defaultStoragePort);

        log.info(
          'Using emulator ports -> auth:$authPort firestore:$firestorePort functions:$functionsPort storage:$storagePort',
        );

        log.info('Configuring Auth emulator at $host:$authPort');
        await FirebaseAuth.instance.useAuthEmulator(host, authPort);
        log.info('Auth emulator configured');

        log.info('Configuring Firestore emulator at $host:$firestorePort');
        FirebaseFirestore.instance.useFirestoreEmulator(host, firestorePort);
        log.info('Firestore emulator configured');

        log.info('Configuring Functions emulator at $host:$functionsPort');
        FirebaseFunctions.instance.useFunctionsEmulator(host, functionsPort);
        log.info('Functions emulator configured');

        log.info('Configuring Storage emulator at $host:$storagePort');
        await FirebaseStorage.instance.useStorageEmulator(host, storagePort);
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
