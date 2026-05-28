import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_context.dart';

part 't_actor.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TActor extends TContext {
  const TActor({
    required super.name,
  });

  factory TActor.fromJson(Map<String, dynamic> json) => _$TActorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TActorToJson(this);
}
