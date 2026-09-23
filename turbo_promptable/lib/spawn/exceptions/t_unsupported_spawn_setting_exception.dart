import 'package:turbo_promptable/spawn/enums/t_cli_tool.dart';

/// Thrown when a spawn config sets a [setting] that [tool] cannot express.
class TUnsupportedSpawnSettingException implements Exception {
  const TUnsupportedSpawnSettingException({
    required this.tool,
    required this.setting,
  });

  final TCliTool tool;
  final String setting;

  @override
  String toString() =>
      'TUnsupportedSpawnSettingException: ${tool.name} cannot set $setting.';
}
