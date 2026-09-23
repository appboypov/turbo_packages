import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

part 't_role.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TRole extends TPromptable implements TSpawnable {
  const TRole({
    required this.id,
    required super.name,
    super.metaData,
    required this.expertise,
    this.instructions,
    this.tools,
    this.spawnConfig,
  });

  @override
  final String id;
  final List<TInstruction>? instructions;
  final List<TTool>? tools;
  final String expertise;

  @override
  @JsonKey(includeToJson: false)
  final TSpawnConfigDto? spawnConfig;

  factory TRole.fromJson(Map<String, dynamic> json) => _$TRoleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TRoleToJson(this);

  TRole copyWith({
    String? id,
    String? name,
    TMetaData? metaData,
    String? expertise,
    List<TInstruction>? instructions,
    List<TTool>? tools,
    TSpawnConfigDto? spawnConfig,
  }) => TRole(
    id: id ?? this.id,
    name: name ?? this.name,
    metaData: metaData ?? this.metaData,
    expertise: expertise ?? this.expertise,
    instructions: instructions ?? this.instructions,
    tools: tools ?? this.tools,
    spawnConfig: spawnConfig ?? this.spawnConfig,
  );
}
