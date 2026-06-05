# Architecture

## Technology Stack

| Technology           | Version | Purpose                                                                                                           |
|----------------------|---------|-------------------------------------------------------------------------------------------------------------------|
| Dart SDK             | ^3.10.4 | Language runtime for the package and example app.                                                                 |
| Flutter              | SDK     | Flutter package support, example UI, test bindings, `Listenable`, `TimeOfDay`, and widget APIs.                   |
| cloud_firestore      | ^6.1.2  | Firestore reads, writes, streams, transactions, batches, query APIs, document references, timestamps, and errors. |
| firebase_auth        | ^6.1.4  | Auth-state synchronization for document and collection services.                                                  |
| json_annotation      | ^4.11.0 | JSON annotations for generated DTO serialization.                                                                 |
| meta                 | ^1.17.0 | `@mustCallSuper`, `@protected`, and constructor visibility annotations.                                           |
| rxdart               | ^0.28.0 | Reactive stream dependency declared by the package.                                                               |
| turbolytics          | ^1.1.0  | Service and API logging integration.                                                                              |
| turbo_response       | ^1.1.0  | Success/failure result wrapper for API, service, cache, and validation flows.                                     |
| turbo_serializable   | ^0.6.0  | `TWriteable`, `TWriteableId`, `TSerializable`, and serialization defaults.                                        |
| turbo_notifiers      | ^1.1.0  | Local state notifiers for document and collection services.                                                       |
| build_runner         | ^2.13.1 | Code generation runner for generated DTO JSON code.                                                               |
| json_serializable    | ^6.13.0 | Generates `TCachedQuery` JSON serialization.                                                                      |
| fake_cloud_firestore | ^4.0.1  | Firestore test double for API and service tests.                                                                  |
| flutter_test         | SDK     | Flutter test framework.                                                                                           |
| test                 | ^1.30.0 | Dart test framework.                                                                                              |
| coverage             | ^1.15.0 | Test coverage tooling.                                                                                            |
| flutter_lints        | ^6.0.0  | Static analysis lint rules.                                                                                       |
| firebase_core        | ^4.1.1  | Example app Firebase initialization.                                                                              |
| turbo_mvvm           | ^1.1.0  | Example app view model base class.                                                                                |

## Project Structure

```text
.
├── lib/
│   ├── abstracts/      Shared base classes, interfaces, and collection-management mixins.
│   ├── apis/           Firestore API facade plus operation mixins for create, read, list, search, stream, update, and delete.
│   ├── constants/      Firestore, auth, and error-code constants.
│   ├── dtos/           Package DTOs and generated DTO serialization.
│   ├── enums/          Operation, timestamp, parse, search, and user-id location enums.
│   ├── exceptions/     Firestore and invalid-JSON exception types.
│   ├── extensions/     Completer, list, and map extension helpers.
│   ├── factories/      Factory for building `TFirestoreApi` instances from collection metadata.
│   ├── generators/     Declarative dummy-data schema and deterministic value generators.
│   ├── mixins/         Firebase Auth exception handling mixin.
│   ├── models/         Runtime state, collection metadata, pagination, sensitive logging, and batch-reference models.
│   ├── services/       Auth-synchronized document and collection service layer.
│   ├── typedefs/       Callback contracts used by APIs and services.
│   ├── util/           Logger, mutex, and map-diff utilities.
│   └── turbo_firestore_api.dart  Public barrel export.
├── example/
│   └── lib/            Flutter example app with one API, DTO, model, view model, and view.
├── test/
│   ├── apis/           Firestore API operation tests.
│   ├── generators/     Dummy schema and generator tests.
│   ├── services/       Document-service tests.
│   └── util/           Utility tests.
├── workspace/          Archived task specs and dummy-data mockups.
├── pubspec.yaml        Package metadata and dependencies.
├── analysis_options.yaml
├── README.md
├── CHANGELOG.md
├── ACCEPTANCE.md
└── Makefile
```

## Architecture Patterns

The package uses a layered Firestore wrapper architecture.

| Pattern                           | Implementation                                                                                                                                                                        |
|-----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| API facade with operation mixins  | `TFirestoreApi` in `lib/apis/t_firestore_api.dart` extends `_TFirestoreApiBase` and mixes in operation-specific APIs from the `part` files.                                           |
| Service layer over API layer      | `TCollectionService` and `TDocService` own local state and call `TFirestoreApi` for remote reads, writes, batches, streams, and searches.                                             |
| Auth-aware stream synchronization | `TAuthSyncService` listens to `FirebaseAuth.instance.userChanges()`, ensures token readiness, subscribes to Firestore streams, and forwards stream data to service `onData` handlers. |
| Optimistic local state            | Services update `TNotifier` state before remote operations and roll back local changes on failed writes.                                                                              |
| Generic DTO/model mapping         | DTOs extend `TWriteableId`; models extend `TModel<DTO>`; service callbacks convert DTOs into domain models.                                                                           |
| Dependency injection by callback  | APIs and streams are injected through typedefs such as `TCollectionApiBuilderDef`, `TDocApiBuilderDef`, `TCollectionStreamBuilderDef`, and `TDocStreamBuilderDef`.                    |
| Public barrel exports             | `lib/turbo_firestore_api.dart` exports the package's public API surface.                                                                                                              |
| Example MVVM                      | `CloudFirestoreApiViewModel` extends `TBaseViewModel`; `TurboFirestoreApiView` uses `StreamBuilder` and `ExampleAPI`.                                                                 |

