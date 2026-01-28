import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:turbo_flutter_template/core/environment/config/emulator_config.dart';
import 'package:turbo_flutter_template/core/environment/enums/environment.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/locator_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/my_app/my_app_view.dart';
import 'package:turbolytics/turbolytics.dart';

void main() {
  runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(options: Environment.current.firebaseOptions);
        }
      } on FirebaseException catch (e) {
        if (e.code == 'duplicate-app') {
          // Firebase is already initialized, which is fine
          // This can happen during hot reload
        } else {
          // Re-throw other Firebase exceptions
          rethrow;
        }
      }

      await EmulatorConfig.tryConfigureEmulators();

      FlutterError.onError = (errorDetails) {
        TLog(location: 'FlutterError').error(
          'Flutter framework error',
          error: errorDetails.exception,
          stackTrace: errorDetails.stack,
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        TLog(
          location: 'PlatformDispatcher',
        ).error('Uncaught async error', error: error, stackTrace: stack);
        return true;
      };

      LocatorService.locate.registerInitialDependencies();
      runApp(Phoenix(child: const MyAppView()));
    },
        (error, stack) {
      TLog(
        location: 'Zoned',
      ).error('Unhandled exception caught: ${error.toString()}', error: error, stackTrace: stack);
    },
  );
  return;
}
