import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/results/dtos/t_result_dto.dart';

part 't_task_dto.g.dart';

/// Local task created from one feedback trigger.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TTaskDto {
  const TTaskDto({
    required this.title,
    required this.feedback,
    required this.file,
    required this.line,
    required this.createdAt,
    this.result,
  });

  /// Verb-first summary of the requested work.
  final String title;

  /// Trigger text as the user wrote it.
  final String feedback;

  /// Absolute path of the file that held the trigger.
  final String file;

  /// One-based line of the trigger in [file].
  final int line;
  final DateTime createdAt;

  /// Set once the task is finished.
  final TResultDto? result;

  factory TTaskDto.fromJson(Map<String, dynamic> json) =>
      _$TTaskDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TTaskDtoToJson(this);
}