State management uses `TNotifier` and `ValueListenable` in services and `StreamBuilder` in the example view. There is no route table; the example app sets `MaterialApp.home` directly to `TurboFirestoreApiView`.

## Component Inventory

### DTOs / Models / Records / Entities

| Name                          | Path                                                         | Purpose                                                                                               |
|-------------------------------|--------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| `TCachedQuery`                | `lib/dtos/t_cached_query.dart`                               | Cache entry for one Firestore document or query result, with creation and update timestamps.          |
| `TCachedQuery` generated JSON | `lib/dtos/t_cached_query.g.dart`                             | Generated `fromJson` and `toJson` functions for `TCachedQuery`.                                       |
| `TModel`                      | `lib/abstracts/t_model.dart`                                 | Generic domain model wrapper around a `TWriteableId` DTO.                                             |
| `TFirestorePage`              | `lib/models/t_firestore_page.dart`                           | Page result containing items and an optional cursor.                                                  |
| `TFilterInput`                | `lib/models/t_filter_input.dart`                             | Runtime filter selection combining a filter option and an input value.                                |
| `TFirestoreCollection`        | `lib/models/t_firestore_collection.dart`                     | Collection metadata and factory methods for APIs, collection services, and document services.         |
| `TList`                       | `lib/models/t_list.dart`                                     | Sortable and filterable list wrapper for models.                                                      |
| `TModelDocs`                  | `lib/models/t_model_docs.dart`                               | ID-indexed collection state plus derived filtered/sorted list state.                                  |
| `TSensitiveData`              | `lib/models/t_sensitive_data.dart`                           | Structured logging context for paths, IDs, operation metadata, query descriptions, and document data. |
| `TVars`                       | `lib/models/t_vars.dart`                                     | Builder context containing IDs, user ID, timestamps, default/unknown values, and collection metadata. |
| `TWriteBatchWithReference`    | `lib/models/t_write_batch_with_reference.dart`               | Container that returns a `WriteBatch` with the affected `DocumentReference`.                          |
| `TDummySchemaField`           | `lib/generators/t_dummy_schema.dart`                         | Sealed base for dummy-data schema fields.                                                             |
| `TDummySchemaLeaf`            | `lib/generators/t_dummy_schema.dart`                         | Dummy schema leaf with a concrete Dart `Type`.                                                        |
| `TDummySchemaBranch`          | `lib/generators/t_dummy_schema.dart`                         | Dummy schema branch containing nested schema fields.                                                  |
| `TDummySchema`                | `lib/generators/t_dummy_schema.dart`                         | Dummy-data schema with resolved fields and unresolved field names.                                    |
| `ExampleDTO`                  | `example/lib/turbo_firestore_api/data/dtos/example_dto.dart` | Example Firestore DTO with validation and JSON serialization.                                         |
| `ExampleModel`                | `example/lib/turbo_firestore_api/data/dtos/example_dto.dart` | Example model wrapper around `ExampleDTO`.                                                            |

### Services / Providers / Managers

