/// Abstract configuration class for app-specific settings.
///
/// Extend this class to create app-specific configurations.
/// Each configuration should have a unique [key] for identification
/// via `--dart-define=config=<key>`.
abstract class TAppConfig {
  const TAppConfig();

  /// Unique identifier for this configuration.
  String get key;

  /// Display name of the application.
  String get appName;
}

/// Default template app configuration.
///
/// Replace this with your app-specific configuration.
class TemplateAppConfig extends TAppConfig {
  const TemplateAppConfig();

  static const String configKey = 'template';

  @override
  String get key => configKey;

  @override
  String get appName => 'Turbo Template';
}
