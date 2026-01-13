# Architecture

## Overview
turbo_packages is a Melos-managed monorepo containing 8 Dart/Flutter packages that provide foundational utilities for building robust applications.

## Project Setup

### Prerequisites
- Dart SDK ^3.6.0
- Flutter SDK (for Flutter-dependent packages)
- Melos 7.x (installed via dev dependency)

### Installation
```bash
dart pub get
melos bootstrap
```

### Development
```bash
melos analyze    # Run static analysis
melos format     # Check formatting
melos test       # Run tests
melos build_runner  # Generate code
melos pub-check  # Validate packages for 160/160 pub points
```

## Technology Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Language** | Dart 3.6+ | Core language |
| **Framework** | Flutter | UI framework for Flutter packages |
| **Monorepo** | Melos 7.x | Workspace management |
| **Dependency Resolution** | Pub workspaces | Internal package resolution |
| **State Management** | Provider | MVVM pattern support |
| **Dependency Injection** | GetIt | Service locator pattern |
| **Database** | Cloud Firestore | Remote data storage |
| **Authentication** | Firebase Auth | User authentication |
| **Serialization** | json_serializable | Code generation for JSON |
| **Reactive** | RxDart | Reactive extensions |
| **Routing** | go_router | Navigation (template app) |

### Key Dependencies by Package

| Package | Key Dependencies |
|---------|------------------|
| **turbo_response** | None (foundation package) |
| **turbo_serializable** | turbo_response, change_case, xml, yaml |
| **turbo_notifiers** | Flutter SDK |
| **turbo_mvvm** | provider |
| **turbolytics** | get_it |
| **turbo_firestore_api** | cloud_firestore, firebase_auth, rxdart, turbo_response, turbo_serializable |
| **turbo_promptable** | turbo_serializable, turbo_response, json_annotation |
| **turbo_template/flutter-app** | Multiple (see package pubspec) |

## Project Structure

```
turbo_packages/
├── pubspec.yaml              # Root workspace config
├── CHANGELOG.md              # Monorepo changelog
├── README.md                 # Monorepo documentation
├── Makefile                  # Build automation
├── tool/                     # Build scripts
├── turbo_response/           # Result type (Success/Fail)
├── turbo_serializable/       # Multi-format serialization
├── turbo_notifiers/          # Enhanced ValueNotifier
├── turbo_mvvm/               # MVVM state management
├── turbolytics/              # Logging & analytics
├── turbo_firestore_api/      # Firestore API wrapper
├── turbo_promptable/         # AI prompting framework
├── turbo_template/            # Flutter app template
│   └── flutter-app/          # Template application
└── workspace/
    ├── AGENTS.md             # AI assistant instructions
    ├── ARCHITECTURE.md       # This file
    ├── specs/                # Capability specifications
    ├── changes/              # Change proposals
    └── tasks/                # Implementation tasks
```

## Package Architecture

### Dependency Graph
```
turbo_response (foundation - no deps)
    └── turbo_serializable
            ├── turbo_promptable
            └── turbo_firestore_api

turbo_notifiers (standalone)
turbo_mvvm (standalone)
turbolytics (standalone)
turbo_template/flutter-app (uses turbo_response)
```

### Package Categories

**Pure Dart Packages**
- turbo_response: Result type for operation outcomes
- turbo_serializable: JSON/YAML/Markdown/XML serialization
- turbo_promptable: AI agent prompt definitions

**Flutter Packages**
- turbo_notifiers: Enhanced ValueNotifier
- turbo_mvvm: ViewModel pattern implementation
- turbolytics: Logging and analytics
- turbo_firestore_api: Firestore abstraction

**Template Application**
- turbo_template/flutter-app: Complete Flutter app template with Firebase integration

## Architecture Patterns

### MVVM (Model-View-ViewModel)
- **Package**: `turbo_mvvm`
- **Pattern**: ViewModels manage UI state, Views are stateless
- **Base Classes**: `TurboViewModel`, `AkeBaseViewModel`
- **Widgets**: `TurboViewModelBuilder`, `ViewModelWidget`