| Name                      | Path                                             | Purpose                                                                                                                     | Type (singleton/factory/lazy)                          | Dependencies                                                                                                                                                                     |
|---------------------------|--------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `TAuthSyncService`        | `lib/services/t_auth_sync_service.dart`          | Base service that synchronizes Firestore streams with Firebase Auth user state and token readiness.                         | Abstract base; per-subclass instance                   | `FirebaseAuth`, `FirebaseFirestore`, `TExceptionHandler`, `TFirestoreException`, `Turbolytics`.                                                                                  |
| `TCollectionService`      | `lib/services/t_collection_service.dart`         | Collection service with local state, reads, searches, optimistic create/update/upsert/delete, and batch operations.         | Factory instance; lazy `api` and `docsNotifier` fields | `TAuthSyncService`, `TFirestoreApi`, `TFirestoreCollection`, `TModelDocs`, `TNotifier`, `TCollectionApiBuilderDef`, `TCollectionStreamBuilderDef`, `TCollectionModelBuilderDef`. |
| `TDocService`             | `lib/services/t_doc_service.dart`                | Single-document service with local state, stream sync, missing-remote handling, and optimistic create/update/upsert/delete. | Factory instance; lazy `api` and `_doc` fields         | `TAuthSyncService`, `TFirestoreApi`, `TFirestoreCollection`, `TNotifier`, `TDocApiBuilderDef`, `TDocStreamBuilderDef`, `TDocModelBuilderDef`.                                    |
| `TPreCollectionService`   | `lib/services/t_pre_collection_service.dart`     | Collection service hook that runs before synced remote data updates local state.                                            | Abstract factory subclass                              | `TCollectionService`, `FirebaseAuth`.                                                                                                                                            |
| `TPostCollectionService`  | `lib/services/t_post_collection_service.dart`    | Collection service hook that runs after synced remote data updates local state.                                             | Abstract factory subclass                              | `TCollectionService`, `FirebaseAuth`.                                                                                                                                            |
| `THookCollectionService`  | `lib/services/t_hook_collection_service.dart`    | Collection service hooks that run before and after synced remote data updates local state.                                  | Abstract factory subclass                              | `TCollectionService`, `FirebaseAuth`.                                                                                                                                            |
| `TPreDocService`          | `lib/services/t_pre_document_service.dart`       | Document service hook that runs before synced remote data updates local state.                                              | Abstract factory subclass                              | `TDocService`, `FirebaseAuth`.                                                                                                                                                   |
| `TPostDocService`         | `lib/services/t_post_doc_service.dart`           | Document service hook that runs after synced remote data updates local state.                                               | Abstract factory subclass                              | `TDocService`, `FirebaseAuth`.                                                                                                                                                   |
| `THookDocService`         | `lib/services/t_hook_doc_service.dart`           | Document service hooks that run before and after synced remote data updates local state.                                    | Abstract factory subclass                              | `TDocService`, `FirebaseAuth`.                                                                                                                                                   |
| `TUserCollectionService`  | `lib/services/t_user_collection_service.dart`    | Collection service scoped to the authenticated user.                                                                        | Factory subclass                                       | `TCollectionService`, `FirebaseAuth`, `UserIdLocation`, `Turbolytics`.                                                                                                           |
| `TUserDocService`         | `lib/services/t_user_doc_service.dart`           | Document service scoped to the authenticated user.                                                                          | Factory subclass                                       | `TDocService`, `FirebaseAuth`, `UserIdLocation`, `Turbolytics`.                                                                                                                  |
| `TFirestoreCache`         | `lib/abstracts/i_firestore_cache_service.dart`   | Cache facade for document and query reads backed by `IFirestoreCacheService`.                                               | Factory instance                                       | `IFirestoreCacheService`, `TCachedQuery`, `TurboResponse`, `TLog`.                                                                                                               |
| `IFirestoreCacheService`  | `lib/abstracts/i_firestore_cache_service.dart`   | Abstract persistence contract for cached Firestore query entries.                                                           | Abstract base; subclass instance                       | `CompleterExtension`, `TCachedQuery`.                                                                                                                                            |
| `TValueGeneratorRegistry` | `lib/generators/t_value_generator_registry.dart` | Registry that resolves dummy values from field overrides, type overrides, bundled heuristics, and schema unresolved fields. | Factory instance via `build`                           | `TDummySchema`, `TValueGenerator`, `Random`, `Timestamp`, `GeoPoint`, `Blob`.                                                                                                    |

### APIs / Repositories / Controllers / Data Sources

| Name                      | Path                                                         | Purpose                                                                                                                                                       |
|---------------------------|--------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `_TFirestoreApiBase`      | `lib/apis/t_firestore_api.dart`                              | Library-private base that owns Firestore dependencies, conversion callbacks, cache, logging, helper methods, transactions, and shared exception construction. |
| `TFirestoreApi`           | `lib/apis/t_firestore_api.dart`                              | Public Firestore API facade combining create, get, list, search, stream, update, and delete mixins.                                                           |
| `TFirestoreCreateApi`     | `lib/apis/t_firestore_create_api.dart`                       | Create/write operations, batch create, transaction set support, timestamp insertion, validation, and merge handling.                                          |
| `TFirestoreDeleteApi`     | `lib/apis/t_firestore_delete_api.dart`                       | Delete operations for direct, batch, and transaction contexts.                                                                                                |
| `TurboFirestoreGetApi`    | `lib/apis/t_firestore_get_api.dart`                          | Single-document reads, typed reads, document references, typed document references, raw snapshots, and typed snapshots.                                       |
| `TurboFirestoreListApi`   | `lib/apis/t_firestore_list_api.dart`                         | Collection query listing, full collection listing, typed conversion, collection references, and cache integration.                                            |
| `TurboFirestoreSearchApi` | `lib/apis/t_firestore_search_api.dart`                       | Search-term query operations for raw and typed documents.                                                                                                     |
| `TurboFirestoreStreamApi` | `lib/apis/t_firestore_stream_api.dart`                       | Firestore collection, query, and document stream methods with raw and typed conversion.                                                                       |
| `TFirestoreUpdateApi`     | `lib/apis/t_firestore_update_api.dart`                       | Update operations, batch updates, timestamp insertion, diff updates from previous writeables, and deletion sentinel support.                                  |
| `TApiFactory`             | `lib/factories/t_api_factory.dart`                           | Builds `TFirestoreApi` from `TFirestoreCollection` metadata.                                                                                                  |
| `ExampleAPI`              | `example/lib/turbo_firestore_api/data/apis/example_api.dart` | Example data source backed by `TFirestoreApi<ExampleDTO>` with create and list methods.                                                                       |

