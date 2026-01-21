# Architecture

## Overview
turbo_template is a production-ready Flutter application template that provides a solid foundation for building cross-platform mobile and web applications. It implements a feature-based architecture with clear separation of concerns, integrating Firebase for backend services, GetIt for dependency injection, and a custom state management approach using Informers and turbo_notifiers.

## Project Setup

### Prerequisites
- Flutter SDK ^3.8.0
- Dart SDK ^3.8.0
- Firebase CLI (for emulator and deployment)
- Node.js (for Firebase functions)

### Installation
1. Clone the repository
2. Run `flutter pub get` in `flutter-app/`
3. Configure Firebase using `flutterfire configure`
4. Copy `template.yaml` and configure app-specific values
5. Run `dart run tool/bin/init_template.dart` to initialize the template

### Development
- Run emulators: `./scripts/run_emulators.sh`
- Run app: `flutter run` or `./scripts/run_flutter.sh`
- Build: `flutter build apk` / `flutter build ios` / `flutter build web`

## Technology Stack

### Core Technologies
| Technology | Purpose |
|------------|---------|
| Flutter 3.8+ | Cross-platform UI framework |
| Dart 3.8+ | Programming language |
| Firebase | Backend services (Auth, Firestore, Functions, Analytics, Crashlytics) |
| GetIt | Service locator / Dependency injection |
| go_router | Navigation and routing |
| shadcn_ui | UI component library |

### Key Dependencies
| Package | Purpose |
|---------|---------|
| `turbo_response` | Result type (Success/Fail) for operation outcomes |
| `turbo_firestore_api` | Type-safe Firestore API wrapper |
| `turbo_notifiers` | Reactive state management primitives |
| `turbo_mvvm` / `veto` | View/ViewModel pattern base classes |
| `turbo_widgets` | Shared reusable UI widgets |
| `turbolytics` | Analytics and logging utilities |
| `turbo_serializable` | JSON serialization base classes |
| `informers` | Selective reactive state management |
| `rxdart` | Reactive extensions for Dart |
| `smooth_sheets` | Modal sheet navigation |
| `flutter_animate` | Animation utilities |

## Project Structure
```
turbo_template/
├── firebase/                           # Firebase configuration
│   ├── functions/                      # Cloud Functions (TypeScript)
│   ├── seed/                          # Database seed data
│   ├── firebase.json                  # Firebase config
│   ├── firestore.rules               # Security rules
│   └── storage.rules                 # Storage rules
├── flutter-app/                        # Flutter application
│   ├── lib/
│   │   ├── core/                      # Core application code
│   │   │   ├── analytics/             # Analytics implementations
│   │   │   ├── auth/                  # Authentication feature
│   │   │   ├── connection/            # Network connectivity
│   │   │   ├── infrastructure/        # App infrastructure
│   │   │   ├── settings/              # App settings
│   │   │   ├── shared/                # Shared utilities
│   │   │   ├── state/                 # State management
│   │   │   ├── storage/               # Data persistence
│   │   │   ├── ui/                    # UI components
│   │   │   └── ux/                    # UX utilities
│   │   ├── environment/               # Environment configuration
│   │   ├── generated/                 # Generated code (l10n)
│   │   ├── l10n/                      # Localization files
│   │   └── main.dart                  # App entry point
│   ├── assets/                        # Static assets
│   ├── test/                          # Tests
│   └── tool/                          # Template initialization tools
└── workspace/                          # Development workspace
```

## Component Inventory

### DTOs / Models / Entities

