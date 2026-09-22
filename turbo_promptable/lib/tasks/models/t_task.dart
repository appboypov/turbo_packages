import 'package:turbo_promptable/tasks/dtos/t_task_dto.dart';

/// Local unit of work backed by a [TTaskDto].
class TTask {
  const TTask({required this.dto});

  /// Creates an open task created now.
  factory TTask.create({required String title, required String description}) =>
      TTask(
        dto: TTaskDto(
          title: title,
          description: description,
          createdAt: DateTime.now(),
        ),
      );

  final TTaskDto dto;
}