### Service Layer Pattern
- **Location**: `turbo_firestore_api`, `turbo_template/flutter-app`
- **Pattern**: Services encapsulate business logic and state management
- **Base Classes**: `TurboAuthSyncService`, `TurboDocumentService`, `TurboCollectionService`

### Dependency Injection
- **Package**: `turbolytics`, `turbo_template/flutter-app`
- **Pattern**: Service locator via GetIt
- **Service**: `LocatorService` manages all service registrations

### Repository Pattern (via API)
- **Package**: `turbo_firestore_api`
- **Pattern**: API classes act as data access layer
- **Base**: `TurboFirestoreApi` with extension mixins

### Result Pattern
- **Package**: `turbo_response`
- **Pattern**: Type-safe success/failure handling
- **Usage**: All operations return `TurboResponse<T>`

## Component Inventory

### DTOs / Models / Records / Entities

| Name | Path | Purpose | Package |
|------|------|---------|---------|
| **TurboResponse** | `turbo_response/lib/src/turbo_response.dart` | Type-safe response wrapper | turbo_response |
| **TurboException** | `turbo_response/lib/src/turbo_exception.dart` | Custom exception type | turbo_response |
| **TurboViewModel** | `turbo_mvvm/lib/data/models/turbo_view_model.dart` | Base ViewModel class | turbo_mvvm |
| **AkeBaseViewModel** | `turbo_mvvm/lib/data/models/ake_base_view_model.dart` | Auto-keep-alive ViewModel | turbo_mvvm |
| **BusyModel** | `turbo_mvvm/lib/data/models/busy_model.dart` | Busy state representation | turbo_mvvm |
| **TurboApiVars** | `turbo_firestore_api/lib/models/turbo_api_vars.dart` | Core Firestore document variables | turbo_firestore_api |
| **TurboAuthVars** | `turbo_firestore_api/lib/models/turbo_auth_vars.dart` | Auth-aware document variables | turbo_firestore_api |
| **SensitiveData** | `turbo_firestore_api/lib/models/sensitive_data.dart` | Encapsulates sensitive operation data | turbo_firestore_api |
| **WriteBatchWithReference** | `turbo_firestore_api/lib/models/write_batch_with_reference.dart` | Firestore batch operation container | turbo_firestore_api |
| **TeamDto** | `turbo_promptable/lib/teams/dtos/team_dto.dart` | Top-level organizational unit | turbo_promptable |
| **AreaDto** | `turbo_promptable/lib/areas/dtos/area_dto.dart` | Domain within a team | turbo_promptable |
| **RoleDto** | `turbo_promptable/lib/roles/dtos/role_dto.dart` | Specialist role definition | turbo_promptable |
| **PersonaDto** | `turbo_promptable/lib/roles/dtos/persona_dto.dart` | Agent identity definition | turbo_promptable |
| **ExpertiseDto** | `turbo_promptable/lib/roles/dtos/expertise_dto.dart` | Expertise definition | turbo_promptable |
| **ActivityDto** | `turbo_promptable/lib/activities/dtos/activity_dto.dart` | AI command definition | turbo_promptable |
| **SubAgentDto** | `turbo_promptable/lib/activities/dtos/sub_agent_dto.dart` | AI agent definition | turbo_promptable |
| **EndGoalDto** | `turbo_promptable/lib/activities/dtos/end_goal_dto.dart` | End goal definition | turbo_promptable |
| **GuardRailDto** | `turbo_promptable/lib/activities/dtos/guard_rail_dto.dart` | Safety constraints | turbo_promptable |
| **WorkflowDto** | `turbo_promptable/lib/workflows/dtos/workflow_dto.dart` | Step-by-step process | turbo_promptable |
| **WorkflowStep** | `turbo_promptable/lib/workflows/dtos/workflow_step.dart` | Individual workflow step | turbo_promptable |
| **CollectionDto** | `turbo_promptable/lib/office/dtos/collection_dto.dart` | Knowledge organization list | turbo_promptable |
| **InstructionDto** | `turbo_promptable/lib/activities/dtos/instruction_dto.dart` | How-to guides | turbo_promptable |
| **ReferenceDto** | `turbo_promptable/lib/office/dtos/reference_dto.dart` | Static documentation | turbo_promptable |
| **TemplateDto** | `turbo_promptable/lib/office/dtos/template_dto.dart` | Reusable patterns | turbo_promptable |
| **RawBoxDto** | `turbo_promptable/lib/office/dtos/raw_box_dto.dart` | Raw input materials | turbo_promptable |
| **RepoDto** | `turbo_promptable/lib/office/dtos/repo_dto.dart` | Repository reference | turbo_promptable |
| **ApiDto** | `turbo_promptable/lib/tools/dtos/api_dto.dart` | HTTP/REST API tool | turbo_promptable |
| **ScriptDto** | `turbo_promptable/lib/tools/dtos/script_dto.dart` | Executable script tool | turbo_promptable |
| **MetaDataDto** | `turbo_promptable/lib/shared/dtos/meta_data_dto.dart` | Common metadata | turbo_promptable |
| **KeyMetadata** | `turbo_serializable/lib/models/key_metadata.dart` | Serialization key metadata | turbo_serializable |
| **TurboSerializableConfig** | `turbo_serializable/lib/models/turbo_serializable_config.dart` | Serialization configuration | turbo_serializable |
| **XmlMeta** | `turbo_serializable/lib/models/xml_meta.dart` | XML-specific metadata | turbo_serializable |
| **YamlMeta** | `turbo_serializable/lib/models/yaml_meta.dart` | YAML-specific metadata | turbo_serializable |
| **JsonMeta** | `turbo_serializable/lib/models/json_meta.dart` | JSON-specific metadata | turbo_serializable |
| **CalloutMeta** | `turbo_serializable/lib/models/callout_meta.dart` | Markdown callout metadata | turbo_serializable |
| **CodeBlockMeta** | `turbo_serializable/lib/models/code_block_meta.dart` | Code block metadata | turbo_serializable |
| **DividerMeta** | `turbo_serializable/lib/models/divider_meta.dart` | Divider metadata | turbo_serializable |
| **EmphasisMeta** | `turbo_serializable/lib/models/emphasis_meta.dart` | Text emphasis metadata | turbo_serializable |
| **ListMeta** | `turbo_serializable/lib/models/list_meta.dart` | List formatting metadata | turbo_serializable |
| **TableMeta** | `turbo_serializable/lib/models/table_meta.dart` | Table formatting metadata | turbo_serializable |
| **WhitespaceMeta** | `turbo_serializable/lib/models/whitespace_meta.dart` | Whitespace handling metadata | turbo_serializable |
| **LayoutAwareParseResult** | `turbo_serializable/lib/models/layout_aware_parse_result.dart` | Parse result model | turbo_serializable |