| Name | Path | Purpose |
|------|------|---------|
| `UserDto` | `lib/core/auth/authenticate-users/dtos/user_dto.dart` | User account data model |
| `UserLevelDto` | `lib/core/auth/authenticate-users/dtos/user_level_dto.dart` | User subscription level |
| `UserProfileDto` | `lib/core/auth/authenticate-users/dtos/user_profile_dto.dart` | User profile information |
| `UsernameDto` | `lib/core/auth/authenticate-users/dtos/username_dto.dart` | Username reservation |
| `CreateProfileRequest` | `lib/core/auth/authenticate-users/dtos/create_profile_request.dart` | Profile creation request |
| `CreateUsernameRequest` | `lib/core/auth/authenticate-users/dtos/create_username_request.dart` | Username creation request |
| `UpdateUserDtoRequest` | `lib/core/auth/authenticate-users/dtos/user_dto.dart` | User update request |
| `SettingsDto` | `lib/core/settings/dtos/settings_dto.dart` | App settings data |
| `CurrentWeekDto` | `lib/core/shared/dtos/current_week_dto.dart` | Week calculation utility |
| `IconLabelDto` | `lib/core/ui/show-ui/dtos/icon_label_dto.dart` | Icon with label display |
| `RouteArguments` | `lib/core/infrastructure/navigate-app/models/extra_arguments.dart` | Navigation extra data |
| `Crud` | `lib/core/state/manage-state/models/crud.dart` | CRUD operation model |
| `TColors` | `lib/core/ui/show-ui/models/t_colors.dart` | Theme color accessor |
| `TData` | `lib/core/ui/show-ui/models/t_data.dart` | UI data container |
| `TSizes` | `lib/core/ui/show-ui/models/t_sizes.dart` | Theme size accessor |
| `TTexts` | `lib/core/ui/show-ui/models/t_texts.dart` | Theme text style accessor |

### Services

| Name | Path | Type | Dependencies |
|------|------|------|--------------|
| `AuthService` | `lib/core/auth/authenticate-users/services/auth_service.dart` | Lazy Singleton | FirebaseAuth, LocatorService |
| `EmailService` | `lib/core/auth/authenticate-users/services/email_service.dart` | Factory | FirebaseAuth |
| `UserService` | `lib/core/auth/authenticate-users/services/user_service.dart` | Lazy Singleton | UsersApi, UserProfilesApi |
| `ConnectionService` | `lib/core/connection/manage-connection/services/connection_service.dart` | Lazy Singleton | Connectivity |
| `LocatorService` | `lib/core/infrastructure/inject-dependencies/services/locator_service.dart` | Singleton | GetIt |
| `BaseRouterService` | `lib/core/infrastructure/navigate-app/services/base_router_service.dart` | Lazy Singleton | GoRouter, AuthService |
| `NavigationTabService` | `lib/core/infrastructure/navigate-app/services/navigation_tab_service.dart` | Lazy Singleton | - |
| `VersionComparatorService` | `lib/core/infrastructure/services/version_comparator_service.dart` | Factory | - |
| `PackageInfoService` | `lib/core/infrastructure/show-version/services/package_info_service.dart` | Factory | PackageInfo |
| `SettingsService` | `lib/core/settings/services/settings_service.dart` | Lazy Singleton | SettingsApi |
| `LocalStorageService` | `lib/core/storage/save-local-data/services/local_storage_service.dart` | Lazy Singleton | Hive, FlutterSecureStorage |
| `BadgeService` | `lib/core/ui/show-ui/services/badge_service.dart` | Factory | - |
| `OverlayService` | `lib/core/ui/show-ui/services/overlay_service.dart` | Lazy Singleton | - |
| `RandomService` | `lib/core/ui/show-ui/services/random_service.dart` | Factory | - |
| `ThemeService` | `lib/core/ui/show-ui/services/theme_service.dart` | Lazy Singleton | LocalStorageService |
| `UrlLauncherService` | `lib/core/ux/launch-urls/services/url_launcher_service.dart` | Factory | url_launcher |
| `LanguageService` | `lib/core/ux/manage-language/services/language_service.dart` | Lazy Singleton | LocalStorageService |
| `DialogService` | `lib/core/ux/provide-feedback/services/dialog_service.dart` | Factory | - |
| `ShakeGestureService` | `lib/core/ux/provide-feedback/services/shake_gesture_service.dart` | Lazy Singleton | - |
| `ToastService` | `lib/core/ux/provide-feedback/services/toast_service.dart` | Lazy Singleton | - |
| `VibrateService` | `lib/core/ux/provide-feedback/services/vibrate_service.dart` | Lazy Singleton | HapticFeedback |

### APIs

| Name | Path | Collection | Purpose |
|------|------|------------|---------|
| `UsersApi` | `lib/core/auth/authenticate-users/apis/users_api.dart` | `users` | User document operations |
| `UserProfilesApi` | `lib/core/auth/authenticate-users/apis/user_profiles_api.dart` | `userProfiles` | Profile document operations |
| `UsernamesApi` | `lib/core/auth/authenticate-users/apis/usernames_api.dart` | `usernames` | Username reservation operations |
| `SettingsApi` | `lib/core/settings/apis/settings_api.dart` | `settings` | App settings operations |
| `TurboApi<T>` | `lib/core/storage/manage-data/abstracts/turbo_api.dart` | - | Base Firestore API class |