### Views / Pages / Screens

| Name                    | Path                                                                                      | Purpose                                                                              | Route              | View Model              |
|-------------------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|--------------------|-------------------------|
| `MyApp`                 | `example/lib/main.dart`                                                                   | Example app root that initializes `MaterialApp`.                                     | App root           | None                    |
| `TurboFirestoreApiView` | `example/lib/turbo_firestore_api/views/turbo_firestore_api/turbo_firestore_api_view.dart` | Example screen that streams `ExampleDTO` records and creates new records from a FAB. | `MaterialApp.home` | None used by the widget |

### View Models / Hooks / Blocs / Cubits / Notifiers

| Name                         | Path                                                                                            | Purpose                                                                                             | Services Used                                   |
|------------------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|-------------------------------------------------|
| `CloudFirestoreApiViewModel` | `example/lib/turbo_firestore_api/views/turbo_firestore_api/turbo_firestore_api_view_model.dart` | Example view model that initializes Firebase and creates an example document during initialization. | `ExampleAPI`                                    |
| `TCollectionManagement`      | `lib/abstracts/t_collection_management.dart`                                                    | Mixin that exposes active sort/filter `ValueListenable`s and mutates collection service state.      | `TCollectionService`, `TNotifier`, `TModelDocs` |

### Widgets / Components

| Name                    | Path                                                                                      | Purpose                                         |
|-------------------------|-------------------------------------------------------------------------------------------|-------------------------------------------------|
| `MyApp`                 | `example/lib/main.dart`                                                                   | Stateless root widget for the example app.      |
| `TurboFirestoreApiView` | `example/lib/turbo_firestore_api/views/turbo_firestore_api/turbo_firestore_api_view.dart` | Stateless example Firestore list and create UI. |

### Enums / Constants / Config

| Name                    | Path                                                                         | Purpose                                                                                                                   |
|-------------------------|------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| `TAuthErrors`           | `lib/constants/t_auth_errors.dart`                                           | Firebase Auth error-code constants.                                                                                       |
| `TErrorCodes`           | `lib/constants/t_error_codes.dart`                                           | Firestore and generic error-code constants used by exceptions.                                                            |
| `TFirestoreApiDefaults` | `lib/constants/t_firestore_api_defaults.dart`                                | Default field names, local ID/reference behavior, collection-group behavior, stream initialization, and user-id location. |
| `TOperationType`        | `lib/enums/t_operation_type.dart`                                            | Firestore operation categories for logging and exceptions.                                                                |
| `TParseType`            | `lib/enums/t_parse_type.dart`                                                | Parse modes for JSON and converter reads.                                                                                 |
| `TSearchTermType`       | `lib/enums/t_search_term_type.dart`                                          | Search modes for prefix and array membership.                                                                             |
| `TTimestampType`        | `lib/enums/t_timestamp_type.dart`                                            | Timestamp insertion modes for create and update operations.                                                               |
| `UserIdLocation`        | `lib/enums/t_user_id_location.dart`                                          | User-scoped service path strategy.                                                                                        |
| Package pubspec         | `pubspec.yaml`                                                               | Package name, version, SDK constraint, dependencies, dev dependencies, repository metadata.                               |
| Analysis options        | `analysis_options.yaml`                                                      | Static analysis configuration.                                                                                            |
| Example pubspec         | `example/pubspec.yaml`                                                       | Example app metadata, workspace resolution, dependencies, and Flutter configuration.                                      |
| PLX config              | `example/lib/turbo_firestore_api/views/turbo_firestore_api/.plx/config.yaml` | Example view folder watcher, feedback, paste, and append settings.                                                        |

### Utils / Helpers / Extensions