### Services / Providers / Managers

| Name | Path | Type | Dependencies | Package |
|------|------|------|--------------|---------|
| **BusyService** | `turbo_mvvm/lib/services/busy_service.dart` | Singleton | ValueNotifier, Mutex | turbo_mvvm |
| **TurboAuthSyncService** | `turbo_firestore_api/lib/services/turbo_auth_sync_service.dart` | Abstract | FirebaseAuth, Loglytics | turbo_firestore_api |
| **TurboDocumentService** | `turbo_firestore_api/lib/services/turbo_document_service.dart` | Abstract | TurboAuthSyncService, TurboFirestoreApi | turbo_firestore_api |
| **BeSyncTurboDocumentService** | `turbo_firestore_api/lib/services/be_sync_turbo_document_service.dart` | Abstract | TurboDocumentService | turbo_firestore_api |
| **BeAfSyncTurboDocumentService** | `turbo_firestore_api/lib/services/be_af_sync_turbo_document_service.dart` | Abstract | TurboDocumentService | turbo_firestore_api |
| **AfSyncTurboDocumentService** | `turbo_firestore_api/lib/services/af_sync_turbo_document_service.dart` | Abstract | TurboDocumentService | turbo_firestore_api |
| **TurboCollectionService** | `turbo_firestore_api/lib/services/turbo_collection_service.dart` | Abstract | TurboAuthSyncService, TurboFirestoreApi | turbo_firestore_api |
| **BeforeSyncTurboCollectionService** | `turbo_firestore_api/lib/services/before_sync_turbo_collection_service.dart` | Abstract | TurboCollectionService | turbo_firestore_api |
| **BeforeAfterSyncTurboCollectionService** | `turbo_firestore_api/lib/services/before_after_sync_turbo_collection_service.dart` | Abstract | TurboCollectionService | turbo_firestore_api |
| **AfterSyncTurboCollectionService** | `turbo_firestore_api/lib/services/after_sync_turbo_collection_service.dart` | Abstract | TurboCollectionService | turbo_firestore_api |
| **AnalyticsService** | `turbolytics/lib/src/analytics/analytics_service.dart` | Service | Log, EventBus | turbolytics |
| **LocatorService** | `turbo_template/flutter-app/lib/core/infrastructure/inject-dependencies/services/locator_service.dart` | Singleton | GetIt, Loglytics | turbo_template |
| **AuthService** | `turbo_template/flutter-app/lib/core/auth/authenticate-users/services/auth_service.dart` | Lazy Singleton | FirebaseAuth, RxDart, Informers | turbo_template |
| **EmailService** | `turbo_template/flutter-app/lib/core/auth/authenticate-users/services/email_service.dart` | Factory | FirebaseAuth, Loglytics | turbo_template |
| **ConnectionService** | `turbo_template/flutter-app/lib/core/connection/manage-connection/services/connection_service.dart` | Lazy Singleton | Connectivity, Loglytics | turbo_template |
| **BaseRouterService** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/services/base_router_service.dart` | Lazy Singleton | GoRouter, AuthService | turbo_template |
| **NavigationTabService** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/services/navigation_tab_service.dart` | Lazy Singleton | Loglytics, Informers | turbo_template |
| **PackageInfoService** | `turbo_template/flutter-app/lib/core/infrastructure/show-version/services/package_info_service.dart` | Regular | PackageInfo | turbo_template |
| **LocalStorageService** | `turbo_template/flutter-app/lib/core/storage/save-local-data/services/local_storage_service.dart` | Lazy Singleton | ChangeNotifier, Loglytics | turbo_template |
| **OverlayService** | `turbo_template/flutter-app/lib/core/ui/show-ui/services/overlay_service.dart` | Lazy Singleton | Loglytics, BuildContext | turbo_template |
| **ThemeService** | `turbo_template/flutter-app/lib/core/ui/show-ui/services/theme_service.dart` | Lazy Singleton | Loglytics, Informers, LocalStorageService | turbo_template |
| **LanguageService** | `turbo_template/flutter-app/lib/core/ux/manage-language/services/language_service.dart` | Lazy Singleton | Loglytics, Informers, LocalStorageService | turbo_template |
| **ShakeGestureService** | `turbo_template/flutter-app/lib/core/ux/provide-feedback/services/shake_gesture_service.dart` | Lazy Singleton | Loglytics, VibrateService, OverlayService | turbo_template |
| **ToastService** | `turbo_template/flutter-app/lib/core/ux/provide-feedback/services/toast_service.dart` | Lazy Singleton | Loglytics, BuildContext | turbo_template |
| **VibrateService** | `turbo_template/flutter-app/lib/core/ux/provide-feedback/services/vibrate_service.dart` | Lazy Singleton | Loglytics, Haptics | turbo_template |
| **SyncService** | `turbo_template/flutter-app/lib/core/state/manage-state/abstracts/sync_service.dart` | Abstract | Loglytics | turbo_template |