### Views / Pages

| Name | Path | Route | View Model |
|------|------|-------|------------|
| `MyAppView` | `lib/core/infrastructure/run-app/views/my_app/my_app_view.dart` | - | `MyAppViewModel` |
| `ShellView` | `lib/core/infrastructure/run-app/views/shell/shell_view.dart` | `/shell` | `ShellViewModel` |
| `HomeView` | `lib/core/infrastructure/navigate-app/views/home_view.dart` | `/home` | - |
| `AuthView` | `lib/core/auth/authenticate-users/views/auth/auth_view.dart` | `/auth` | `AuthViewModel` |
| `OopsView` | `lib/core/shared/views/oops/oops_view.dart` | `/oops` | `OopsViewModel` |

### View Models

| Name | Path | Services Used |
|------|------|---------------|
| `MyAppViewModel` | `lib/core/infrastructure/run-app/views/my_app/my_app_view_model.dart` | LocatorService, ThemeService, LanguageService |
| `ShellViewModel` | `lib/core/infrastructure/run-app/views/shell/shell_view_model.dart` | AuthService, NavigationTabService |
| `AuthViewModel` | `lib/core/auth/authenticate-users/views/auth/auth_view_model.dart` | ToastService, UrlLauncherService, EmailService, AuthService, LocalStorageService, DialogService |
| `OopsViewModel` | `lib/core/shared/views/oops/oops_view_model.dart` | - |

### Forms

| Name | Path | Purpose |
|------|------|---------|
| `LoginForm` | `lib/core/auth/authenticate-users/forms/login_form.dart` | Login form validation |
| `RegisterForm` | `lib/core/auth/authenticate-users/forms/register_form.dart` | Registration form validation |
| `ForgotPasswordForm` | `lib/core/auth/authenticate-users/forms/forgot_password_form.dart` | Password reset form validation |

### Widgets / Components

#### Animation Widgets
| Name | Path | Purpose |
|------|------|---------|
| `AnimatedEnabled` | `lib/core/ui/show-animations/widgets/animated_enabled.dart` | Animated enable/disable state |
| `FadeIn` | `lib/core/ui/show-animations/widgets/fade_in.dart` | Fade-in animation wrapper |
| `HoverAnimation` | `lib/core/ui/show-animations/widgets/hover_animation.dart` | Hover state animation |
| `HoverBuilder` | `lib/core/ui/show-animations/widgets/hover_builder.dart` | Hover state builder |
| `Shrinks` | `lib/core/ui/show-animations/widgets/shrinks.dart` | Shrink animation variants |
| `TAnimatedGap` | `lib/core/ui/show-animations/widgets/t_animated_gap.dart` | Animated gap widget |
| `TAnimatedSize` | `lib/core/ui/show-animations/widgets/t_animated_size.dart` | Animated size wrapper |
| `TAnimatedText` | `lib/core/ui/show-animations/widgets/t_animated_text.dart` | Animated text transitions |
| `TButtonRaw` | `lib/core/ui/show-animations/widgets/t_button_raw.dart` | Raw button with animations |
| `THoverable` | `lib/core/ui/show-animations/widgets/t_hoverable.dart` | Hoverable wrapper |
| `TKeyboardGap` | `lib/core/ui/show-animations/widgets/t_keyboard_gap.dart` | Keyboard-aware gap |
| `TransitionBuilders` | `lib/core/ui/show-animations/widgets/transition_builders.dart` | Custom transition builders |

