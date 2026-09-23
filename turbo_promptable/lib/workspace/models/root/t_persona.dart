import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';
import 'package:turbo_promptable/workspace/models/root/t_instruction.dart';
import 'package:turbo_promptable/workspace/models/root/t_role.dart';
import 'package:turbo_promptable/workspace/models/root/t_tool.dart';

part 't_persona.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class TPersona extends TRole {
  const TPersona({
    required super.id,
    required super.name,
    required super.expertise,
    super.metaData,
    super.instructions,
    super.tools,
    super.spawnConfig,
    this.identity,
  });

  final String? identity;

  TPersona.fromRole({
    required TRole role,
    required String identity,
    String? id,
    String? name,
    TMetaData? metaData,
    String? expertise,
    List<TInstruction>? instructions,
    List<TTool>? tools,
    TSpawnConfigDto? spawnConfig,
  }) : this(
         id: id ?? role.id,
         name: name ?? role.name,
         metaData: metaData ?? role.metaData,
         expertise: expertise ?? role.expertise,
         instructions: instructions ?? role.instructions,
         tools: tools ?? role.tools,
         spawnConfig: spawnConfig ?? role.spawnConfig,
         identity: identity,
       );

  factory TPersona.fromJson(Map<String, dynamic> json) =>
      _$TPersonaFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TPersonaToJson(this);
}
