import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';

enum TRouter {
  core,
  home;

  NavigationTab? get navigationTab {
    switch (this) {
      case TRouter.home:
        return NavigationTab.home;
      case TRouter.core:
        return null;
    }
  }

  String get root => switch (this) {
    TRouter.home => TRoute.home.routerPath,
    TRouter.core => '',
  };

  List<RouteBase> get routes => switch (this) {
    TRouter.core => [
      TRoute.shell.route,
      TRoute.oops.route,
    ],
    TRouter.home => TRoute.home.routes,
  };
}