#### Button Widgets
| Name | Path | Purpose |
|------|------|---------|
| `OpacityButton` | `lib/core/ui/show-ui/widgets/buttons/opacity_button.dart` | Opacity feedback button |
| `OpacityDetailsButton` | `lib/core/ui/show-ui/widgets/buttons/opacity_details_button.dart` | Detailed opacity button |
| `ReleaseScaleButton` | `lib/core/ui/show-ui/widgets/buttons/release_scale_button.dart` | Scale-on-release button |
| `ScaleButton` | `lib/core/ui/show-ui/widgets/buttons/scale_button.dart` | Scale feedback button |
| `TButton` | `lib/core/ui/show-ui/widgets/buttons/t_button.dart` | Standard template button |
| `TColorButton` | `lib/core/ui/show-ui/widgets/buttons/t_color_button.dart` | Colored button variant |
| `TColorContainer` | `lib/core/ui/show-ui/widgets/buttons/t_color_container.dart` | Colored container |
| `TGradientContainer` | `lib/core/ui/show-ui/widgets/buttons/t_gradient_container.dart` | Gradient container |
| `TIconButton` | `lib/core/ui/show-ui/widgets/buttons/t_icon_button.dart` | Icon button |
| `TMaxHeight` | `lib/core/ui/show-ui/widgets/buttons/t_max_height.dart` | Max height constraint |
| `TMaxWidth` | `lib/core/ui/show-ui/widgets/buttons/t_max_width.dart` | Max width constraint |
| `TRow` | `lib/core/ui/show-ui/widgets/buttons/t_row.dart` | Styled row widget |

#### Layout Widgets
| Name | Path | Purpose |
|------|------|---------|
| `BooleanBuilder` | `lib/core/ui/show-ui/widgets/boolean_builder.dart` | Boolean condition builder |
| `DialogConstraints` | `lib/core/ui/show-ui/widgets/dialog_constraints.dart` | Dialog size constraints |
| `TAddButton` | `lib/core/ui/show-ui/widgets/t_add_button.dart` | Add action button |
| `TAppBackground` | `lib/core/ui/show-ui/widgets/t_app_background.dart` | App background widget |
| `TCard` | `lib/core/ui/show-ui/widgets/t_card.dart` | Card with header section |
| `TColumn` | `lib/core/ui/show-ui/widgets/t_column.dart` | Styled column widget |
| `TConstraints` | `lib/core/ui/show-ui/widgets/t_constraints.dart` | Max-width constraint wrapper |
| `TDecorations` | `lib/core/ui/show-ui/widgets/t_decorations.dart` | Common decorations |
| `TEmptyPlaceholder` | `lib/core/ui/show-ui/widgets/t_empty_placeholder.dart` | Empty state placeholder |
| `TEnsureVisible` | `lib/core/ui/show-ui/widgets/t_ensure_visible.dart` | Scroll-to-visible wrapper |
| `TFlex` | `lib/core/ui/show-ui/widgets/t_flex.dart` | Flexible layout |
| `TFocusOrder` | `lib/core/ui/show-ui/widgets/t_focus_order.dart` | Focus traversal ordering |
| `TGap` | `lib/core/ui/show-ui/widgets/t_gap.dart` | Consistent gap widget |
| `TIcon` | `lib/core/ui/show-ui/widgets/t_icon.dart` | Styled icon widget |
| `TIconLabel` | `lib/core/ui/show-ui/widgets/t_icon_label.dart` | Icon with label |
| `TImage` | `lib/core/ui/show-ui/widgets/t_image.dart` | Styled image widget |
| `TLogo` | `lib/core/ui/show-ui/widgets/t_logo.dart` | App logo widget |
| `TMargin` | `lib/core/ui/show-ui/widgets/t_margin.dart` | Consistent margin wrapper |
| `TProvider` | `lib/core/ui/show-ui/widgets/t_provider.dart` | Theme data provider |
| `TProviderBuilder` | `lib/core/ui/show-ui/widgets/t_provider_builder.dart` | Provider builder |
| `TScaffold` | `lib/core/ui/show-ui/widgets/t_scaffold.dart` | Template scaffold |
| `TScrollView` | `lib/core/ui/show-ui/widgets/t_scroll_view.dart` | Scrollable content |
| `TSnackbar` | `lib/core/ui/show-ui/widgets/t_snackbar.dart` | Custom snackbar |
| `TextInputAndDropdownSheet` | `lib/core/ui/show-ui/widgets/text_input_and_dropdown_sheet.dart` | Input with dropdown sheet |

