import 'package:json_annotation/json_annotation.dart';

part 't_trigger_hit_dto.g.dart';

/// One point of a trigger kind in a watched file.
@JsonSerializable(includeIfNull: false)
class TTriggerHitDto {
  const TTriggerHitDto({
    required this.file,
    required this.line,
    required this.text,
    this.trigger,
  });

  factory TTriggerHitDto.fromJson(Map<String, dynamic> json) =>
      _$TTriggerHitDtoFromJson(json);

  /// Absolute file path.
  final String file;

  /// One-based line number.
  final int line;

  /// Full line text as it was before the cut.
  final String text;

  /// Trigger text from start to end marker; null while the point is open.
  final String? trigger;

  /// Whether the point is still unfinished.
  bool get isOpen => trigger == null;

  Map<String, dynamic> toJson() => _$TTriggerHitDtoToJson(this);
}
