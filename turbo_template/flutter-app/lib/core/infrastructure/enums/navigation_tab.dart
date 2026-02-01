import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/generated/l10n.dart';
import 'package:turbo_flutter_template/core/ui/enums/list_position.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

enum NavigationTab {
  home,
  styling
  ;

  int get branchIndex {
    switch (this) {
      case NavigationTab.home:
        return 0;
      case NavigationTab.styling:
        return 1;
    }
  }

  ListPosition get listPosition {
    if (index == 0) return ListPosition.first;
    if (index == values.length - 1) return ListPosition.last;
    return ListPosition.middle;
  }

  static List<NavigationTab> navigationTabs({
    required TDeviceType deviceType,
  }) => values;

  static const defaultValue = NavigationTab.home;

  String label({required Strings strings}) {
    switch (this) {
      case NavigationTab.home:
        return strings.home;
      case NavigationTab.styling:
        return 'Styling';
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationTab.home:
        return Icons.home_rounded;
      case NavigationTab.styling:
        return Icons.palette_rounded;
    }
  }

  bool get isHome => this == NavigationTab.home;
}