#### State Management Widgets
| Name | Path | Purpose |
|------|------|---------|
| `ActiveItemsBuilder` | `lib/core/state/manage-state/widgets/active_items_builder.dart` | Active items list builder |
| `BusyListenableBuilder` | `lib/core/state/manage-state/widgets/busy_listenable_builder.dart` | Busy state builder |
| `IsBusyIcon` | `lib/core/state/manage-state/widgets/is_busy_icon.dart` | Busy indicator icon |
| `MultiListenableBuilder` | `lib/core/state/manage-state/widgets/multi_listenable_builder.dart` | Multiple listenable builder |
| `Unfocusable` | `lib/core/state/manage-state/widgets/unfocusable.dart` | Tap-to-unfocus wrapper |
| `ValueListenableBuilderX2-X6` | `lib/core/state/manage-state/widgets/` | Multi-value listenable builders |

#### Form Widgets
| Name | Path | Purpose |
|------|------|---------|
| `TErrorLabel` | `lib/core/ux/manage-input/widgets/t_error_label.dart` | Form error display |
| `TFormField` | `lib/core/ux/manage-input/widgets/t_form_field.dart` | Form field with icon label |
| `TFormFieldBuilder` | `lib/core/ux/manage-input/widgets/t_form_field_builder.dart` | Form field builder |
| `AcceptPrivacyText` | `lib/core/auth/widgets/accept_privacy_text.dart` | Privacy acceptance checkbox |

### Enums

| Name | Path | Purpose |
|------|------|---------|
| `AuthStep` | `lib/core/auth/authenticate-users/enums/auth_step.dart` | Authentication flow steps |
| `AuthViewMode` | `lib/core/auth/authenticate-users/enums/auth_view_mode.dart` | Auth view mode (login/register/forgot) |
| `StepResult` | `lib/core/auth/authenticate-users/enums/step_result.dart` | Step completion result |
| `UserLevel` | `lib/core/auth/enums/user_level.dart` | User subscription level |
| `NavigationTab` | `lib/core/infrastructure/navigate-app/enums/navigation_tab.dart` | Bottom nav tabs |
| `PageTransitionType` | `lib/core/infrastructure/navigate-app/enums/page_transition_type.dart` | Page transition types |
| `RouterType` | `lib/core/infrastructure/navigate-app/enums/router_type.dart` | Router type identifier |
| `ViewType` | `lib/core/infrastructure/navigate-app/enums/view_type.dart` | View type identifier |
| `BoxKey` | `lib/core/storage/save-local-data/enums/box_key.dart` | Hive box identifiers |
| `AnimationTiming` | `lib/core/ui/show-animations/enums/animation_timing.dart` | Animation timing presets |
| `ButtonWidthBehaviour` | `lib/core/ui/show-ui/enums/button_width_behaviour.dart` | Button width modes |
| `DateFormat` | `lib/core/ui/show-ui/enums/date_format.dart` | Date format options |
| `Emoji` | `lib/core/ui/show-ui/enums/emoji.dart` | Emoji constants |
| `Gender` | `lib/core/ui/show-ui/enums/gender.dart` | Gender options |
| `IconCollection` | `lib/core/ui/show-ui/enums/icon_collection.dart` | Icon collection enum |
| `ListPosition` | `lib/core/ui/show-ui/enums/list_position.dart` | List item position |
| `Month` | `lib/core/ui/show-ui/enums/month.dart` | Month enum |
| `TDevice` | `lib/core/ui/show-ui/enums/t_device.dart` | Device type enum |
| `TDeviceType` | `lib/core/ui/show-ui/enums/t_device_type.dart` | Device type categories |
| `TOrientation` | `lib/core/ui/show-ui/enums/t_orientation.dart` | Orientation enum |
| `TSelectedState` | `lib/core/ui/show-ui/enums/t_selected_state.dart` | Selection state |
| `TTheme` | `lib/core/ui/show-ui/enums/t_theme.dart` | Theme variant |
| `TThemeMode` | `lib/core/ui/show-ui/enums/t_theme_mode.dart` | Light/dark theme mode |
| `TVibrateMoment` | `lib/core/ui/show-ui/enums/t_vibrate_moment.dart` | Haptic feedback moments |
| `WeekDay` | `lib/core/ui/show-ui/enums/week_day.dart` | Week day enum |
| `TFieldType` | `lib/core/ux/manage-input/enums/t_field_type.dart` | Form field types |
| `TSupportedLanguage` | `lib/core/ux/manage-language/enums/t_supported_language.dart` | Supported languages |
| `Environment` | `lib/environment/enums/environment.dart` | App environment (dev/staging/prod) |
| `SupportedPlatform` | `lib/environment/enums/supported_platform.dart` | Supported platforms |