| Name                           | Path                                      | Purpose                                                                                                       |
|--------------------------------|-------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| `CompleterExtension`           | `lib/extensions/completer_extension.dart` | Safely completes a `Completer` only when it is incomplete.                                                    |
| `TDtoListExtensionExtension`   | `lib/extensions/t_list_extension.dart`    | Converts DTO lists into ID maps, index maps, model maps, and model lists.                                     |
| `TModelListExtensionExtension` | `lib/extensions/t_list_extension.dart`    | Converts model lists into ID maps.                                                                            |
| `TMapExtension`                | `lib/extensions/t_map_extension.dart`     | Adds/removes local IDs and document references and adds timestamp fields to maps.                             |
| `TFirestoreLogger`             | `lib/util/t_firestore_logger.dart`        | Logging wrapper for debug, info, warning, and error messages with sensitive-data context.                     |
| `TMapDiff`                     | `lib/util/t_map_diff.dart`                | Produces Firestore update maps by diffing nested maps and emitting dot-notation changes and delete sentinels. |
| `TMutex`                       | `lib/util/t_mutex.dart`                   | FIFO async mutual-exclusion helper.                                                                           |
| `oneOf`                        | `lib/generators/t_value_specs.dart`       | Returns a generator that chooses one supplied value.                                                          |
| `oneOfEnum`                    | `lib/generators/t_value_specs.dart`       | Returns a generator that chooses one supplied enum value.                                                     |
| `rangeInt`                     | `lib/generators/t_value_specs.dart`       | Returns a bounded integer generator.                                                                          |
| `rangeDouble`                  | `lib/generators/t_value_specs.dart`       | Returns a bounded double generator.                                                                           |
| `sentence`                     | `lib/generators/t_value_specs.dart`       | Returns a lowercase sentence generator.                                                                       |
| `words`                        | `lib/generators/t_value_specs.dart`       | Returns a lowercase words generator.                                                                          |
| `paragraph`                    | `lib/generators/t_value_specs.dart`       | Returns a paragraph generator.                                                                                |
| `pastDate`                     | `lib/generators/t_value_specs.dart`       | Returns a past `DateTime` generator from a fixed UTC anchor.                                                  |
| `futureDate`                   | `lib/generators/t_value_specs.dart`       | Returns a future `DateTime` generator from a fixed UTC anchor.                                                |
| `uuid`                         | `lib/generators/t_value_specs.dart`       | Returns a deterministic sequential dummy ID generator.                                                        |
| `fixed`                        | `lib/generators/t_value_specs.dart`       | Returns a generator that always emits the supplied value.                                                     |

### Schemas / Validators

| Name                        | Path                                                         | Purpose                                                                                      | Validates                           |
|-----------------------------|--------------------------------------------------------------|----------------------------------------------------------------------------------------------|-------------------------------------|
| `TWriteable.validate` usage | `lib/apis/t_firestore_create_api.dart`                       | Rejects invalid writeable objects before create and batch-create writes.                     | DTO write payloads.                 |
| `TWriteable.validate` usage | `lib/apis/t_firestore_update_api.dart`                       | Rejects invalid writeable objects before update and batch-update writes.                     | DTO write payloads.                 |
| `ExampleDTO.validate`       | `example/lib/turbo_firestore_api/data/dtos/example_dto.dart` | Validates non-empty string and non-negative number fields.                                   | `ExampleDTO`.                       |
| `TDummySchema`              | `lib/generators/t_dummy_schema.dart`                         | Represents resolved and unresolved dummy-data fields.                                        | Dummy data generation schema shape. |
| `TValueGeneratorRegistry`   | `lib/generators/t_value_generator_registry.dart`             | Resolves values by field/type overrides and placeholder rules for unresolved schema fields.  | Dummy generated field values.       |
| `InvalidJsonException`      | `lib/exceptions/invalid_json_exception.dart`                 | Captures invalid JSON context when Firestore data cannot be parsed into expected model data. | Firestore JSON shape at runtime.    |

### Abstract Classes / Interfaces / Mixins

