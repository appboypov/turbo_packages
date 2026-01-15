import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo_flutter_template/environment/config/t_app_config.dart';
import 'package:turbo_flutter_template/firebase_options.dart';

/// Manages environment configuration and settings for the application.
///
/// Provides access to environment-specific configuration, Firebase options,
/// and environment type detection. Supports overriding environment and config
/// for testing purposes.
///
/// Usage:
/// ```bash
/// flutter run --dart-define=env=emulators
/// flutter run --dart-define=env=demo
/// flutter run --dart-define=env=staging
/// flutter run --dart-define=env=prod
/// ```
abstract class Environment {
  static const String _emulators = 'emulators';
  static const String _demo = 'demo';
  static const String _staging = 'staging';
  static const String _prod = 'prod';

  /// Key used for environment arguments.
  static const argumentKey = 'env';

  /// Key used to signal whether to use device preview.
  static const devicePreviewKey = 'preview';

  /// Key used for configuration settings.
  static const configKey = 'config';

  static EnvironmentType? _environmentOverride;
  static TAppConfig? _configOverride;

  /// Overrides the current environment type.
  ///
  /// Used primarily for testing to force a specific environment.
  static void environmentOverride({required EnvironmentType environmentType}) =>
      _environmentOverride = environmentType;

  /// Overrides the current configuration.
  ///
  /// Used primarily for testing to force a specific configuration.
  static void configOverride<T extends TAppConfig>({required T config}) => _configOverride = config;

  /// The current application configuration.
  ///
  /// Returns the overridden config if set, otherwise determines config based on
  /// environment settings.
  static TAppConfig get config {
    if (_configOverride != null) return _configOverride!;

    switch (const String.fromEnvironment(Environment.configKey)) {
      case TemplateAppConfig.configKey:
        return const TemplateAppConfig();
      default:
        return const TemplateAppConfig();
    }
  }

  /// The current environment type.
  ///
  /// Returns the overridden environment if set, otherwise determines environment
  /// based on build arguments.
  static EnvironmentType get current {
    if (_environmentOverride == null) {
      switch (const String.fromEnvironment(Environment.argumentKey)) {
        case _emulators:
          return EnvironmentType.emulators;
        case _demo:
          return EnvironmentType.demo;
        case _staging:
          return EnvironmentType.staging;
        case _prod:
        default:
          return EnvironmentType.prod;
      }
    }
    return _environmentOverride!;
  }

  /// Whether the current environment is using emulators.
  static bool get isEmulators => current == EnvironmentType.emulators;

  /// Whether the current environment is demo mode.
  ///
  /// Demo mode is used for automated testing and store screenshots.
  /// Uses emulators for Firebase but enables demo-specific behavior.
  static bool get isDemo => current == EnvironmentType.demo;

  /// Whether the current environment is staging.
  static bool get isStaging => current == EnvironmentType.staging;

  /// Whether the current environment is production.
  static bool get isProd => current == EnvironmentType.prod;

  /// Whether to use device preview.
  static bool get shouldInitDevicePreview {
    const value = String.fromEnvironment(Environment.devicePreviewKey);
    return value == 'true';
  }
}

/// Represents different environment types for the application.
enum EnvironmentType {
  /// Environment using local emulators for development.
  emulators,

  /// Demo mode for automated testing and store screenshots.
  /// Uses emulators for Firebase but enables demo-specific behavior.
  demo,

  /// Staging environment for internal testing.
  staging,

  /// Production environment using live services.
  prod;

  /// Gets the Firebase options configuration for this environment.
  ///
  /// Configure separate Firebase projects for staging and production.
  /// For emulators and demo, uses the production config but connects to local emulators.
  FirebaseOptions get firebaseOptions {
    if (kIsWeb) {
      return switch (this) {
        EnvironmentType.emulators => DefaultFirebaseOptions.web,
        EnvironmentType.demo => DefaultFirebaseOptions.web,
        EnvironmentType.staging => DefaultFirebaseOptions.web, // TODO: Add staging web config
        EnvironmentType.prod => DefaultFirebaseOptions.web,
      };
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return switch (this) {
          EnvironmentType.emulators => DefaultFirebaseOptions.android,
          EnvironmentType.demo => DefaultFirebaseOptions.android,
          EnvironmentType.staging =>
            DefaultFirebaseOptions.android, // TODO: Add staging android config
          EnvironmentType.prod => DefaultFirebaseOptions.android,
        };
      case TargetPlatform.iOS:
        return switch (this) {
          EnvironmentType.emulators => DefaultFirebaseOptions.ios,
          EnvironmentType.demo => DefaultFirebaseOptions.ios,
          EnvironmentType.staging => DefaultFirebaseOptions.ios, // TODO: Add staging ios config
          EnvironmentType.prod => DefaultFirebaseOptions.ios,
        };
      case TargetPlatform.macOS:
        return switch (this) {
          EnvironmentType.emulators => DefaultFirebaseOptions.macos,
          EnvironmentType.demo => DefaultFirebaseOptions.macos,
          EnvironmentType.staging => DefaultFirebaseOptions.macos, // TODO: Add staging macos config
          EnvironmentType.prod => DefaultFirebaseOptions.macos,
        };
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }
}
