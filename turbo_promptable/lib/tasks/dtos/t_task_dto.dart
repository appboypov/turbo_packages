import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/results/dtos/t_result_dto.dart';
import 'package:turbo_promptable/tasks/enums/t_task_status.dart';

part 't_task_dto.g.dart';

/// Local unit of work.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TTaskDto {
  const TTaskDto({
    required this.title,
    required this.body,
    required this.createdAt,
    this.status = TTaskStatus.inbox,
    this.result,
  });

  /// Verb-first summary of the work.
  final String title;

  /// What the work requires.
  final String body;

  /// When the task was created.
  final DateTime createdAt;

  /// Where the task is in its workflow.
  final TTaskStatus status;

  /// Set once the task is finished.
  final TResultDto? result;

  factory TTaskDto.fromJson(Map<String, dynamic> json) =>
      _$TTaskDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TTaskDtoToJson(this);

  TTaskDto copyWith({
    String? title,
    String? body,
    TTaskStatus? status,
    TResultDto? result,
  }) {
    return TTaskDto(
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt,
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }
}
