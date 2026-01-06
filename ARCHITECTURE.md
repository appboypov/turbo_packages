# Architecture

## Overview

Flutter Turbo Packages is a curated monorepo of 9 foundational Flutter/Dart packages designed to accelerate scalable application development. The packages provide core infrastructure for response handling, state management, Firestore operations, routing, forms, UI components, responsive design, and analytics.

The architecture emphasizes type safety, reactive updates, composability, and minimal dependencies while maintaining a consistent development experience across all packages.

## Project Setup

### Prerequisites
- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter SDK: `>=1.17.0`
- Melos: `^7.0.0` (monorepo management)

### Installation
```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap the monorepo (links local packages)
melos bootstrap

# Configure git hooks
git config core.hooksPath .githooks
```

### Development
```bash
# Format code
melos run format

# Check formatting (CI)
melos run format:check

# Analyze code
melos run analyze

# Run tests
melos run test

# Clean all packages
melos run clean

# Get dependencies
melos run get
```

## Technology Stack

### Core Technologies
- **Dart**: `>=3.5.0 <4.0.0`
- **Flutter**: `>=1.17.0`
- **Melos**: `^7.0.0` (monorepo management with workspace resolution)

### Key Dependencies
| Package | Dependency | Purpose |
|---------|------------|---------|
| turbo_firestore_api | cloud_firestore `^6.0.2` | Firestore operations |
| turbo_firestore_api | firebase_auth `^6.1.0` | Authentication state sync |
| turbo_firestore_api | rxdart `^0.28.0` | Reactive streams |
| turbo_mvvm | provider `^6.0.5` | State management |
| turbo_routing | go_router `^15.0.0` | Navigation |
| turbo_routing | get_it `^8.0.0` | Service location |
| turbo_forms | shadcn_ui `^0.31.8` | UI framework |
| turbo_widgets | flutter_animate `^4.5.0` | Animations |
| turbolytics | get_it `^8.0.3` | Dependency injection |

## Project Structure
```
flutter-turbo-packages/
├── turbo_response/           # Type-safe Success/Fail result wrapper
├── turbo_notifiers/          # Enhanced ValueNotifier for state
├── turbo_mvvm/               # MVVM pattern with TurboViewModel
├── turbo_firestore_api/      # Type-safe Firestore wrapper + services
├── turbo_forms/              # Form configuration and validation
├── turbo_routing/            # Type-safe routing over go_router
├── turbo_widgets/            # Reusable UI components + extensions
├── turbo_responsiveness/     # Responsive design utilities
├── turbolytics/              # Logging, analytics, crash reporting
├── melos.yaml                # Monorepo configuration
├── pubspec.yaml              # Workspace root pubspec
└── .github/workflows/        # CI/CD pipelines
```

### Package Structure Convention
Each package follows a consistent internal structure:
```
{package}/
├── lib/
│   ├── src/
│   │   ├── abstracts/      # Interfaces, base classes
│   │   ├── apis/           # API classes (turbo_firestore_api)
│   │   ├── config/         # Configuration classes
│   │   ├── constants/      # Static constants
│   │   ├── enums/          # Enumerated types
│   │   ├── exceptions/     # Custom exceptions
│   │   ├── extensions/     # Extension methods
│   │   ├── mixins/         # Mixins
│   │   ├── models/         # Data models
│   │   ├── services/       # Business logic services
│   │   ├── typedefs/       # Function signatures
│   │   ├── util/           # Utilities
│   │   └── widgets/        # UI components
│   └── {package}.dart      # Public barrel export
├── test/
├── example/                # Optional
├── pubspec.yaml
├── README.md
└── CHANGELOG.md
```

## Service Types and Patterns

### Service Architecture

#### Stateless APIs
Classes ending with `Api` handle external communication:
- REST API calls
- Firestore collection wrappers (extend `TurboFirestoreApi<T>`)
- No in-memory state
- Return `Future` or `Stream` types
- Handle serialization/deserialization

