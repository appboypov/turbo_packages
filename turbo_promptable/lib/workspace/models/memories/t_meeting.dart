import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_memory.dart';

part 't_meeting.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TMeeting extends TMemory {
  const TMeeting({
    required super.name,
    super.metaData,
  });

  factory TMeeting.fromJson(Map<String, dynamic> json) =>
      _$TMeetingFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TMeetingToJson(this);
}