### APIs / Repositories / Controllers / Data Sources

| Name | Path | Purpose | Package |
|------|------|---------|---------|
| **TurboFirestoreApi** | `turbo_firestore_api/lib/apis/turbo_firestore_api.dart` | Main Firestore API wrapper | turbo_firestore_api |
| **TurboFirestoreCreateApi** | `turbo_firestore_api/lib/apis/turbo_firestore_create_api.dart` | Create operations extension | turbo_firestore_api |
| **TurboFirestoreGetApi** | `turbo_firestore_api/lib/apis/turbo_firestore_get_api.dart` | Read/get operations extension | turbo_firestore_api |
| **TurboFirestoreListApi** | `turbo_firestore_api/lib/apis/turbo_firestore_list_api.dart` | List operations extension | turbo_firestore_api |
| **TurboFirestoreStreamApi** | `turbo_firestore_api/lib/apis/turbo_firestore_stream_api.dart` | Real-time streaming extension | turbo_firestore_api |
| **TurboFirestoreSearchApi** | `turbo_firestore_api/lib/apis/turbo_firestore_search_api.dart` | Search operations extension | turbo_firestore_api |
| **TurboFirestoreUpdateApi** | `turbo_firestore_api/lib/apis/turbo_firestore_update_api.dart` | Update operations extension | turbo_firestore_api |
| **TurboFirestoreDeleteApi** | `turbo_firestore_api/lib/apis/turbo_firestore_delete_api.dart` | Delete operations extension | turbo_firestore_api |

