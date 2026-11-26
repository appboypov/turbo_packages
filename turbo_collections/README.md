# TurboCollections

The models and lists of documents that the turbo services share, in pure Dart. A service keeps its documents as `TModelDocs`, which holds an id map and a sorted and filtered `TList` of `TModel` objects. The package has no Flutter, Firestore or Firebase dependencies, so a service on any backend uses the same models as the services of `turbo_firestore_api`.

## Features

- `TModel` wraps a DTO that extends `TWriteableId` of `turbo_serializable` and gives its `id`.
- `TModelDocs` keeps the models of a collection by id and in a sorted and filtered list, and upserts DTOs or models.
- `TList` sorts and filters models with a `TSortOption` and a set of `TFilterInput` objects.
- `TFilterOption` names a filter predicate, and `TFilterInput` binds an option to an input value.

## Usage

```dart
class TaskModel extends TModel<TaskDto> {
  const TaskModel({required super.dto});

  int get estimate => dto.estimate;
}

class LowEstimate extends TFilterOption<TaskModel> {
  @override
  TFilterPredicate<TaskModel> get predicate =>
      (model, input) => input is int && model.estimate <= input;
}

final docs = TModelDocs<TaskDto, TaskModel>.empty(
  modelBuilder: (dto) => TaskModel(dto: dto),
);

docs.upsertDtos(dtos);
docs.updateFilters({
  TFilterInput.fromOptionWithInput(option: LowEstimate(), input: 5),
});

final task = docs.get('task-1');
```

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  turbo_collections: ^0.1.0
```

`turbo_firestore_api` depends on this package and exports it, so a Firestore app needs no extra dependency.

## Additional information

For more examples and detailed API documentation, visit the [API reference](https://pub.dev/documentation/turbo_collections/latest/).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
