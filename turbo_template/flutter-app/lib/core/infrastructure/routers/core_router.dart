import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/shell/shell_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/shared/views/oops/oops_view.dart';

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

  void goShellView() => go(
    route: TRoute.shell,
  );

  void goOopsView() => WidgetsBinding.instance.addPostFrameCallback((_) {
    go(
      route: TRoute.oops,
    );
  });
}
