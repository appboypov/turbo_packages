import 'package:json_annotation/json_annotation.dart';

part 't_trigger_kind_dto.g.dart';

/// One kind of text trigger: the pattern that finds it in a line and the
/// shell command that runs when one is finished.
@JsonSerializable(includeIfNull: false)
class TTriggerKindDto {
  const TTriggerKindDto({
    required this.name,
    required this.start,
    this.contains,
    required this.end,
    this.command,
  });

  factory TTriggerKindDto.fromJson(Map<String, dynamic> json) =>
      _$TTriggerKindDtoFromJson(json);

  /// Unique name of the kind, such as `task`.
  final String name;

  /// Literal marker that begins the trigger, such as `//`.
  final String start;

  /// Literal marker that must follow [start], such as `#TASK`.
  final String? contains;

  /// Literal marker that finishes the trigger when it ends the line, such as
  /// `;`.
  final String end;

  /// Shell command the plx server runs once per finished trigger, or null to
  /// leave this kind to others. It runs through `/bin/sh -c` in the watched
  /// folder and reads the trigger from `PLX_TRIGGER_KIND`, `PLX_TRIGGER_TEXT`,
  /// `PLX_TRIGGER_FILE`, `PLX_TRIGGER_LINE` and `PLX_TRIGGER_FOLDER`.
  final String? command;

  Map<String, dynamic> toJson() => _$TTriggerKindDtoToJson(this);
}