#### Stateful Services
Classes ending with `Service` manage application state:
- **Collection Services**: Extend `TurboCollectionService<T, Api>` for Firestore collections
- **Document Services**: Extend `TurboDocumentService<T, Api>` for single documents
- Maintain ID maps for quick lookups
- Support optimistic updates with rollback
- Provide stream connections and caching

#### ViewModels
Classes ending with `ViewModel` manage view/page state:
- Extend `TurboViewModel<A>` from turbo_mvvm
- Lifecycle: `initialise()` → `dispose()`
- State flags: `isInitialised`, `isBusy`, `hasError`
- Use mixins: `BusyManagement`, `ErrorManagement`

### Common Patterns

#### TurboResponse (Result Type)
All fallible operations return `TurboResponse<T>`:
```dart
final response = await api.getDocument(id);
response.fold(
  onSuccess: (s) => handleSuccess(s.result),
  onFail: (f) => handleError(f.error, f.message),
);
```

#### Reactive State with TurboNotifier
State changes notify listeners via `TurboNotifier<T>`:
```dart
final count = TurboNotifier<int>(0);
count.update(1);           // Notify listeners
count.silentUpdate(2);     // No notification
```

#### Type-Safe Firestore Operations
```dart
class UsersApi extends TurboFirestoreApi<UserDto> {
  UsersApi() : super(
    collectionPath: () => 'users',
    fromJson: UserDto.fromJson,
    toJson: (user) => user.toJson(),
  );
}
```

## State Management

### Approach
Layered state management with reactive updates:

| Layer | Tool | Purpose |
|-------|------|---------|
| Widget | `TurboNotifier<T>` | Local reactive state |
| ViewModel | `TurboViewModel<A>` | Page/feature state with lifecycle |
| Service | `TurboCollectionService` | Shared collection state |
| Global | `BusyService`, GetIt | App-wide state, DI |

### State Flow
```
User Action → ViewModel Method → Service/API Call
     ↑                                    ↓
   Widget ← TurboNotifier ← State Update ←┘
```

1. User triggers action in widget
2. Widget calls ViewModel method
3. ViewModel invokes Service or API
4. Service updates state via `TurboNotifier`
5. Widget rebuilds via `ValueListenableBuilder`

## Conventions

### Naming Conventions
| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase with Turbo prefix | `TurboResponse`, `TurboNotifier` |
| Methods/Variables | camelCase | `updateDocument`, `isInitialised` |
| Files | snake_case | `turbo_response.dart` |
| Constants | camelCase or UPPER_SNAKE_CASE | `defaultTimeout` |
| Enums | PascalCase | `BusyType`, `LogLevel` |

### Code Organization
- One public class per file
- Barrel exports in package root file
- Private implementation in `lib/src/`
- Extensions grouped by target type
- Typedefs for complex function signatures

### Error Handling
- No exceptions in normal control flow
- Return `TurboResponse<T>` for fallible operations
- `Success<T>` for successful results with data
- `Fail<T>` for failures with error info, message, and stack trace
- Pattern matching via `when()`, `fold()`, `maybeWhen()`

## API Patterns

### External APIs
External communication via `TurboFirestoreApi<T>`:
- CRUD operations with type safety
- Real-time streaming
- Batch operations and transactions
- Search (prefix, array contains, numeric)
- Automatic timestamp management
- Authentication state synchronization

### Internal APIs
Inter-package communication:
- Packages export via single barrel file
- Dependency graph flows downward (core → specialized)
- Workspace resolution for local development
- Interface-based extension points (e.g., `AnalyticsInterface`)

## Dependency Graph
```
turbo_response (pure Dart, no dependencies)
       ↓
turbo_notifiers
       ↓
turbo_firestore_api ←── turbolytics (analytics)
       ↓
turbo_mvvm (provider)
       ↓
turbo_widgets (flutter_animate, gap)
       ↓
┌──────┴──────┐
↓             ↓
turbo_forms   turbo_routing (go_router, get_it)
              ↓
              turbo_responsiveness
```

Core packages at top have no/minimal dependencies. Higher-level packages compose lower-level ones.
