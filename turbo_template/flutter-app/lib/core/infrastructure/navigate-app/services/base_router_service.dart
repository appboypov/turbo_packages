import 'dart:async';

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
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/shell/shell_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbolytics/turbolytics.dart';

class BaseRouterService with Turbolytics {
  static const String _testRoute = String.fromEnvironment('route');

  BaseRouterService() {
    coreRouter.routerDelegate.addListener(onRouteChanged);
  }

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static BaseRouterService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(BaseRouterService.new);

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
    navigatorKey: rootNavigatorKey,
    initialLocation: _testRoute.isNotEmpty ? _testRoute : ShellView.path.asRootPath,
    routes: [shellView, authView],
  );

  // 🎭 VIEWS --------------------------------------------------------------------------------- \\

  static GoRoute get shellView => GoRoute(
    path: ShellView.path.asRootPath,
    redirect: (context, state) {
      _updateRouterType(routerType: RouterType.core);
      return null;
    },
    pageBuilder: (context, state) => _buildPage(child: const ShellView()),
  );

  static GoRoute get authView => GoRoute(
    path: AuthView.path.asRootPath,
    pageBuilder: (context, state) => _buildPage(child: const AuthView()),
  );

  /// Home view router - example of an authenticated route.
  ///
  /// Uncomment and adapt when implementing bottom navigation:
  /// ```dart
  /// static GoRoute get homeRouter => GoRoute(
  ///   path: HomeView.path.asRootPath,
  ///   redirect: (context, state) {
  ///     _updateRouterType(routerType: RouterType.home);
  ///     return onAuthAccess(context: context, state: state, navigationTab: NavigationTab.home);
  ///   },
  ///   pageBuilder: (context, state) => _buildPage(child: const HomeView()),
  /// );
  /// ```

  /// StatefulShellRoute for bottom navigation - uncomment when needed:
  ///
  /// ```dart
  /// static StatefulShellRoute shellViewWithTabs = StatefulShellRoute.indexedStack(
  ///   restorationScopeId: 'shell',
  ///   parentNavigatorKey: rootNavigatorKey,
  ///   pageBuilder: (context, state, navigationShell) =>
  ///       _buildPage(child: ShellViewWithTabs(statefulNavigationShell: navigationShell)),
  ///   branches: [
  ///     StatefulShellBranch(
  ///       routes: [homeRouter],
  ///       restorationScopeId: 'home',
  ///       navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'home'),
  ///     ),
  ///     StatefulShellBranch(
  ///       routes: [settingsRouter],
  ///       restorationScopeId: 'settings',
  ///       navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'settings'),
  ///     ),
  ///   ],
  /// );
  /// ```

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<RouterType> get routerType => _routerType;
  String get route => _route;
  BuildContext get context => rootNavigatorKey.currentContext!;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  /// Safely checks if AuthService is available and user is authenticated.
  ///
  /// Returns false if service is not registered (e.g., during app restart)
  /// to prevent crashes during Phoenix.rebirth scenarios.
  ///
  /// Use in route guards to check auth state synchronously.
  static bool isAuthServiceReady() {
    try {
      return GetIt.I.isRegistered<AuthService>() && AuthService.locate.hasAuth.value;
    } catch (e) {
      return false;
    }
  }

  /// Safely checks if AuthService is available and user has ready auth.
  ///
  /// Returns false if service is not registered to prevent crashes.
  ///
  /// Use in async route guards that need to wait for auth state.
  static Future<bool> hasReadyAuth() async {
    try {
      if (!GetIt.I.isRegistered<AuthService>()) {
        return false;
      }
      return await AuthService.locate.hasReadyAuth;
    } catch (e) {
      return false;
    }
  }

  /// Auth access guard for protected routes.
  ///
  /// Redirects to auth view if user is not authenticated.
  /// Updates navigation tab state when accessing authenticated routes.
  ///
  /// Example usage in a route redirect:
  /// ```dart
  /// redirect: (context, state) => onAuthAccess(
  ///   context: context,
  ///   state: state,
  ///   navigationTab: NavigationTab.home,
  /// ),
  /// ```
  static FutureOr<String?> onAuthAccess({
    required BuildContext context,
    required GoRouterState state,
    required NavigationTab? navigationTab,
  }) async {
    if (await hasReadyAuth()) {
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
    } else {
      return AuthView.path.asRootPath;
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
        return MaterialPage(child: child, fullscreenDialog: fullscreenDialog, maintainState: true);
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
      try {
        analytics.service.screen(subject: route);
      } catch (error, stackTrace) {
        log.error('Failed to send screen analytic', error: error, stackTrace: stackTrace);
      }
      _route = route;
    }
  }

  static void _updateRouterType({required RouterType routerType}) {
    _routerType.update(routerType);
  }
}
