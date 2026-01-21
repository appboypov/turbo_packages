import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/shell/shell_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/shared/views/oops/oops_view.dart';

class CoreRouter extends BaseNavigation {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static CoreRouter Function() get lazyLocate =>
      () => GetIt.I.get<CoreRouter>();
  static CoreRouter get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(CoreRouter.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  NavigationTab? get navigationTab => null;

  @override
  String get root => ShellView.path;

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void goOopsView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      go(location: OopsView.path.asRootPath);
    });
  }
}
