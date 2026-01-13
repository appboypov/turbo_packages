import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/l10n/globals/g_strings.dart';

/// Represents the navigation tabs in the bottom navigation bar.
///
/// Each tab corresponds to a main section of the app accessible from
/// the bottom navigation.
enum NavigationTab {
  /// Home/dashboard tab
  home,

  /// Settings tab
  settings;

  /// Returns the position of this tab in the navigation bar.
  int get position => switch (this) {
    NavigationTab.home => 0,
    NavigationTab.settings => 1,
  };

  /// Returns the tab at the given index.
  static NavigationTab fromIndex(int index) => switch (index) {
    0 => NavigationTab.home,
    1 => NavigationTab.settings,
    _ => NavigationTab.home,
  };

  /// Returns the icon for this tab.
  IconData get icon => switch (this) {
    NavigationTab.home => Icons.home_outlined,
    NavigationTab.settings => Icons.settings_outlined,
  };

  /// Returns the filled icon for this tab when selected.
  IconData get selectedIcon => switch (this) {
    NavigationTab.home => Icons.home,
    NavigationTab.settings => Icons.settings,
  };

  /// Returns the localized label for this tab.
  String get label => switch (this) {
    NavigationTab.home => gStrings.home,
    NavigationTab.settings => gStrings.settings,
  };
}
