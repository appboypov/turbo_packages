import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/apis/user_profiles_api.dart';
import 'package:turbo_flutter_template/core/auth/apis/usernames_api.dart';
import 'package:turbo_flutter_template/core/auth/apis/users_api.dart';
import 'package:turbo_flutter_template/core/auth/forms/forgot_password_form.dart';
import 'package:turbo_flutter_template/core/auth/forms/login_form.dart';
import 'package:turbo_flutter_template/core/auth/forms/register_form.dart';
import 'package:turbo_flutter_template/core/auth/services/auth_service.dart';
import 'package:turbo_flutter_template/core/auth/services/email_service.dart';
import 'package:turbo_flutter_template/core/auth/services/user_service.dart';
import 'package:turbo_flutter_template/core/auth/views/auth/auth_view_model.dart';
import 'package:turbo_flutter_template/core/connection/services/connection_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/forms/entity_detail_form.dart';
import 'package:turbo_flutter_template/core/infrastructure/routers/core_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/routers/home_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/routers/styling_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/navigation_tab_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/version_comparator_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/home/home_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/my_app/my_app_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/playground/playground_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/settings/settings_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/shell/shell_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/styling/styling_view_model.dart';
import 'package:turbo_flutter_template/core/shared/views/oops/oops_view_model.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_flutter_template/core/ui/services/badge_service.dart';
import 'package:turbo_flutter_template/core/ui/services/overlay_service.dart';
import 'package:turbo_flutter_template/core/ui/services/random_service.dart';
import 'package:turbo_flutter_template/core/ui/services/theme_service.dart';
import 'package:turbo_flutter_template/core/ux/services/dialog_service.dart';
import 'package:turbo_flutter_template/core/ux/services/language_service.dart';
import 'package:turbo_flutter_template/core/ux/services/shake_gesture_service.dart';
import 'package:turbo_flutter_template/core/ux/services/sheet_service.dart';
import 'package:turbo_flutter_template/core/ux/services/toast_service.dart';
import 'package:turbo_flutter_template/core/ux/services/url_launcher_service.dart';
import 'package:turbo_flutter_template/core/ux/services/vibrate_service.dart';
import 'package:turbo_flutter_template/settings/apis/settings_api.dart';
import 'package:turbo_flutter_template/settings/services/settings_service.dart';
import 'package:turbolytics/turbolytics.dart';

class LocatorService with Turbolytics {
  LocatorService._();

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static LocatorService? _instance;
  static LocatorService get locate {
    _instance ??= LocatorService._();
    return _instance!;
  }

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  void _registerRouters() {
    BaseRouterService.registerLazySingleton();
    HomeRouter.registerFactory();
    StylingRouter.registerFactory();
    CoreRouter.registerFactory();
  }

  void _registerLazySingletons() {
    LocalStorageService.registerLazySingleton();
    ThemeService.registerLazySingleton();
    LanguageService.registerLazySingleton();
    ConnectionService.registerLazySingleton();
    VibrateService.registerLazySingleton();
    OverlayService.registerLazySingleton();
    ShakeGestureService.registerLazySingleton();
    ToastService.registerLazySingleton();
    AuthService.registerLazySingleton();
    UserService.registerLazySingleton();
    BadgeService.registerLazySingleton();
    NavigationTabService.registerLazySingleton();
    SettingsService.registerLazySingleton();
  }

  void _registerFactories() {
    DialogService.registerFactory();
    SheetService.registerFactory();
    UsersApi.registerFactory();
    UserProfilesApi.registerFactory();
    UsernamesApi.registerFactory();
    SettingsApi.registerFactory();
    EmailService.registerFactory();
    UrlLauncherService.registerFactory();
    VersionComparatorService.registerFactory();
    RandomService.registerFactory();
    LoginForm.registerFactory();
    RegisterForm.registerFactory();
    ForgotPasswordForm.registerFactory();
    EntityDetailForm.registerFactory();
    AuthViewModel.registerFactory();
    ShellViewModel.registerFactory();
    MyAppViewModel.registerFactory();
    HomeViewModel.registerFactory();
    PlaygroundViewModel.registerFactory();
    SettingsViewModel.registerFactory();
    StylingViewModel.registerFactory();
    OopsViewModel.registerFactory();
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void registerInitialDependencies() {
    _registerRouters();
    _registerLazySingletons();
    _registerFactories();
  }

  void registerSingletons() {}

  Future<void> reset() async {
    try {
      log.info('Resetting GetIt service locator...');
      await GetIt.I.reset();
      registerInitialDependencies();

      log.info('Service reset completed successfully.');
    } catch (error, stackTrace) {
      log.error(
        'Failed to reset services',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
