import 'package:json_annotation/json_annotation.dart';
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
    required super.name,
    required super.expertise,
    super.metaData,
    super.instructions,
    super.tools,
    this.identity,
  });

  final String? identity;

  TPersona.fromRole({
    required TRole role,
    required String identity,
    String? name,
    TMetaData? metaData,
    String? expertise,
    List<TInstruction>? instructions,
    List<TTool>? tools,
  }) : this(
         name: name ?? role.name,
         metaData: metaData ?? role.metaData,
         expertise: expertise ?? role.expertise,
         instructions: instructions ?? role.instructions,
         tools: tools ?? role.tools,
         identity: identity,
       );

  factory TPersona.fromJson(Map<String, dynamic> json) =>
      _$TPersonaFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TPersonaToJson(this);
}
