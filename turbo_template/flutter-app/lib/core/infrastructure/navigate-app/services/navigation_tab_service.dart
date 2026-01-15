import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/home_view.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbolytics/turbolytics.dart';

/// Manages the current navigation tab state.
///
/// Provides reactive access to the current tab and methods for tab switching.
/// Used by the shell view to coordinate bottom navigation with routing.
class NavigationTabService with Turbolytics {
  NavigationTabService();

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static NavigationTabService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(NavigationTabService.new);

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final _currentTab = TurboNotifier<NavigationTab>(NavigationTab.home);

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  /// The current navigation tab as a listenable.
  ValueListenable<NavigationTab> get currentTab => _currentTab;

  /// The current navigation tab value.
  NavigationTab get value => _currentTab.value;

  /// Returns the initial location path for deep linking.
  ///
  /// Used when the app launches with a specific tab selected.
  String get initialLocation {
    final tab = _currentTab.value;
    return switch (tab) {
      NavigationTab.home => HomeView.path.asRootPath,
      NavigationTab.settings => HomeView.path.asRootPath, // TODO: Add SettingsView.path
    };
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Updates the current tab when navigation occurs.
  ///
  /// Called by routers when their redirect is triggered to sync tab state.
  void onGo({required NavigationTab navigationTab}) {
    if (_currentTab.value != navigationTab) {
      log.debug('Tab changed to: $navigationTab');
      _currentTab.update(navigationTab);
    }
  }

  /// Directly sets the current tab.
  ///
  /// Used when programmatically switching tabs without navigation.
  void setTab(NavigationTab tab) {
    log.debug('Setting tab to: $tab');
    _currentTab.update(tab);
  }
}
