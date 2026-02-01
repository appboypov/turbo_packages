import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/routers/styling_router.dart';

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

  void goSettingsView() => push(
    route: TRoute.settings,
    extra: const [],
  );

  void goStylingView({StatefulNavigationShell? statefulNavigationShell}) {
    if (statefulNavigationShell != null) {
      StylingRouter.locate.goStylingView(
        statefulNavigationShell: statefulNavigationShell,
      );
    } else {
      StylingRouter.locate.goStylingView();
    }
  }
}
