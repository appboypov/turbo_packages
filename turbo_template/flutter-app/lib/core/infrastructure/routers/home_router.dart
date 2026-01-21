import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/home/home_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/playground/playground_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';

class HomeRouter extends BaseNavigation {
  HomeRouter({required super.router});

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static HomeRouter Function() get lazyLocate =>
      () => GetIt.I.get();
  static HomeRouter get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(
    () => HomeRouter(router: TRouter.home),
  );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void goHomeView({StatefulNavigationShell? statefulNavigationShell}) {
    if (statefulNavigationShell != null) {
      goBranch(statefulNavigationShell: statefulNavigationShell);
      if (kIsWeb) {
        // Another call is needed to update the URL in web (bug workaround)
        goBranch(statefulNavigationShell: statefulNavigationShell);
      }
    } else {
      go();
    }
  }

  void goPlaygroundView() => push(
    route: TRoute.playground,
    extra: const [],
  );
}
