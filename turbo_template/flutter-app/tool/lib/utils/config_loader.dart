import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Loads template configuration from a YAML file.
class ConfigLoader {
  static const String configFileName = 'template.yaml';

  /// Loads config from template.yaml in the project root.
  ///
  /// Returns a map with the config values, or null if the file doesn't exist.
  static Future<Map<String, String>?> load(Directory projectRoot) async {
    final configFile = File(p.join(projectRoot.path, configFileName));

    if (!await configFile.exists()) {
      return null;
    }

    final content = await configFile.readAsString();
    final yaml = loadYaml(content) as YamlMap?;

    if (yaml == null) {
      return null;
    }

    return {
      if (yaml['name'] != null) 'name': yaml['name'].toString(),
      if (yaml['organization'] != null)
        'organization': yaml['organization'].toString(),
      if (yaml['description'] != null)
        'description': yaml['description'].toString(),
    };
  }

  /// Merges CLI arguments over config file values.
  ///
  /// CLI arguments take priority over config file values.
  static Map<String, String?> merge({
    Map<String, String>? fileConfig,
    String? cliName,
    String? cliOrg,
    String? cliDescription,
  }) {
    return {
      'name': cliName ?? fileConfig?['name'],
      'organization': cliOrg ?? fileConfig?['organization'],
      'description': cliDescription ??
          fileConfig?['description'] ??
          'A Flutter application.',
    };
  }
}
