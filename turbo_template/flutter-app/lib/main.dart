import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/my_app/my_app_view.dart';
import 'package:turbo_flutter_template/environment/config/emulator_config.dart';
import 'package:turbo_flutter_template/environment/enums/environment.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: Environment.current.firebaseOptions);
      }

      await EmulatorConfig.tryConfigureEmulators();

      FlutterError.onError = (errorDetails) {
        Log(location: 'FlutterError').error(
          'Flutter framework error',
          error: errorDetails.exception,
          stackTrace: errorDetails.stack,
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        Log(
          location: 'PlatformDispatcher',
        ).error('Uncaught async error', error: error, stackTrace: stack);
        return true;
      };

      runApp(const MyAppView());
    },
    (error, stack) {
      Log(
        location: 'Zoned',
      ).error('Unhandled exception caught: ${error.toString()}', error: error, stackTrace: stack);
    },
  );
  return;
}
