import 'package:turbo_flutter_template/environment/config/t_app_config.dart';
import 'package:turbo_flutter_template/environment/enums/environment.dart';
import 'package:turbo_flutter_template/environment/enums/supported_platform.dart';

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
/// if (gEnvironment == EnvironmentType.emulators) {
///   // Use emulator endpoints
/// }
/// ```
EnvironmentType get gEnvironment => Environment.current;

/// Whether the application is running with emulators.
///
/// ```dart
/// if (gIsEmulators) {
///   // Use emulator-specific logic
/// }
/// ```
bool get gIsEmulators => Environment.isEmulators;

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

/// Whether the application is running in demo mode.
///
/// Demo mode is used for automated testing and store screenshots.
/// Uses emulators for Firebase but enables demo-specific behavior.
///
/// ```dart
/// if (gIsDemo) {
///   // Hide debug banners, use mock data, etc.
/// }
/// ```
bool get gIsDemo => Environment.isDemo;

/// The current client application configuration.
///
/// ```dart
/// final appName = gConfig.appName;
/// ```
TAppConfig get gConfig => Environment.config;
