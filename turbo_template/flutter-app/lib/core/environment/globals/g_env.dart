import 'package:turbo_flutter_template/core/environment/config/t_app_config.dart';
import 'package:turbo_flutter_template/core/environment/enums/environment.dart';
import 'package:turbo_flutter_template/core/environment/enums/supported_platform.dart';

/// The current platform the application is running on.
///
/// ```dart
/// if (gPlatform == SupportedPlatform.web) {
///   // Handle web-specific logic
/// }
/// ```
SupportedPlatform get gPlatform => SupportedPlatform.current;

/// The current environment type for the application.
///
/// ```dart
/// if (gEnvironment == EnvironmentType.emulator) {
///   // Use emulator endpoints
/// }
/// ```
EnvironmentType get gEnvironment => Environment.current;

/// Whether the application is running in staging.
///
/// ```dart
/// if (gIsStaging) {
///   // Use staging-specific logic
/// }
/// ```
bool get gIsStaging => Environment.isStaging;

/// Whether the application is running in production.
///
/// ```dart
/// if (gIsProd) {
///   analytics.logEvent('production_mode');
/// }
/// ```
bool get gIsProd => Environment.isProd;

/// The current client application configuration.
///
/// ```dart
/// final apiKey = gConfig.apiKey;
/// final appName = gConfig.appName;
/// ```
TAppConfig get gConfig => Environment.config;
