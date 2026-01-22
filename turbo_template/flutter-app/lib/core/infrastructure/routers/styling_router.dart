import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_router.dart';

class StylingRouter extends BaseNavigation {
  StylingRouter({required super.router});

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static StylingRouter Function() get lazyLocate =>
      () => GetIt.I.get();
  static StylingRouter get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(
    () => StylingRouter(router: TRouter.styling),
  );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void goStylingView({StatefulNavigationShell? statefulNavigationShell}) {
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
}
