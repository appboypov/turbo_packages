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

  /// Privacy policy URL of the application.
  String get privacyPolicyUrl;

  /// Terms of service URL of the application.
  String get termsOfServiceUrl;
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

  @override
  String get privacyPolicyUrl => 'https://example.com/privacy';

  @override
  String get termsOfServiceUrl => 'https://example.com/terms';
}