### Views / Pages / Screens

| Name | Path | Route | View Model | Package |
|------|------|-------|------------|---------|
| **MyAppView** | `turbo_template/flutter-app/lib/core/infrastructure/run-app/views/my_app/my_app_view.dart` | N/A (Root) | MyAppViewModel | turbo_template |
| **ShellView** | `turbo_template/flutter-app/lib/core/infrastructure/run-app/views/shell/shell_view.dart` | `/` | ShellViewModel | turbo_template |
| **AuthView** | `turbo_template/flutter-app/lib/core/auth/authenticate-users/views/auth/auth_view.dart` | `/auth` | AuthViewModel | turbo_template |
| **HomeView** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/views/home_view.dart` | `/home` | None | turbo_template |

### View Models / Hooks / Blocs / Cubits / Notifiers

| Name | Path | Services Used | Package |
|------|------|---------------|---------|
| **AuthViewModel** | `turbo_template/flutter-app/lib/core/auth/authenticate-users/views/auth/auth_view_model.dart` | ToastService, EmailService, AuthService, LoginForm, RegisterForm, ForgotPasswordForm | turbo_template |
| **ShellViewModel** | `turbo_template/flutter-app/lib/core/infrastructure/run-app/views/shell/shell_view_model.dart` | AuthService | turbo_template |
| **MyAppViewModel** | `turbo_template/flutter-app/lib/core/infrastructure/run-app/views/my_app/my_app_view_model.dart` | BaseRouterService, BusyService, ConnectionService, LocatorService, LocalStorageService, LanguageService, ThemeService, ShakeGestureService, AuthService | turbo_template |
| **TurboNotifier** | `turbo_notifiers/lib/turbo_notifier.dart` | None (base class) | turbo_notifiers |
| **TurboChangeNotifier** | `turbo_notifiers/lib/turbo_change_notifier.dart` | None (base class) | turbo_notifiers |

### Widgets / Components

| Name | Path | Purpose | Package |
|------|------|---------|---------|
| **TurboViewModelBuilder** | `turbo_mvvm/lib/widgets/turbo_view_model_builder.dart` | Builds and provides ViewModel to widget tree | turbo_mvvm |
| **ViewModelWidget** | `turbo_mvvm/lib/widgets/view_model_widget.dart` | Generic widget for view model-driven architecture | turbo_mvvm |
| **FadeIn** | `turbo_template/flutter-app/lib/core/ui/show-animations/widgets/fade_in.dart` | Animated fade transition | turbo_template |
| **TAnimatedText** | `turbo_template/flutter-app/lib/core/ui/show-animations/widgets/t_animated_text.dart` | Animates text changes | turbo_template |
| **TAnimatedGap** | `turbo_template/flutter-app/lib/core/ui/show-animations/widgets/t_animated_gap.dart` | Animates size changes for spacing | turbo_template |
| **VerticalShrink** | `turbo_template/flutter-app/lib/core/ui/show-animations/widgets/vertical_shrink.dart` | Vertically shrinks/expands content | turbo_template |
| **TProvider** | `turbo_template/flutter-app/lib/core/ui/show-ui/widgets/t_provider.dart` | Theme data provider | turbo_template |
| **TProviderBuilder** | `turbo_template/flutter-app/lib/core/ui/show-ui/widgets/t_provider_builder.dart` | Builds TProvider with responsive layout | turbo_template |
| **IsBusyIcon** | `turbo_template/flutter-app/lib/core/state/manage-state/widgets/is_busy_icon.dart` | Displays loading indicator | turbo_template |
| **Unfocusable** | `turbo_template/flutter-app/lib/core/state/manage-state/widgets/unfocusable.dart` | GestureDetector that unfocuses on tap | turbo_template |
| **ValueListenableBuilderX2** | `turbo_template/flutter-app/lib/core/state/manage-state/widgets/value_listenable_builder_x2.dart` | Listens to two ValueListenables | turbo_template |

### Enums / Constants / Config

| Name | Path | Purpose | Package |
|------|------|---------|---------|
| **TurboTimestampType** | `turbo_firestore_api/lib/enums/turbo_timestamp_type.dart` | Automatic timestamp management | turbo_firestore_api |
| **TurboSearchTermType** | `turbo_firestore_api/lib/enums/turbo_search_term_type.dart` | Search operation types | turbo_firestore_api |
| **TurboParseType** | `turbo_firestore_api/lib/enums/turbo_parse_type.dart` | Parsing strategy | turbo_firestore_api |
| **BusyType** | `turbo_mvvm/lib/data/enums/busy_type.dart` | Busy/loading indicator types | turbo_mvvm |
| **WorkflowStepType** | `turbo_promptable/lib/activities/enums/workflow_step_type.dart` | Workflow process phases | turbo_promptable |
| **AnalyticsTypes** | `turbolytics/lib/src/enums/analytics_types.dart` | Analytics event types (97 values) | turbolytics |
| **CaseStyle** | `turbo_serializable/lib/enums/case_style.dart` | String casing transformation styles | turbo_serializable |
| **Environment** | `turbo_template/flutter-app/lib/environment/enums/environment.dart` | Environment configuration types | turbo_template |
| **KErrorCodes** | `turbo_firestore_api/lib/constants/k_error_codes.dart` | Error codes and messages | turbo_firestore_api |
| **TurboConstants** | `turbo_serializable/lib/constants/turbo_constants.dart` | Serialization constants | turbo_serializable |
| **DataKeys** | `turbo_template/flutter-app/lib/core/storage/manage-data/constants/data_keys.dart` | Storage key constants | turbo_template |
| **TAppConfig** | `turbo_template/flutter-app/lib/environment/config/t_app_config.dart` | App configuration base class | turbo_template |
| **TemplateAppConfig** | `turbo_template/flutter-app/lib/environment/config/t_app_config.dart` | Template app configuration | turbo_template |

### Utils / Helpers / Extensions

| Name | Path | Purpose | Package |
|------|------|---------|---------|
| **CompleterExtension** | `turbo_firestore_api/lib/extensions/completer_extension.dart` | Safely completes Completer | turbo_firestore_api |
| **TurboListExtension** | `turbo_firestore_api/lib/extensions/turbo_list_extension.dart` | Converts list to ID map | turbo_firestore_api |
| **TurboMapExtension** | `turbo_firestore_api/lib/extensions/turbo_map_extension.dart` | Adds timestamps to maps | turbo_firestore_api |
| **TurboMutex** | `turbo_firestore_api/lib/util/turbo_mutex.dart` | Mutual exclusion utility | turbo_firestore_api |
| **TurboFirestoreLogger** | `turbo_firestore_api/lib/util/turbo_firestore_logger.dart` | Logging with sensitive data handling | turbo_firestore_api |
| **ViewModelHelpers** | `turbo_mvvm/lib/data/mixins/view_model_helpers.dart` | ViewModel utility methods | turbo_mvvm |
| **StringExtension** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/extensions/string_extension.dart` | Navigation string utilities | turbo_template |
| **ContextExtension** | `turbo_template/flutter-app/lib/core/state/manage-state/extensions/context_extension.dart` | Quick access to theme properties | turbo_template |
| **AnimationExtension** | `turbo_template/flutter-app/lib/core/ui/show-animations/extensions/animation_extension.dart` | Animation helpers | turbo_template |
| **ColorExtension** | `turbo_template/flutter-app/lib/core/ui/show-ui/extensions/color_extension.dart` | Color manipulation utilities | turbo_template |
| **Debouncer** | `turbo_template/flutter-app/lib/core/state/manage-state/utils/debouncer.dart` | Debounces function calls | turbo_template |
| **Mutex** | `turbo_template/flutter-app/lib/core/state/manage-state/utils/mutex.dart` | Mutex implementation | turbo_template |
| **TTools** | `turbo_template/flutter-app/lib/core/ui/show-ui/utils/t_tools.dart` | Responsive design utilities | turbo_template |
| **CaseConverter** | `turbo_template/flutter-app/tool/lib/utils/case_converter.dart` | Case conversion utilities | turbo_template |
| **ConfigLoader** | `turbo_template/flutter-app/tool/lib/utils/config_loader.dart` | Configuration loading | turbo_template |

