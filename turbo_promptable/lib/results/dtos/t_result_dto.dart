import 'package:json_annotation/json_annotation.dart';

part 't_result_dto.g.dart';

/// Outcome of a finished local task.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TResultDto {
  const TResultDto({
    required this.summary,
    required this.completedAt,
    this.values = const [],
  });

  /// What was done, and what remains unresolved.
  final String summary;

  /// When the work was finished.
  final DateTime completedAt;

  /// Values the work produced, one per entry.
  final List<String> values;

  factory TResultDto.fromJson(Map<String, dynamic> json) =>
      _$TResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TResultDtoToJson(this);
}
