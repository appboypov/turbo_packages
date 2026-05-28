import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_memory.dart';

part 't_progress.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TProgress extends TMemory {
  const TProgress({
    required super.name,
    super.metaData,
  });

  factory TProgress.fromJson(Map<String, dynamic> json) =>
      _$TProgressFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TProgressToJson(this);
}
