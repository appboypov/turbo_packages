import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_context.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TContext extends TPromptable {
  const TContext({
    required super.name,
  });

  factory TContext.fromJson(Map<String, dynamic> json) =>
      _$TContextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TContextToJson(this);
}