| Name                                      | Path                                           | Purpose                                                                |
|-------------------------------------------|------------------------------------------------|------------------------------------------------------------------------|
| `IFirestoreCacheService`                  | `lib/abstracts/i_firestore_cache_service.dart` | Interface for cache read, write, delete, init, and dispose operations. |
| `TCollectionManagement`                   | `lib/abstracts/t_collection_management.dart`   | Mixin for sort/filter management on `TCollectionService`.              |
| `TFilterOption`                           | `lib/abstracts/t_filter_option.dart`           | Abstract filter option exposing a predicate.                           |
| `TSortOption`                             | `lib/abstracts/t_sort_option.dart`             | Abstract sorter exposing a compare function.                           |
| `_TFirestoreApiBase`                      | `lib/apis/t_firestore_api.dart`                | Private base for operation mixins and shared API state.                |
| `TAuthSyncService`                        | `lib/services/t_auth_sync_service.dart`        | Abstract auth-aware stream service.                                    |
| `TExceptionHandler`                       | `lib/mixins/t_exception_handler.dart`          | Mixin that maps Firebase Auth exceptions to `TurboResponse` failures.  |
| `TFirestoreException`                     | `lib/exceptions/t_firestore_exception.dart`    | Sealed base exception for Firestore operation failures.                |
| `TurboFirestorePermissionDeniedException` | `lib/exceptions/t_firestore_exception.dart`    | Permission-denied Firestore exception variant.                         |
| `TurboFirestoreUnavailableException`      | `lib/exceptions/t_firestore_exception.dart`    | Unavailable Firestore exception variant.                               |
| `TurboFirestoreNotFoundException`         | `lib/exceptions/t_firestore_exception.dart`    | Not-found Firestore exception variant.                                 |
| `TurboFirestoreAlreadyExistsException`    | `lib/exceptions/t_firestore_exception.dart`    | Already-exists Firestore exception variant.                            |
| `TurboFirestoreCancelledException`        | `lib/exceptions/t_firestore_exception.dart`    | Cancelled Firestore exception variant.                                 |
| `TurboFirestoreDeadlineExceededException` | `lib/exceptions/t_firestore_exception.dart`    | Deadline-exceeded Firestore exception variant.                         |
| `TurboFirestoreGenericException`          | `lib/exceptions/t_firestore_exception.dart`    | Generic Firestore exception variant.                                   |

### Typedefs

| Name                          | Path                                             | Purpose                                               |
|-------------------------------|--------------------------------------------------|-------------------------------------------------------|
| `CollectionReferenceDef`      | `lib/typedefs/collection_reference_def.dart`     | Firestore collection-reference callback type.         |
| `CreateDocDef`                | `lib/typedefs/create_doc_def.dart`               | Service create-document builder callback.             |
| `TCollectionApiBuilderDef`    | `lib/typedefs/t_api_builder_def.dart`            | Collection service API builder callback.              |
| `TDocApiBuilderDef`           | `lib/typedefs/t_api_builder_def.dart`            | Document service API builder callback.                |
| `TFilterPredicate`            | `lib/typedefs/t_filter_predicate.dart`           | Filter predicate callback.                            |
| `TIdListDef`                  | `lib/typedefs/t_id_list_def.dart`                | List of IDs.                                          |
| `TIdListsMap`                 | `lib/typedefs/t_id_list_def.dart`                | Map of ID-list groups.                                |
| `TIdMapDef`                   | `lib/typedefs/t_id_map_def.dart`                 | Generic ID-to-value map.                              |
| `TModelBuilderDef`            | `lib/typedefs/t_model_builder_def.dart`          | DTO-to-model callback.                                |
| `TCollectionModelBuilderDef`  | `lib/typedefs/t_model_builder_def.dart`          | Collection service model builder callback.            |
| `TDocModelBuilderDef`         | `lib/typedefs/t_model_builder_def.dart`          | Document service model builder callback.              |
| `TModelDocsBuilderDef`        | `lib/typedefs/t_model_docs_builder_def.dart`     | Collection model-docs state builder callback.         |
| `TModelItemBuilderDef`        | `lib/typedefs/t_model_item_builder_def.dart`     | Flutter widget builder for a model item.              |
| `TCollectionStreamBuilderDef` | `lib/typedefs/t_stream_builder_def.dart`         | Collection stream builder callback.                   |
| `TDocStreamBuilderDef`        | `lib/typedefs/t_stream_builder_def.dart`         | Document stream builder callback.                     |
| `TCollectionValueBuilderDef`  | `lib/typedefs/t_value_builder_def.dart`          | Collection default or initial value builder callback. |
| `TDocValueBuilderDef`         | `lib/typedefs/t_value_builder_def.dart`          | Document default or initial value builder callback.   |
| `TWriteableItemBuilderDef`    | `lib/typedefs/t_writeable_item_builder_def.dart` | Flutter widget builder for a writeable item.          |
| `UpdateDocDef`                | `lib/typedefs/update_doc_def.dart`               | Service update-document builder callback.             |
| `UpsertDocDef`                | `lib/typedefs/upsert_doc_def.dart`               | Service upsert-document builder callback.             |
| `TValueGenerator`             | `lib/generators/t_value_generator.dart`          | Callback that produces one dummy value.               |

## Data Flow

### Package API Data Flow

1. Consumer code constructs `TFirestoreApi<DTO>` directly or through `TFirestoreCollection.api()` / `TApiFactory.create()`.
2. `TFirestoreApi` receives `FirebaseFirestore`, `collectionPath`, `fromJson`, `toJson`, field-name defaults, cache settings, and logger settings.
3. Read/list/search/stream methods call Firestore references and queries, add local IDs and document references through `TMapExtension`, and deserialize data through `fromJson`.
4. Create/update/delete methods validate `TWriteable` payloads, add timestamps through `TTimestampType`, remove local-only fields through `TMapExtension`, and write via `DocumentReference`, `WriteBatch`, or `Transaction`.
5. API errors are wrapped into `TFirestoreException` variants and returned or thrown through `TurboResponse`.

