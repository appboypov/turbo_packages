import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/results/dtos/t_result_dto.dart';

part 't_task_dto.g.dart';

/// Local unit of work.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TTaskDto {
  const TTaskDto({
    required this.title,
    required this.description,
    required this.createdAt,
    this.result,
  });

  /// Verb-first summary of the work.
  final String title;

  /// What the work requires.
  final String description;

  /// When the task was created.
  final DateTime createdAt;

  /// Set once the task is finished.
  final TResultDto? result;

  factory TTaskDto.fromJson(Map<String, dynamic> json) =>
      _$TTaskDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TTaskDtoToJson(this);
}