### Constants

| Name | Path | Purpose |
|------|------|---------|
| `TDurations` | `lib/core/ui/show-animations/constants/t_durations.dart` | Animation duration constants |
| `TKeys` | `lib/core/shared/constants/t_keys.dart` | String key constants |
| `TValues` | `lib/core/shared/constants/t_values.dart` | Value constants |
| `TParams` | `lib/core/infrastructure/navigate-app/constants/t_params.dart` | Navigation parameter keys |
| `FirestoreCollection` | `lib/core/storage/manage-data/constants/firestore_collection.dart` | Firestore collection names |
| `StorageKeys` | `lib/core/storage/save-local-data/constants/storage_keys.dart` | Local storage keys |
| `KValueValidators` | `lib/core/ux/manage-input/constants/k_value_validators.dart` | Form validation functions |
| `ErrorKeys` | `lib/core/auth/authenticate-users/constants/error_keys.dart` | Error key constants |
| `Spacings` | `lib/core/ui/show-ui/constants/spacings.dart` | Spacing constants |
| `TWidget` | `lib/core/ui/show-ui/constants/t_widget.dart` | Widget constants |

### Extensions

| Name | Path | Purpose |
|------|------|---------|
| `ConnectivityResultExtension` | `lib/core/connection/manage-connection/extensions/connectivity_result_extension.dart` | Connectivity helpers |
| `DateTimeExtension` | `lib/core/shared/extensions/date_time_extension.dart` | DateTime utilities |
| `DurationExtension` | `lib/core/shared/extensions/duration_extension.dart` | Duration utilities |
| `IntExtension` | `lib/core/shared/extensions/int_extension.dart` | Int utilities |
| `IterableExtension` | `lib/core/shared/extensions/iterable_extension.dart` | Iterable utilities |
| `ListExtension` | `lib/core/shared/extensions/list_extension.dart` | List utilities |
| `MapExtension` | `lib/core/shared/extensions/map_extension.dart` | Map utilities |
| `NumExtension` | `lib/core/shared/extensions/num_extension.dart` | Num utilities |
| `ObjectExtension` | `lib/core/shared/extensions/object_extension.dart` | Object utilities |
| `SetExtension` | `lib/core/shared/extensions/set_extension.dart` | Set utilities |
| `StringExtension` | `lib/core/shared/extensions/string_extension.dart` | String utilities |
| `CompleterExtension` | `lib/core/state/manage-state/extensions/completer_extension.dart` | Completer utilities |
| `ContextExtension` | `lib/core/state/manage-state/extensions/context_extension.dart` | BuildContext utilities |
| `AnimationExtension` | `lib/core/ui/show-animations/extensions/animation_extension.dart` | Animation utilities |
| `AnimationValueExtension` | `lib/core/ui/show-animations/extensions/animation_value_extension.dart` | Animation value utilities |
| `BoxConstraintsExtension` | `lib/core/ui/show-ui/extensions/box_constraints_extension.dart` | BoxConstraints utilities |
| `ColorExtension` | `lib/core/ui/show-ui/extensions/color_extension.dart` | Color utilities |
| `FontWeightExtension` | `lib/core/ui/show-ui/extensions/font_weight_extension.dart` | FontWeight utilities |
| `TScaleExtension` | `lib/core/ui/show-ui/extensions/t_scale_extension.dart` | Scale utilities |
| `TTargetPlatformExtension` | `lib/core/ui/show-ui/extensions/t_target_platform_extension.dart` | Platform utilities |
| `TextStyleExtension` | `lib/core/ui/show-ui/extensions/text_style_extension.dart` | TextStyle utilities |
| `TFormFieldExtensions` | `lib/core/ux/manage-input/config/t_form_field_extensions.dart` | Form field utilities |

### Utils / Helpers

