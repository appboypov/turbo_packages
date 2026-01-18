import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:turbo_flutter_template/core/analytics/collect-analytics/models/analytics_implementation.dart';
import 'package:turbo_flutter_template/core/analytics/collect-analytics/models/crash_reports_implementation.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/analytics/user_analytics.dart';
import 'package:turbo_flutter_template/core/connection/manage-connection/services/connection_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/inject-dependencies/services/locator_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/show-version/services/package_info_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/services/theme_service.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/enums/t_supported_language.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/services/language_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/shake_gesture_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/toast_service.dart';
import 'package:turbo_flutter_template/environment/config/emulator_config.dart';
import 'package:turbo_flutter_template/environment/enums/environment.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:veto/veto.dart';

class MyAppViewModel extends BaseViewModel with Turbolytics {
  MyAppViewModel({
    required LazyLocatorDef<BaseRouterService> baseRouterService,
    required LazyLocatorDef<BusyService> busyService,
    required LazyLocatorDef<ConnectionService> connectionService,
    required LazyLocatorDef<PackageInfoService> packageInfoService,
    required LocatorService locatorService,
    required LazyLocatorDef<LocalStorageService> localStorageService,
    required LazyLocatorDef<LanguageService> languageService,
    required LazyLocatorDef<ThemeService> themeService,
  }) : _baseRouterService = baseRouterService,
        _busyService = busyService,
        _connectionService = connectionService,
        _packageInfoService = packageInfoService,
        _locatorService = locatorService,
        _localStorageService = localStorageService,
        _languageService = languageService,
        _themeService = themeService;

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final LazyLocatorDef<BaseRouterService> _baseRouterService;
  final LazyLocatorDef<BusyService> _busyService;
  final LazyLocatorDef<ConnectionService> _connectionService;
  final LazyLocatorDef<PackageInfoService> _packageInfoService;
  final LocatorService _locatorService;
  final LazyLocatorDef<LocalStorageService> _localStorageService;
  final LazyLocatorDef<LanguageService> _languageService;
  final LazyLocatorDef<ThemeService> _themeService;
  late final _shakeGestureService = ShakeGestureService.locate;

  BaseRouterService get baseRouterService => _baseRouterService();
  BusyService get busyService => _busyService();

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> initialise() async {
    log.info('Initialising app..');
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase is initialized in main.dart before runApp
    // Only initialize if not already done (e.g., during Phoenix.rebirth)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: Environment.current.firebaseOptions);
    }

    await EmulatorConfig.tryConfigureEmulators();

    await _trySetCurrentVersion();
    final locatorService = _locatorService;
    locatorService.registerInitialDependencies();
    await _setupStrings();
    await _setupTurbolytics();
    if (kIsWeb) {
      setPathUrlStrategy();
    }
    locatorService.registerSingletons();
    Animate.restartOnHotReload = true;
    Provider.debugCheckInvalidValueType = null;
    await _initEssentials();
    super.initialise();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  LazyLocatorDef<ToastService> get lazyToastService =>
          () => ToastService.locate;
  GoRouter get coreRouter => baseRouterService.coreRouter;
  ValueListenable<BusyModel> get busyListenable => busyService.isBusyListenable;
  ValueListenable<TSupportedLanguage> get language => _languageService().language;
  ValueListenable<TThemeMode> get themeMode => _themeService().themeModeListenable;
  ValueListenable<bool> get hasInternetConnection => _connectionService().hasInternetConnection;

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<void> _initEssentials() async {
    await _localStorageService().isReady;
    await _languageService().isReady;
  }

  Future<void> _trySetCurrentVersion() async {
    try {
      final packageInfoService = _packageInfoService;
      Environment.currentVersion = await packageInfoService().version;
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to set current version!',
        error: error,
        stackTrace: stackTrace,
      );
      Environment.currentVersion = '0.1.0';
    }
  }

  Future<void> _setupTurbolytics() async {
    try {
      if (Turbolytics.isActive) {
        await Turbolytics.disposeMe();
      }
      Turbolytics.setUp(
        logLevel: TLogLevel.debug,
        logTime: false,
        addAnalyticsToCrashReports: true,
        maxLinesStackTrace: 100,
        analyticsInterface: AnalyticsImplementation(),
        crashReportsInterface: CrashReportsImplementation(),
        analytics: (analyticsFactory) {
          analyticsFactory.registerAnalytic(() => UserAnalytics());
        },
      );
    } catch (error, stackTrace) {
      log.error('$error caught while setting up Turbolytics!', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _setupStrings() async {
    // Flutter's gen-l10n handles localization automatically through delegates
    // No manual loading needed - the locale is set via MaterialApp.locale
  }

  void onShakeDetected({required BuildContext context}) {
    _shakeGestureService.onShakeDetected(context: context);
  }
}
