import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration for the staging environment.
///
/// Project: your-project-name-staging
class StagingFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'StagingFirebaseOptions have not been configured for $defaultTargetPlatform - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'StagingFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_STAGING_WEB_API_KEY',
    appId: '1:YOUR_STAGING_PROJECT_NUMBER:web:YOUR_STAGING_WEB_APP_ID',
    messagingSenderId: 'YOUR_STAGING_PROJECT_NUMBER',
    projectId: 'your-project-id-staging',
    authDomain: 'your-project-id-staging.firebaseapp.com',
    storageBucket: 'your-project-id-staging.firebasestorage.app',
    measurementId: 'G-YOUR_STAGING_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_STAGING_ANDROID_API_KEY',
    appId: '1:YOUR_STAGING_PROJECT_NUMBER:android:YOUR_STAGING_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_STAGING_PROJECT_NUMBER',
    projectId: 'your-project-id-staging',
    storageBucket: 'your-project-id-staging.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_STAGING_IOS_API_KEY',
    appId: '1:YOUR_STAGING_PROJECT_NUMBER:ios:YOUR_STAGING_IOS_APP_ID',
    messagingSenderId: 'YOUR_STAGING_PROJECT_NUMBER',
    projectId: 'your-project-id-staging',
    storageBucket: 'your-project-id-staging.firebasestorage.app',
    iosBundleId: 'your.bundle.id',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_STAGING_MACOS_API_KEY',
    appId: '1:YOUR_STAGING_PROJECT_NUMBER:ios:YOUR_STAGING_MACOS_APP_ID',
    messagingSenderId: 'YOUR_STAGING_PROJECT_NUMBER',
    projectId: 'your-project-id-staging',
    storageBucket: 'your-project-id-staging.firebasestorage.app',
    iosBundleId: 'your.bundle.id',
  );
}
