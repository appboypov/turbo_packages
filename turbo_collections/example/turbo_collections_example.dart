// ignore_for_file: avoid_print

import 'package:turbo_collections/turbo_collections.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

class TaskDto extends TWriteableId {
  TaskDto({required this.id, required this.title, required this.estimate});

  @override
  final String id;

  final String title;

  final int estimate;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'estimate': estimate,
  };
}

class TaskModel extends TModel<TaskDto> {
  const TaskModel({required super.dto});

  int get estimate => dto.estimate;
}

class LowEstimate extends TFilterOption<TaskModel> {
  @override
  TFilterPredicate<TaskModel> get predicate =>
      (model, input) => input is int && model.estimate <= input;
}

void main() {
  final docs = TModelDocs<TaskDto, TaskModel>.empty(
    modelBuilder: (dto) => TaskModel(dto: dto),
  );

  docs.upsertDtos([
    TaskDto(id: 'task-1', title: 'Write the README', estimate: 2),
    TaskDto(id: 'task-2', title: 'Publish the package', estimate: 8),
  ]);
  docs.updateFilters({
    TFilterInput.fromOptionWithInput(option: LowEstimate(), input: 5),
  });

  print(docs.get('task-2')?.dto.title);
  print(docs.list.map((task) => task.dto.title));
}