### Service Data Flow

1. Consumer code constructs `TCollectionService` or `TDocService` directly, or through `TFirestoreCollection.collectionService()` / `TFirestoreCollection.docService()`.
2. The service lazily creates a `TFirestoreApi` through an injected builder or collection metadata.
3. `TAuthSyncService` listens to Firebase Auth user changes, ensures token readiness, and subscribes to the service stream.
4. Stream values enter `onData`, are converted into models with `modelBuilder`, then stored in `TNotifier` state.
5. Local reads expose `TModelDocs`, `TList`, `MODEL`, `ValueListenable`, and `Listenable` state to consumers.
6. Local mutations update `TNotifier` state first, call the API, and roll back when remote writes fail.

### Example App Data Flow

1. `main()` initializes Firebase and runs `MyApp`.
2. `MyApp` sets `TurboFirestoreApiView` as `MaterialApp.home`.
3. `TurboFirestoreApiView` calls `ExampleAPI.locate.streamAllWithConverter()` in a `StreamBuilder`.
4. `ExampleAPI` extends `TFirestoreApi<ExampleDTO>` and maps the `Examples` collection to `ExampleDTO`.
5. The floating action button calls `ExampleAPI.locate.createExample()`, which creates a random `ExampleDTO` and writes it through `createDoc`.

## Dependency Graph

### API Layer

| Component                 | Depends On                                                                                                                                                                 | Relationship                                          |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| `TFirestoreApi`           | `_TFirestoreApiBase`                                                                                                                                                       | Inherits shared Firestore state and helpers.          |
| `TFirestoreApi`           | `TFirestoreCreateApi`, `TurboFirestoreGetApi`, `TurboFirestoreListApi`, `TurboFirestoreSearchApi`, `TurboFirestoreStreamApi`, `TFirestoreUpdateApi`, `TFirestoreDeleteApi` | Mixes in operation APIs.                              |
| `_TFirestoreApiBase`      | `FirebaseFirestore`                                                                                                                                                        | Executes Firestore operations.                        |
| `_TFirestoreApiBase`      | `TFirestoreCache`                                                                                                                                                          | Optional cache for reads and lists.                   |
| `_TFirestoreApiBase`      | `TFirestoreLogger`, `TSensitiveData`                                                                                                                                       | Logs operation context and errors.                    |
| `_TFirestoreApiBase`      | `TFirestoreException`                                                                                                                                                      | Builds structured exceptions for operation failures.  |
| `TFirestoreCreateApi`     | `TWriteable`, `TTimestampType`, `TWriteBatchWithReference`                                                                                                                 | Validates and writes create payloads.                 |
| `TFirestoreUpdateApi`     | `TWriteable`, `TTimestampType`, `TMapDiff`, `TWriteBatchWithReference`                                                                                                     | Validates and writes update payloads.                 |
| `TFirestoreDeleteApi`     | `TWriteBatchWithReference`                                                                                                                                                 | Deletes documents directly or in batches.             |
| `TurboFirestoreGetApi`    | `InvalidJsonException`, `TMapExtension`                                                                                                                                    | Reads and converts single documents.                  |
| `TurboFirestoreListApi`   | `TFirestoreCache`, `TMapExtension`, `InvalidJsonException`                                                                                                                 | Lists and converts collection documents.              |
| `TurboFirestoreSearchApi` | `TSearchTermType`                                                                                                                                                          | Builds query constraints for search terms.            |
| `TurboFirestoreStreamApi` | `TFirestoreException`, `TMapExtension`                                                                                                                                     | Streams raw and typed collection/query/document data. |

### Service Layer

| Component                | Depends On                            | Relationship                                                                                                                              |
|--------------------------|---------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `TAuthSyncService`       | `FirebaseAuth`                        | Watches authenticated user changes.                                                                                                       |
| `TAuthSyncService`       | `FirebaseFirestore`                   | Forces token-ready Firestore synchronization.                                                                                             |
| `TAuthSyncService`       | `TExceptionHandler`                   | Converts Firebase Auth errors.                                                                                                            |
| `TCollectionService`     | `TAuthSyncService`                    | Inherits auth-aware stream lifecycle.                                                                                                     |
| `TCollectionService`     | `TFirestoreApi`                       | Performs remote list, search, get, create, update, upsert, delete, batch create, batch update, batch upsert, and batch delete operations. |
| `TCollectionService`     | `TFirestoreCollection`                | Uses collection metadata and conversion functions.                                                                                        |
| `TCollectionService`     | `TModelDocs`, `TList`, `TNotifier`    | Maintains local collection state.                                                                                                         |
| `TDocService`            | `TAuthSyncService`                    | Inherits auth-aware stream lifecycle.                                                                                                     |
| `TDocService`            | `TFirestoreApi`                       | Performs remote document stream, create, update, upsert, and delete operations.                                                           |
| `TDocService`            | `TFirestoreCollection`, `TNotifier`   | Maintains local document state.                                                                                                           |
| `TUserCollectionService` | `TCollectionService`                  | Supplies user-scoped stream paths.                                                                                                        |
| `TUserDocService`        | `TDocService`                         | Supplies user-scoped stream paths.                                                                                                        |
| Pre/post/hook services   | `TCollectionService` or `TDocService` | Wrap `onData` to run sync hooks around local state updates.                                                                               |

