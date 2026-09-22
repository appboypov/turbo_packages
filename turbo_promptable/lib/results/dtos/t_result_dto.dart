import 'package:json_annotation/json_annotation.dart';

part 't_result_dto.g.dart';

/// Outcome of a finished local task.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TResultDto {
  const TResultDto({required this.summary, required this.completedAt});

  /// What was done, and what remains unresolved.
  final String summary;
  final DateTime completedAt;

  factory TResultDto.fromJson(Map<String, dynamic> json) =>
      _$TResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TResultDtoToJson(this);
}
