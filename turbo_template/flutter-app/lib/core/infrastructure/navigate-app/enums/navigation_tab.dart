import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/list_position.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';

enum NavigationTab {
  home,
  settings;

  int get branchIndex {
    switch (this) {
      case NavigationTab.home:
        return 0;
      case NavigationTab.settings:
        return 1;
    }
  }

  ListPosition get listPosition {
    if (index == 0) return ListPosition.first;
    if (index == values.length - 1) return ListPosition.last;
    return ListPosition.middle;
  }

  static List<NavigationTab> navigationTabs({required TDeviceType deviceType}) => values;

  static const defaultValue = NavigationTab.home;


  String label({required BuildContext context}) {
    final strings = context.strings;
    switch (this) {
      case NavigationTab.home:
        return strings.home;
      case NavigationTab.settings:
        return strings.settings;
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationTab.home:
        return Icons.home_rounded;
      case NavigationTab.settings:
        return Icons.settings;
    }
  }

  bool get isSettings => this == NavigationTab.settings;
  bool get isHome => this == NavigationTab.home;
}
