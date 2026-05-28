import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_memory.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TMemory extends TPromptable {
  const TMemory({
    required super.name,
    super.metaData,
  });

  factory TMemory.fromJson(Map<String, dynamic> json) =>
      _$TMemoryFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TMemoryToJson(this);
}
