import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Default values used in the template. Single source of truth for find-replace operations.
class TemplateDefaults {
  static const packageName = 'turbo_flutter_template';
  static const camelCasePackageName = 'turboFlutterTemplate';
  static const pascalCasePackageName = 'TurboFlutterTemplate';
  static const organization = 'app.apewpew';
  static const appName = 'Turbo Template';
  static const displayName = 'Turbo Flutter Template';
  static const description = 'A turbo Flutter project.';
  static const privacyPolicyUrl = 'https://example.com/privacy';
  static const termsOfServiceUrl = 'https://example.com/terms';
  static const supportUrl = 'https://example.com/support';
  static const prodProjectId = 'a-pew-pew-app';
  static const stagingProjectId = 'a-pew-pew-app-staging';
}

/// Configuration loaded from turbo_template_config.yaml.
class TemplateConfig {
  TemplateConfig({
    required this.packageName,
    required this.organization,
    required this.description,
    required this.appName,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.supportUrl,
    required this.prodProjectId,
    required this.stagingProjectId,
    required this.templatePath,
    required this.lastCommitSync,
    required this.syncUpwards,
  });

  final String packageName;
  final String organization;
  final String description;
  final String appName;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String supportUrl;
  final String prodProjectId;
  final String stagingProjectId;
  final String templatePath;
  final String? lastCommitSync;
  final List<String> syncUpwards;

  /// Derived values for common transformations.
  String get camelCasePackageName => _toCamelCase(packageName);
  String get pascalCasePackageName => _toPascalCase(packageName);
  String get bundleId => '$organization.${camelCasePackageName}';
  String get displayName => _toDisplayName(packageName);

  static String _toCamelCase(String snakeCase) {
    final parts = snakeCase.split('_');
    return parts.first + parts.skip(1).map(_capitalize).join();
  }

  static String _toPascalCase(String snakeCase) {
    return snakeCase.split('_').map(_capitalize).join();
  }

  static String _toDisplayName(String snakeCase) {
    return snakeCase.split('_').map(_capitalize).join(' ');
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

/// Parses a YAML value that may be null or the string "null".
String? _parseNullableString(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  if (str == 'null' || str.isEmpty) return null;
  return str;
}

/// Reads and parses the turbo_template_config.yaml file.
class ConfigReader {
  static const String configFileName = 'turbo_template_config.yaml';

  /// Loads the configuration from the template root directory.
  ///
  /// [templateRoot] should be the root directory containing turbo_template_config.yaml.
  static Future<TemplateConfig?> load(Directory templateRoot) async {
    final configFile = File(p.join(templateRoot.path, configFileName));

    if (!await configFile.exists()) {
      return null;
    }

    final content = await configFile.readAsString();
    final yaml = loadYaml(content) as YamlMap;

    final app = yaml['app'] as YamlMap;
    final urls = yaml['urls'] as YamlMap;
    final firebase = yaml['firebase'] as YamlMap;
    final sync = yaml['sync'] as YamlMap;

    final syncUpwardsList = <String>[];
    if (sync['sync_upwards'] != null) {
      for (final item in sync['sync_upwards'] as YamlList) {
        syncUpwardsList.add(item.toString());
      }
    }

    return TemplateConfig(
      packageName: app['package_name']?.toString() ?? TemplateDefaults.packageName,
      organization: app['organization']?.toString() ?? TemplateDefaults.organization,
      description: app['description']?.toString() ?? TemplateDefaults.description,
      appName: app['app_name']?.toString() ?? TemplateDefaults.appName,
      privacyPolicyUrl: urls['privacy_policy']?.toString() ?? TemplateDefaults.privacyPolicyUrl,
      termsOfServiceUrl: urls['terms_of_service']?.toString() ?? TemplateDefaults.termsOfServiceUrl,
      supportUrl: urls['support']?.toString() ?? TemplateDefaults.supportUrl,
      prodProjectId: firebase['prod_project_id']?.toString() ?? TemplateDefaults.prodProjectId,
      stagingProjectId: firebase['staging_project_id']?.toString() ?? TemplateDefaults.stagingProjectId,
      templatePath: sync['template_path']?.toString() ?? 'flutter-app',
      lastCommitSync: _parseNullableString(sync['last_commit_sync']),
      syncUpwards: syncUpwardsList,
    );
  }
}
