import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/extensions/view_extension.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/navigation_tab_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/home/home_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/playground/playground_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/settings/settings_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/shell/shell_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/styling/styling_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/shared/views/oops/oops_view.dart';

enum TRoute {
  shell,
  home,
  styling,
  playground,
  settings,
  oops;

  bool get isRootPath => switch (this) {
    TRoute.shell => false,
    TRoute.home => true,
    TRoute.oops => true,
    TRoute.styling => true,
    TRoute.playground => false,
    TRoute.settings => false,
  };

  String get routerPath => isRootPath ? rawPath.asRootPath : rawPath;

  String get rawPath {
    switch (this) {
      case TRoute.shell:
        return 'welcome-to-your';
      case TRoute.home:
        return 'home';
      case TRoute.styling:
        return 'styling';
      case TRoute.playground:
        return 'playground';
      case TRoute.settings:
        return 'settings';
      case TRoute.oops:
        return 'oops';
    }
  }

  List<RouteBase> get routes {
    switch (this) {
      case TRoute.shell:
        return [
          home.route,
          styling.route,
        ];
      case TRoute.home:
        return [
          playground.route,
          settings.route,
        ];
      case TRoute.styling:
        return [];
      case TRoute.playground:
        return [];
      case TRoute.settings:
        return [];
      case TRoute.oops:
        return [];
    }
  }

  RouteBase get route {
    switch (this) {
      case TRoute.shell:
        return StatefulShellRoute.indexedStack(
          restorationScopeId: TRoute.shell.routerPath,
          parentNavigatorKey: BaseRouterService.rootNavigatorKey,
          pageBuilder: (context, state, navigationShell) =>
              TRoute.shell.pageBuilder(navigationShell: navigationShell)(context, state),
          branches: [
            StatefulShellBranch(
              routes: [
                home.route,
              ],
              restorationScopeId: TRoute.home.routerPath,
              navigatorKey: GlobalKey<NavigatorState>(debugLabel: TRoute.home.routerPath),
            ),
            StatefulShellBranch(
              routes: [
                styling.route,
              ],
              restorationScopeId: TRoute.styling.routerPath,
              navigatorKey: GlobalKey<NavigatorState>(debugLabel: TRoute.styling.routerPath),
            ),
          ],
        );
      case TRoute.home:
        return GoRoute(
          path: routerPath,
          redirect: (context, state) => _onAuthAccess(
            context: context,
            state: state,
            navigationTab: TRouter.home.navigationTab,
          ),
          pageBuilder: pageBuilder(),
          routes: routes,
        );
      case TRoute.playground:
        return GoRoute(
          path: routerPath,
          pageBuilder: pageBuilder(),
          routes: routes,
        );
      case TRoute.styling:
        return GoRoute(
          path: routerPath,
          redirect: (context, state) => _onAuthAccess(
            context: context,
            state: state,
            navigationTab: TRouter.styling.navigationTab,
          ),
          pageBuilder: pageBuilder(),
          routes: routes,
        );
      case TRoute.settings:
        return GoRoute(
          path: routerPath,
          pageBuilder: pageBuilder(),
          routes: routes,
        );
      case TRoute.oops:
        return GoRoute(
          path: routerPath,
          pageBuilder: pageBuilder(),
        );
    }
  }

  GoRouterPageBuilder pageBuilder({StatefulNavigationShell? navigationShell}) {
    switch (this) {
      case TRoute.shell:
        return (context, state) => ShellView(
          statefulNavigationShell: navigationShell!,
        ).asPage();
      case TRoute.home:
        return (context, state) => const HomeView().asPage();
      case TRoute.playground:
        return (context, state) => const PlaygroundView().asPage();
      case TRoute.styling:
        return (context, state) => const StylingView().asPage();
      case TRoute.settings:
        return (context, state) => const SettingsView().asPage();
      case TRoute.oops:
        return (context, state) => const OopsView().asPage();
    }
  }

  String? _onAuthAccess({
    required BuildContext context,
    required GoRouterState state,
    required NavigationTab? navigationTab,
  }) {
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
}
