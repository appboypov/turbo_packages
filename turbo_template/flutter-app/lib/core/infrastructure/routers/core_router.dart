import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_router.dart';

class CoreRouter extends BaseNavigation {
  CoreRouter({required super.router});

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static CoreRouter Function() get lazyLocate =>
      () => GetIt.I.get<CoreRouter>();
  static CoreRouter get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(
    () => CoreRouter(router: TRouter.core),
  );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void goHomeView() => go(
    route: TRoute.home,
  );

  void goOopsView() => WidgetsBinding.instance.addPostFrameCallback((_) {
    go(
      route: TRoute.oops,
    );
  });
}
