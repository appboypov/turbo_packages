import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/apis/user_profiles_api.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/apis/usernames_api.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/apis/users_api.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/forms/forgot_password_form.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/forms/login_form.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/forms/register_form.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/auth_service.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/email_service.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/user_service.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/views/auth/auth_view_model.dart';
import 'package:turbo_flutter_template/core/connection/manage-connection/services/connection_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/routers/core_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/routers/home_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/services/navigation_tab_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/home/home_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/playground/playground_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/my_app/my_app_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/shell/shell_view_model.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/version_comparator_service.dart';
import 'package:turbo_flutter_template/core/settings/apis/settings_api.dart';
import 'package:turbo_flutter_template/core/settings/services/settings_service.dart';
import 'package:turbo_flutter_template/core/shared/views/oops/oops_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/services/contextual_buttons_service.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/services/badge_service.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/services/overlay_service.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/services/random_service.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/services/theme_service.dart';
import 'package:turbo_flutter_template/core/ux/launch-urls/services/url_launcher_service.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/services/language_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/dialog_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/shake_gesture_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/sheet_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/toast_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/vibrate_service.dart';
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
    CoreRouter.registerFactory();
  }

  void _registerLazySingletons() {
    ContextualButtonsService.registerLazySingleton();
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
    AuthViewModel.registerFactory();
    ShellViewModel.registerFactory();
    MyAppViewModel.registerFactory();
    HomeViewModel.registerFactory();
    PlaygroundViewModel.registerFactory();
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

      log.info('Service reset completed successfully.');
    } catch (error, stackTrace) {
      log.error('Failed to reset services', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