### Example Layer

| Component                    | Depends On                             | Relationship                                                     |
|------------------------------|----------------------------------------|------------------------------------------------------------------|
| `MyApp`                      | `TurboFirestoreApiView`                | Sets the example screen as `MaterialApp.home`.                   |
| `TurboFirestoreApiView`      | `ExampleAPI`                           | Streams examples and creates examples.                           |
| `TurboFirestoreApiView`      | `ExampleDTO`                           | Renders example data.                                            |
| `CloudFirestoreApiViewModel` | `ExampleAPI`, `Firebase.initializeApp` | Creates an example document during initialization.               |
| `ExampleAPI`                 | `TFirestoreApi<ExampleDTO>`            | Uses package API operations for the `Examples` collection.       |
| `ExampleAPI`                 | `FirebaseFirestore.instance`           | Uses the default Firestore app instance.                         |
| `ExampleDTO`                 | `TWriteableId`, `TurboResponse`        | Provides ID, validation, and JSON payloads for Firestore writes. |

## Configuration

| Configuration            | Path                                                                         | Purpose                                                                                                                                                             |
|--------------------------|------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Package SDK constraint   | `pubspec.yaml`                                                               | Requires Dart `^3.10.4`.                                                                                                                                            |
| Package version          | `pubspec.yaml`                                                               | Publishes package version `0.13.0`.                                                                                                                                 |
| Workspace resolution     | `pubspec.yaml`                                                               | Uses `resolution: workspace`.                                                                                                                                       |
| Firestore field defaults | `lib/constants/t_firestore_api_defaults.dart`                                | Defines `createdAt`, `updatedAt`, `id`, `userId`, `docRef`, default ID values, local field behavior, collection-group behavior, and stream initialization defaults. |
| Analysis options         | `analysis_options.yaml`                                                      | Configures analyzer and lint behavior.                                                                                                                              |
| Example SDK constraint   | `example/pubspec.yaml`                                                       | Requires Dart `^3.10.4`.                                                                                                                                            |
| Example Flutter config   | `example/pubspec.yaml`                                                       | Enables Material icons through `uses-material-design: true`.                                                                                                        |
| Example Firebase init    | `example/lib/main.dart`                                                      | Calls `Firebase.initializeApp()` before running the example app.                                                                                                    |
| Example PLX watcher      | `example/lib/turbo_firestore_api/views/turbo_firestore_api/.plx/config.yaml` | Configures local watch, feedback, paste, and append behavior.                                                                                                       |

No environment-variable reads were found in `lib/`, `example/lib/`, or `test/`. No feature-flag framework was found.

## Testing Structure

| Test Area                      | Path                                                   | Coverage                                                                                                                     |
|--------------------------------|--------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| API update tests               | `test/apis/t_firestore_update_api_test.dart`           | Verifies update diff behavior, no-op updates, delete sentinels, and batch update behavior.                                   |
| Firestore cache tests          | `test/firestore_cache_test.dart`                       | Verifies cache invalidation by duration and weekday/time, document/list save and read, expiry deletion, and force refresh.   |
| Dummy schema tests             | `test/generators/t_dummy_schema_test.dart`             | Verifies dummy schema leaf/branch behavior and sealed switch handling.                                                       |
| Value generator registry tests | `test/generators/t_value_generator_registry_test.dart` | Verifies override precedence, heuristics, unresolved placeholders, determinism, and fallback values.                         |
| Value specs tests              | `test/generators/t_value_specs_test.dart`              | Verifies generator bounds, validation, deterministic IDs, fixed values, and date generation.                                 |
| Document service tests         | `test/services/t_doc_service_test.dart`                | Verifies identity-addressed creation, missing remote values, previous writeable capture, and remote update request wrapping. |
| Map diff tests                 | `test/util/t_map_diff_test.dart`                       | Verifies added, removed, changed, nested, list, null-before, and type-changed map diff cases.                                |

Testing uses `flutter_test` for Flutter-bound tests, `test` for pure Dart utility/generator tests, `fake_cloud_firestore` for Firestore-backed tests, and hand-written test doubles for write batches, document references, APIs, services, and cache persistence.