| Name | Path | Purpose |
|------|------|---------|
| `BlockDebouncer` | `lib/core/state/manage-state/utils/block_debouncer.dart` | Block-style debouncer |
| `BlockingDebouncer` | `lib/core/state/manage-state/utils/blocking_debouncer.dart` | Blocking debouncer |
| `BoolInformerBox` | `lib/core/state/manage-state/utils/bool_informer_box.dart` | Boolean informer wrapper |
| `Debouncer` | `lib/core/state/manage-state/utils/debouncer.dart` | Standard debouncer |
| `Isolator` | `lib/core/state/manage-state/utils/isolator.dart` | Isolate helper |
| `MinDurationCompleter` | `lib/core/state/manage-state/utils/min_duration_completer.dart` | Minimum duration completer |
| `Mutex` | `lib/core/state/manage-state/utils/mutex.dart` | Mutual exclusion lock |
| `Notifier` | `lib/core/state/manage-state/utils/notifier.dart` | Simple notifier |
| `ScrollControllerBox` | `lib/core/state/manage-state/utils/scroll_controller_box.dart` | Scroll controller wrapper |
| `Throttler` | `lib/core/state/manage-state/utils/throttler.dart` | Throttle utility |
| `TTools` | `lib/core/ui/show-ui/utils/t_tools.dart` | UI utilities |
| `HapticButtonUtils` | `lib/core/ux/provide-feedback/utils/haptic_button_utils.dart` | Haptic feedback utilities |

### Routing / Navigation

| Route | Path | Auth Required | Purpose |
|-------|------|---------------|---------|
| `/auth` | `AuthView.path` | No | Authentication screen |
| `/shell` | `ShellView.path` | No | Main app shell |
| `/home` | `HomeView.path` | Yes | Home screen (commented) |
| `/oops` | `OopsView.path` | No | Error screen |

### Abstracts / Interfaces

| Name | Path | Purpose |
|------|------|---------|
| `Analytics` | `lib/core/auth/authenticate-users/abstracts/analytics.dart` | Analytics interface |
| `TSubjects` | `lib/core/auth/authenticate-users/abstracts/t_subjects.dart` | Analytics subjects |
| `BaseNavigation` | `lib/core/infrastructure/navigate-app/abstracts/base_navigation.dart` | Navigation base class |
| `ViewArguments` | `lib/core/infrastructure/navigate-app/abstracts/view_arguments.dart` | Route arguments base |
| `Initialisable` | `lib/core/state/manage-state/abstracts/initialisable.dart` | Initialization interface |
| `SyncService` | `lib/core/state/manage-state/abstracts/sync_service.dart` | Stream sync base class |
| `TurboApi` | `lib/core/storage/manage-data/abstracts/turbo_api.dart` | Firestore API base |
| `TFormConfig` | `lib/core/ux/manage-input/abstracts/t_form_config.dart` | Form configuration base |

### Converters

| Name | Path | Purpose |
|------|------|---------|
| `DocumentReferenceConverter` | `lib/core/storage/converters/document_reference_converter.dart` | DocumentReference JSON conversion |
| `DurationDaysConverter` | `lib/core/storage/converters/duration_days_converter.dart` | Duration (days) JSON conversion |
| `GeoPointConverter` | `lib/core/storage/converters/geo_point_converter.dart` | GeoPoint JSON conversion |
| `TimestampConverter` | `lib/core/storage/converters/timestamp_converter.dart` | Timestamp JSON conversion |

### Configuration

| Name | Path | Purpose |
|------|------|---------|
| `EmulatorConfig` | `lib/environment/config/emulator_config.dart` | Firebase emulator setup |
| `TAppConfig` | `lib/environment/config/t_app_config.dart` | App configuration |
| `TFormFieldConfig` | `lib/core/ux/manage-input/config/t_form_field_config.dart` | Form field configuration |
| `TFormFieldState` | `lib/core/ux/manage-input/config/t_form_field_state.dart` | Form field state |
| `NoThumbScrollBehaviour` | `lib/core/ui/show-ui/config/no_thumb_scroll_behaviour.dart` | Scroll behavior config |
| `TBackground` | `lib/core/ui/show-ui/config/t_background.dart` | Background config |
| `TBreakpointConfig` | `lib/core/ui/show-ui/config/t_breakpoint_config.dart` | Responsive breakpoints |

### Globals

| Name | Path | Purpose |
|------|------|---------|
| `gBusy` | `lib/core/auth/globals/g_busy.dart` | Global busy state |
| `gNow` | `lib/core/auth/globals/g_now.dart` | Current timestamp getter |
| `gUserId` | `lib/core/auth/globals/g_user_id.dart` | Current user ID getter |
| `gEnv` / `gConfig` | `lib/environment/globals/g_env.dart` | Environment config getter |
| `gContext` | `lib/l10n/globals/g_context.dart` | Global context reference |
| `gStrings` | `lib/l10n/globals/g_strings.dart` | Localization strings getter |
| `gVibrate` | `lib/core/ux/provide-feedback/globals/g_vibrate.dart` | Vibration trigger |