### Routing / Navigation

| Name | Path | Auth Required | Purpose | Package |
|------|------|---------------|---------|---------|
| **BaseRouterService** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/services/base_router_service.dart` | N/A | Manages app routing | turbo_template |
| **Shell Route** | `/` | No | Root shell container | turbo_template |
| **Auth Route** | `/auth` | No | Authentication view | turbo_template |
| **Home Route** | `/home` | Yes (commented) | Home view (template) | turbo_template |
| **Routes Constants** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/constants/routes.dart` | N/A | Route path constants | turbo_template |
| **NavigationTab** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/enums/navigation_tab.dart` | N/A | Bottom navigation tabs | turbo_template |
| **ViewType** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/enums/view_type.dart` | N/A | View type enumeration | turbo_template |
| **RouterType** | `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/enums/router_type.dart` | N/A | Router type enumeration | turbo_template |

### Schemas / Validators

| Name | Path | Validates | Package |
|------|------|-----------|---------|
| **TurboSerializable.validate** | `turbo_serializable/lib/abstracts/turbo_serializable.dart` | Base validation for serializable objects | turbo_serializable |
| **kValueValidatorsMultiple** | `turbo_template/flutter-app/lib/core/ux/manage-input/constants/k_value_validators.dart` | Combines multiple validators | turbo_template |
| **kValueValidatorsIsTrue** | `turbo_template/flutter-app/lib/core/ux/manage-input/constants/k_value_validators.dart` | Validates boolean is true | turbo_template |
| **kValueValidatorsRequired** | `turbo_template/flutter-app/lib/core/ux/manage-input/constants/k_value_validators.dart` | Validates required fields | turbo_template |
| **kValueValidatorsEmail** | `turbo_template/flutter-app/lib/core/ux/manage-input/constants/k_value_validators.dart` | Validates email format | turbo_template |
| **kValueValidatorsMinLength** | `turbo_template/flutter-app/lib/core/ux/manage-input/constants/k_value_validators.dart` | Validates minimum string length | turbo_template |
| **kValueValidatorsEquals** | `turbo_template/flutter-app/lib/core/ux/manage-input/constants/k_value_validators.dart` | Validates value equality | turbo_template |
| **isValidSnakeCase** | `turbo_template/flutter-app/tool/lib/utils/case_converter.dart` | Validates snake_case format | turbo_template |
| **isValidReverseDomain** | `turbo_template/flutter-app/tool/lib/utils/case_converter.dart` | Validates reverse domain notation | turbo_template |
| **TemplateConfig.validate** | `turbo_template/flutter-app/tool/lib/init_template.dart` | Validates template configuration | turbo_template |

