import 'package:turbo_promptable/spawn/abstracts/t_spawnable.dart';
import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';
import 'package:turbo_promptable/workspace/models/root/t_agent.dart';
import 'package:turbo_promptable/workspace/models/root/t_role.dart';

/// Merges spawn configs from least to most specific: the [role]'s prompt as
/// system prompt, the [role], the [agent], then the [item] (task or issue).
///
/// The role is [agent]'s identity when an agent is given.
TSpawnConfigDto tSpawnConfigChain({
  TRole? role,
  TAgent? agent,
  TSpawnable? item,
}) {
  final effectiveRole = agent?.identity ?? role;
  return TSpawnConfigDto(systemPrompt: effectiveRole?.toMd())
      .overriddenBy(effectiveRole?.spawnConfig)
      .overriddenBy(agent?.spawnConfig)
      .overriddenBy(item?.spawnConfig);
}