## Architecture Patterns

### MVVM Pattern
- Views are stateless widgets that render UI
- ViewModels extend `BaseViewModel` from veto package
- ViewModels hold state using `TNotifier`, `Informer`, and `BehaviorSubject`
- ViewModels are registered as factories and located via GetIt

### Service Locator Pattern
- All services registered in `LocatorService.registerInitialDependencies()`
- Three registration types:
  - **Lazy Singleton**: Created on first access, lives for app lifetime
  - **Singleton**: Created at registration, lives for app lifetime
  - **Factory**: New instance on each access

### Repository/API Pattern
- APIs extend `TurboApi<T>` for type-safe Firestore operations
- APIs handle CRUD operations for specific collections
- Services orchestrate business logic using one or more APIs

### Form Configuration Pattern
- Forms use `TFormFieldConfig` for field state management
- Validation via `KValueValidators` constants
- Form classes registered as factories for fresh state per use

## Data Flow

```
┌─────────────────┐
│     View        │  UI Layer - Stateless widgets
└────────┬────────┘
         │ ValueListenableBuilder / InformerBuilder
         ▼
┌─────────────────┐
│   ViewModel     │  State + Business Logic
└────────┬────────┘
         │ Method calls
         ▼
┌─────────────────┐
│    Service      │  Business Logic + State Management
└────────┬────────┘
         │ CRUD operations
         ▼
┌─────────────────┐
│      API        │  Data Access Layer
└────────┬────────┘
         │ Firestore SDK
         ▼
┌─────────────────┐
│   Firebase      │  Backend Services
└─────────────────┘
```

## Dependency Graph

```
MyAppView
└── MyAppViewModel
    ├── LocatorService
    ├── ThemeService
    └── LanguageService

ShellView
└── ShellViewModel
    ├── AuthService
    └── NavigationTabService

AuthView
└── AuthViewModel
    ├── ToastService
    ├── UrlLauncherService
    ├── EmailService
    ├── AuthService
    ├── LocalStorageService
    ├── DialogService
    ├── LoginForm
    ├── RegisterForm
    └── ForgotPasswordForm

AuthService
├── FirebaseAuth
├── LocatorService
└── UserAnalytics

UserService
├── UsersApi
└── UserProfilesApi
```

## Testing Structure

### Unit Tests
- Location: `flutter-app/test/`
- Template tool tests: `flutter-app/tool/test/`
- Run: `flutter test`

### Widget Tests
- Location: `flutter-app/test/widget_test.dart`
- Run: `flutter test test/widget_test.dart`

## Conventions

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/Methods: `camelCase`
- Constants: `camelCase` with `k` prefix for constants, `g` prefix for globals
- Private members: `_prefixed`

### Code Organization
Each file follows this section structure:
```dart
// 📍 LOCATOR
// 🧩 DEPENDENCIES
// 🎬 INIT & DISPOSE
// 👂 LISTENERS
// ⚡️ OVERRIDES
// 🎩 STATE
// 🛠 UTIL
// 🧲 FETCHERS
// 🏗️ HELPERS
// 🪄 MUTATORS
```

### Error Handling
- Use `TurboResponse` for operation results (Success/Fail pattern)
- Never throw exceptions from service methods
- Log errors using `Turbolytics` mixin
- Show user-friendly messages via `ToastService` or `DialogService`

### Feature Folder Structure
```
feature-name/
├── abstracts/       # Interfaces and base classes
├── analytics/       # Feature analytics
├── apis/            # Firestore API classes
├── config/          # Feature configuration
├── constants/       # Feature constants
├── dtos/            # Data transfer objects
├── enums/           # Feature enums
├── extensions/      # Feature extensions
├── forms/           # Form configurations
├── globals/         # Feature globals
├── mixins/          # Feature mixins
├── models/          # Feature models
├── services/        # Feature services
├── typedefs/        # Type definitions
├── utils/           # Utility classes
├── views/           # View + ViewModel pairs
└── widgets/         # Feature widgets
```
