import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

part 't_role.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TRole extends TPromptable {
  const TRole({
    required super.name,
    super.metaData,
    required this.expertise,
    this.instructions,
    this.tools,
  });

  final List<TInstruction>? instructions;
  final List<TTool>? tools;
  final String expertise;

  factory TRole.fromJson(Map<String, dynamic> json) => _$TRoleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TRoleToJson(this);

  TRole copyWith({
    String? name,
    TMetaData? metaData,
    String? expertise,
    List<TInstruction>? instructions,
    List<TTool>? tools,
  }) => TRole(
    name: name ?? this.name,
    metaData: metaData ?? this.metaData,
    expertise: expertise ?? this.expertise,
    instructions: instructions ?? this.instructions,
    tools: tools ?? this.tools,
  );
}
