import 'package:turbo_promptable/spawn/enums/t_cli_tool.dart';
import 'package:turbo_promptable/spawn/enums/t_session_app.dart';
import 'package:turbo_promptable/spawn/enums/t_spawn_concept.dart';

/// plx spawn settings. Subclass it once in the `spawn/` folder of the plx
/// settings folder and declare one top-level value of the subclass.
abstract class TSpawnSettings {
  const TSpawnSettings();

  /// Per concept, the folders searched for an id, in order; the first match
  /// wins. A relative folder is read from the settings folder.
  Map<TSpawnConcept, List<String>> get searchFolders;

  /// Agent that runs a task or issue that names no agent.
  String get defaultAgentId;

  /// Tool a session runs when no config sets a tool.
  TCliTool get defaultTool;

  /// Folder a session starts in when no config sets a working folder. A
  /// relative folder is read from the settings folder.
  String get defaultWorkingFolder;

  /// App the session opens in.
  TSessionApp get sessionApp => TSessionApp.herdr;
}
