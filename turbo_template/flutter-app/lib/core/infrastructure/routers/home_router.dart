import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/home/home_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/playground/playground_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';

class HomeRouter extends BaseNavigation {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static HomeRouter Function() get lazyLocate =>
      () => GetIt.I.get();
  static HomeRouter get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(HomeRouter.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  @override
  NavigationTab? get navigationTab => NavigationTab.home;

  @override
  String get root => HomeView.path.asRootPath;

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void goHomeView({StatefulNavigationShell? statefulNavigationShell}) {
    if (statefulNavigationShell != null) {
      goBranch(statefulNavigationShell: statefulNavigationShell);
      if (kIsWeb) {
        // Another call is needed to update the URL in web (bug workaround)
        goBranch(statefulNavigationShell: statefulNavigationShell);
      }
    } else {
      go(
        location: root,
        extra: const [],
      );
    }
  }

  void goPlaygroundView() {
    push(
      location: makeRootRoutes(
        [
          PlaygroundView.path,
        ],
      ),
      extra: const [],
    );
  }
}
