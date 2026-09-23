import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';

/// Code entity that plx can start a session for, found by its [id].
abstract interface class TSpawnable {
  /// Unique id within its concept, used by `plx spawn <concept> --id <id>`.
  String get id;

  /// How this entity's session is spawned; overrides less specific configs.
  TSpawnConfigDto? get spawnConfig;
}
