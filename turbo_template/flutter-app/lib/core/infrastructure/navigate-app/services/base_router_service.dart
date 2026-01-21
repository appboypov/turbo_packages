import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/auth_service.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/views/auth/auth_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/page_transition_type.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/router_type.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/services/navigation_tab_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/home/home_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/playground/playground_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/shell/shell_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/transition_builders.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbolytics/turbolytics.dart';

class BaseRouterService with Turbolytics {
  BaseRouterService() {
    coreRouter.routerDelegate.addListener(onRouteChanged);
  }

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static BaseRouterService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(BaseRouterService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\

  void onRouteChanged({String? location}) {
    try {
      if (location != null) {
        _trySendScreenAnalytic(route: location);
        return;
      }
      final RouteMatch lastMatch = coreRouter.routerDelegate.currentConfiguration.last;
      final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
          ? lastMatch.matches
          : coreRouter.routerDelegate.currentConfiguration;
      final route = matchList.uri.toString();
      _trySendScreenAnalytic(route: route);
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while fetching location',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  static final _routerType = TNotifier<RouterType>(RouterType.defaultValue);

  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  String _route = '';
  bool didInitialLocation = false;

  // 🛣️ ROUTERS ------------------------------------------------------------------------------- \\

  final coreRouter = GoRouter(
    redirect: (context, state) {
      _updateRouterType(routerType: RouterType.core);
      return null;
    },
    observers: [
      FirebaseAnalyticsObserver(
        analytics: FirebaseAnalytics.instance,
      ),
    ],
    navigatorKey: rootNavigatorKey,
    initialLocation: HomeView.path,
    routes: [
      oopsView,
      shellView,
    ],
  );

  static GoRoute get homeRouter => GoRoute(
    path: HomeView.path.asRootPath,
    redirect: (context, state) {
      _updateRouterType(routerType: RouterType.home);
      return _onAuthAccess(context: context, state: state, navigationTab: NavigationTab.home);
    },
    pageBuilder: (context, state) => _buildPage(
      child: const HomeView(),
    ),
    routes: [
      playgroundView,
    ],
  );

  // 🎭 VIEWS --------------------------------------------------------------------------------- \\

  static StatefulShellRoute shellView = StatefulShellRoute.indexedStack(
    restorationScopeId: 'shell',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state, navigationShell) =>
        _buildPage(child: ShellView(statefulNavigationShell: navigationShell)),
    branches: [
      StatefulShellBranch(
        routes: [homeRouter],
        restorationScopeId: 'household',
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'household'),
      ),
      StatefulShellBranch(
        routes: [shoppingListRouter],
        restorationScopeId: 'shoppingList',
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'shoppingList'),
      ),
      StatefulShellBranch(
        routes: [cleaningRouter],
        restorationScopeId: 'cleaning',
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'cleaning'),
      ),
      StatefulShellBranch(
        routes: [paymentsRouter],
        restorationScopeId: 'payments',
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'payments'),
      ),
    ],
  );

  static GoRoute get playgroundView => GoRoute(
    path: playgroundView.path,
    pageBuilder: (context, state) => _buildPage(child: const PlaygroundView()),
    routes: const [],
  );

  static GoRoute oopsView = GoRoute(
    path: OopsView.path.asRootPath,
    pageBuilder: (context, state) => const MaterialPage(child: OopsView()),
  );

  static GoRoute createUsernameView = GoRoute(
    path: CreateUsernameView.path.asRootPath,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(child: const CreateUsernameView()),
  );

  static GoRoute acceptPrivacyView = GoRoute(
    path: AcceptPrivacyView.path.asRootPath,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(child: const AcceptPrivacyView()),
  );

  static GoRoute verifyEmailView = GoRoute(
    path: VerifyEmailView.path.asRootPath,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) {
      final origin = state.extra is VerifyEmailOrigin
          ? state.extra as VerifyEmailOrigin
          : VerifyEmailOrigin.onboarding;
      return _buildPage(child: VerifyEmailView(origin: origin));
    },
  );

  static GoRoute get notificationSettingsView => GoRoute(
    path: NotificationSettingsView.path.asRootPath,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(child: const NotificationSettingsView()),
  );

  static GoRoute get whatsNewView => GoRoute(
    path: WhatsNewView.path.asRootPath,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(child: const WhatsNewView()),
  );

  static GoRoute get messageView => GoRoute(
    path: MessageView.path.asRootPath,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(
      child: MessageView(
        origin: MessageOrigin.core,
        arguments: MessageArguments(messageId: state.arguments()!.householdId!),
      ),
    ),
  );

  static GoRoute get joinHouseholdView => GoRoute(
    path: JoinHouseholdView.path.asRootPath,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(
      child: JoinHouseholdView(
        arguments: JoinHouseholdArguments(prefilledCode: state.prefilledCode),
        origin: JoinHouseholdOrigin.homeView,
      ),
    ),
  );

  static GoRoute get manageCleaningTaskView => GoRoute(
    path: ManageCleaningTaskView.path,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(
      child: ManageCleaningTaskView(
        arguments: ManageCleaningTaskArguments(id: state.id!),
        origin: ManageCleaningTaskOrigin.core,
      ),
    ),
  );

  static GoRoute get allPaymentsView => GoRoute(
    path: AllPaymentsView.path,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(child: const AllPaymentsView()),
  );

  static GoRoute get managePaymentView => GoRoute(
    path: ManagePaymentView.path,
    redirect: (context, state) {
      if (!_isAuthServiceReady()) {
        return AuthView.path.asRootPath;
      }
      return null;
    },
    pageBuilder: (context, state) => _buildPage(
      child: ManagePaymentView(
        arguments: ManagePaymentArguments(id: state.id!),
        origin: ManagePaymentOrigin.core,
      ),
    ),
  );

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<RouterType> get routerType => _routerType;
  String get route => _route;
  BuildContext get context => rootNavigatorKey.currentContext!;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  static FutureOr<String?> _onAuthAccess({
    required BuildContext context,
    required GoRouterState state,
    required NavigationTab? navigationTab,
  }) async {
    if (navigationTab != null) {
      final navigationTabService = NavigationTabService.locate;
      if (!BaseRouterService.locate.didInitialLocation) {
        BaseRouterService.locate.didInitialLocation = true;
        return navigationTabService.initialLocation;
      } else {
        navigationTabService.onGo(navigationTab: navigationTab);
      }
    }
    return null;
  }

  /// Safely checks if AuthService is available and user has ready auth.
  ///
  /// Returns false if service is not registered to prevent crashes.
  static Future<bool> _hasReadyAuth() async {
    try {
      if (!GetIt.I.isRegistered<AuthService>()) {
        return false;
      }
      return await AuthService.locate.hasReadyAuth;
    } catch (e) {
      // Service not available or in transitional state
      return false;
    }
  }

  static Page<dynamic> _buildPage({
    required Widget child,
    bool fullscreenDialog = false,
    PageTransitionType transitionType = PageTransitionType.platform,
  }) {
    switch (transitionType) {
      case PageTransitionType.platform:
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            return MaterialPage(
              child: child,
              fullscreenDialog: fullscreenDialog,
              maintainState: true,
            );
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoPage(
              child: child,
              fullscreenDialog: fullscreenDialog,
              maintainState: true,
            );
        }
      case PageTransitionType.custom:
        return CustomTransitionPage(
          child: child,
          barrierColor: null,
          barrierDismissible: true,
          maintainState: true,
          opaque: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          fullscreenDialog: fullscreenDialog,
          transitionDuration: TDurations.animationX0p5,
          reverseTransitionDuration: Duration.zero,
        );
      case PageTransitionType.modal:
        return ModalSheetPage(
          child: child,
          barrierColor: null,
          barrierDismissible: true,
          maintainState: true,
          fullscreenDialog: fullscreenDialog,
          transitionDuration: TDurations.animationX0p5,
        );
    }
  }

  void _trySendScreenAnalytic({required String route}) {
    if (_route != route) {
      analytics.service.screen(subject: route);
      _route = route;
    }
  }

  static void _updateRouterType({required RouterType routerType}) {
    _routerType.update(routerType);
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}
