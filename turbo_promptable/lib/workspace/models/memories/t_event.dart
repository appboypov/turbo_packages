import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_memory.dart';

part 't_event.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TEvent extends TMemory {
  const TEvent({
    required super.name,
    super.metaData,
  });

  factory TEvent.fromJson(Map<String, dynamic> json) => _$TEventFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TEventToJson(this);
}