## Data Flow

### Firestore to UI Flow

1. **API Layer** (`TurboFirestoreApi`)
   - Handles CRUD operations with Firestore
   - Converts between Firestore documents and Dart objects
   - Returns `TurboResponse<T>` for all operations

2. **Service Layer** (`TurboCollectionService`, `TurboDocumentService`)
   - Manages local state synchronization
   - Listens to Firestore streams via `TurboAuthSyncService`
   - Updates local state (`Informer<T>`) when data changes
   - Provides optimistic updates with rollback capability

3. **ViewModel Layer** (`TurboViewModel`)
   - Consumes services for business logic
   - Manages UI state
   - Exposes data to Views via reactive properties

4. **View Layer** (Flutter Widgets)
   - Consumes ViewModels via `TurboViewModelBuilder`
   - Rebuilds when ViewModel state changes
   - Displays data and handles user interactions

### Authentication Flow

1. **AuthService** monitors Firebase Auth state
2. **AuthService** exposes `hasAuth` via `Informer<bool>`
3. **ShellViewModel** listens to `hasAuth`
4. **ShellView** switches between `AuthView` and `HomeView` based on auth state
5. **BaseRouterService** provides `onAuthAccess()` guard for protected routes

### State Management Flow

1. **Services** use `Informer<T>` (from `informers` package) for reactive state
2. **ViewModels** consume services and expose UI-specific state
3. **Views** use `ValueListenableBuilder` or `TurboViewModelBuilder` to react to changes
4. **BusyService** provides global loading state management

