import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:provider/provider.dart';
import 'package:turbo_flutter_template/core/analytics/collect-analytics/models/analytics_implementation.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/auth_service.dart';
import 'package:turbo_flutter_template/core/connection/manage-connection/services/connection_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/inject-dependencies/services/locator_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/services/theme_service.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/enums/t_supported_language.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/services/language_service.dart'
    show LanguageService;
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/shake_gesture_service.dart';
import 'package:veto/veto.dart';

class MyAppViewModel extends BaseViewModel with Turbolytics {
  MyAppViewModel({
    required LazyLocatorDef<BaseRouterService> baseRouterService,
    required LazyLocatorDef<BusyService> busyService,
    required LazyLocatorDef<ConnectionService> connectionService,
    required LocatorService locatorService,
    required LazyLocatorDef<LocalStorageService> localStorageService,
    required LazyLocatorDef<LanguageService> languageService,
    required LazyLocatorDef<ThemeService> themeService,
    required LazyLocatorDef<ShakeGestureService> shakeGestureService,
    required LazyLocatorDef<AuthService> authService,
  }) : _baseRouterService = baseRouterService,
       _busyService = busyService,
       _connectionService = connectionService,
       _locatorService = locatorService,
       _localStorageService = localStorageService,
       _languageService = languageService,
       _themeService = themeService,
       _shakeGestureService = shakeGestureService,
       _authService = authService;

  final LazyLocatorDef<BaseRouterService> _baseRouterService;
  final LazyLocatorDef<BusyService> _busyService;
  final LazyLocatorDef<ConnectionService> _connectionService;
  final LocatorService _locatorService;
  final LazyLocatorDef<LocalStorageService> _localStorageService;
  final LazyLocatorDef<LanguageService> _languageService;
  final LazyLocatorDef<ThemeService> _themeService;
  final LazyLocatorDef<ShakeGestureService> _shakeGestureService;
  final LazyLocatorDef<AuthService> _authService;

  BaseRouterService get baseRouterService => _baseRouterService();
  BusyService get busyService => _busyService();

  @override
  Future<void> initialise() async {
    log.info('Initialising app..');
    WidgetsFlutterBinding.ensureInitialized();

    final locatorService = _locatorService;
    locatorService.registerInitialDependencies();
    await _setupTurbolytics();
    locatorService.registerSingletons();
    Provider.debugCheckInvalidValueType = null;
    await _initEssentials();
    super.initialise();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  GoRouter get coreRouter => baseRouterService.coreRouter;
  ValueListenable<BusyModel> get busyListenable => busyService.isBusyListenable;
  ValueListenable<TSupportedLanguage> get language => _languageService().language;
  ValueListenable<TThemeMode> get themeMode => _themeService().themeModeListenable;
  ValueListenable<bool> get hasInternetConnection => _connectionService().hasInternetConnection;

  Future<void> _initEssentials() async {
    await _localStorageService().isReady;
    await _languageService().isReady;
    await _authService().isReady;
  }

  Future<void> _setupTurbolytics() async {
    try {
      if (Turbolytics.isActive) {
        await Turbolytics.disposeMe();
      }
      Turbolytics.setUp(
        logLevel: LogLevel.debug,
        logTime: false,
        addAnalyticsToCrashReports: true,
        maxLinesStackTrace: 100,
        analyticsInterface: AnalyticsImplementation(),
        analytics: (analyticsFactory) {},
      );
    } catch (error, stackTrace) {
      log.error('$error caught while setting up Turbolytics!', error: error, stackTrace: stackTrace);
    }
  }

  void onShakeDetected({required BuildContext context}) {
    _shakeGestureService().onShakeDetected(context: context);
  }
}
