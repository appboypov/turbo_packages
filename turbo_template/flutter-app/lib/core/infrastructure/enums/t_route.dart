import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/extensions/view_extension.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/navigation_tab_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/home/home_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/playground/playground_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/shell/shell_view.dart';
import 'package:turbo_flutter_template/core/shared/views/oops/oops_view.dart';

enum TRoute {
  core,
  shell,
  home,
  playground,
  oops;

  String get path {
    switch (this) {
      case TRoute.core:
        return '/';
      case TRoute.shell:
        return 'welcome-to-your';
      case TRoute.home:
        return 'home';
      case TRoute.playground:
        return 'playground';
      case TRoute.oops:
        return 'oops';
    }
  }

  RouteBase get route {
    switch (this) {
      case TRoute.core:
        throw ArgumentError('TRoute.core does not have a single route.');
      case TRoute.shell:
        return StatefulShellRoute.indexedStack(
          restorationScopeId: TRoute.shell.path,
          parentNavigatorKey: BaseRouterService.rootNavigatorKey,
          pageBuilder: (context, state, navigationShell) =>
              TRoute.shell.pageBuilder(navigationShell: navigationShell)(context, state),
          branches: [
            StatefulShellBranch(
              routes: TRoute.shell.routes,
              restorationScopeId: TRoute.shell.path,
              navigatorKey: GlobalKey<NavigatorState>(debugLabel: TRoute.shell.path),
            ),
          ],
        );
      case TRoute.home:
        return GoRoute(
          path: path,
          redirect: (context, state) => _onAuthAccess(
            context: context,
            state: state,
            navigationTab: TRouter.of(this).navigationTab,
          ),
          pageBuilder: pageBuilder(),
          routes: routes,
        );
      case TRoute.playground:
        return GoRoute(
          path: path,
          pageBuilder: pageBuilder(),
          routes: routes,
        );
      case TRoute.oops:
        return GoRoute(
          path: path,
          pageBuilder: pageBuilder(),
        );
    }
  }

  List<RouteBase> get routes {
    switch (this) {
      case TRoute.core:
        return [
          oops.route,
          shell.route,
        ];
      case TRoute.shell:
        return [
          shell.route,
        ];
      case TRoute.home:
        return [
          playground.route,
        ];
      case TRoute.playground:
        return [];
      case TRoute.oops:
        return [];
    }
  }

  GoRouterPageBuilder pageBuilder({StatefulNavigationShell? navigationShell}) {
    switch (this) {
      case TRoute.core:
        throw ArgumentError('TRoute.core does not have a single page.');
      case TRoute.shell:
        return (context, state) => ShellView(
          statefulNavigationShell: navigationShell!,
        ).asPage();
      case TRoute.home:
        return (context, state) => const HomeView().asPage();
      case TRoute.playground:
        return (context, state) => const PlaygroundView().asPage();
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