## Dependency Graph

### Service Dependencies

```
LocatorService (root)
├── BaseRouterService
│   ├── AuthService
│   └── NavigationTabService
├── AuthService
│   └── FirebaseAuth
├── EmailService
│   └── FirebaseAuth
├── ConnectionService
│   └── Connectivity
├── LocalStorageService
├── ThemeService
│   └── LocalStorageService
├── LanguageService
│   └── LocalStorageService
├── OverlayService
├── VibrateService
├── ShakeGestureService
│   ├── VibrateService (lazy)
│   └── OverlayService (lazy)
└── ToastService
```

### Package Dependencies

```
turbo_response (foundation)
    └── turbo_serializable
            ├── turbo_promptable
            └── turbo_firestore_api
                    └── turbo_template/flutter-app

turbo_notifiers (standalone)
turbo_mvvm (standalone)
turbolytics (standalone)
```

## Configuration

### Environment Configuration
- **File**: `turbo_template/flutter-app/lib/environment/config/t_app_config.dart`
- **Types**: `emulators`, `demo`, `staging`, `prod`
- **Loading**: Via `ConfigLoader` from `template.yaml`

### Firebase Configuration
- **Firestore Rules**: `turbo_template/firebase/firestore.rules`
- **Storage Rules**: `turbo_template/firebase/storage.rules`
- **Security**: Authenticated users can only access their own data

### Melos Configuration
- **File**: `pubspec.yaml` (root)
- **Scripts**: `analyze`, `format`, `test`, `build_runner`, `pub-check`, `pub-publish`, `pub-publish-dry-run`
- **Repository**: https://github.com/appboypov/turbo_packages

## Testing Structure

### Test Organization
- Each package contains `test/` directory
- Tests follow Dart testing conventions
- Coverage reports generated via `melos test`

### Test Utilities
- Mock implementations in test directories
- Example apps serve as integration tests
- Validation tests for serialization

## Conventions

### Naming Conventions
- Package names: lowercase with underscores (turbo_*)
- Classes: PascalCase
- Files: snake_case
- Constants: kPrefix (e.g., `kErrorCodes`)

### Code Organization
- Each package follows standard Dart package structure
- Public API exported from `lib/<package_name>.dart`
- Internal implementation in `lib/src/`
- Examples in `example/` directory
- Tests in `test/` directory

### Error Handling
- Use `TurboResponse<T>` (Success/Fail) for operation results
- Avoid throwing exceptions for expected failure cases
- All APIs return `TurboResponse` for consistent error handling

### State Management
- Use `Informer<T>` for reactive state in services
- Use `TurboViewModel` for UI state management
- Use `TurboNotifier` for enhanced ValueNotifier functionality

## API Patterns

### Internal Dependencies
- Packages depend on each other via workspace resolution
- No version constraints for internal dependencies
- Changes propagate immediately during development

### Publishing
- Each package maintains independent versioning
- Published to pub.dev with monorepo repository URLs
- Coordinated releases via Melos version command
- All packages must achieve 160/160 pub points before publishing
- Validation via `melos pub-check` before publishing
