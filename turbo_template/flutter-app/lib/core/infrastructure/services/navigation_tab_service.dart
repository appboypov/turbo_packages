import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/home/home_view.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbolytics/turbolytics.dart';

class NavigationTabService with Turbolytics {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static NavigationTabService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(NavigationTabService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final _localStorageService = LocalStorageService.locate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  void dispose() {
    log.info('Disposing BottomNavigationService..');
    _navigationTab.dispose();
    log.info('BottomNavigationService disposed!');
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final _navigationTab = TNotifier(NavigationTab.defaultValue);

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<NavigationTab> get navigationTab => _navigationTab;
  String get initialLocation {
    final initialTab = _localStorageService.navigationTab;
    onGo(navigationTab: initialTab);
    switch (initialTab) {
      case NavigationTab.home:
        return HomeView.path.asRootPath;
    }
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void updateNavigationTab({required NavigationTab navigationTab}) {
    _navigationTab.update(navigationTab);
    _localStorageService.updateBottomNavigationIndex(navigationTab: navigationTab);
    log.info('Navigation tab updated to $navigationTab!');
  }

  void onGo({required NavigationTab navigationTab}) {
    if (this.navigationTab.value != navigationTab) {
      updateNavigationTab(navigationTab: navigationTab);
    }
  }

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
}
