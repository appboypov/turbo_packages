import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/view_arguments.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/navigation_tab_service.dart';
import 'package:turbolytics/turbolytics.dart';

abstract class BaseNavigation with Turbolytics {
  final _baseRouterService = BaseRouterService.locate;
  final _navigationTabService = NavigationTabService.locate;

  String get root;
  NavigationTab? get navigationTab;
  NavigationTab get currentNavigationTab => _navigationTabService.navigationTab.value;

  void goBranch({required StatefulNavigationShell statefulNavigationShell}) {
    final initialLocation = currentNavigationTab;
    final cNavigationTab = navigationTab;
    final branchIndex = cNavigationTab!.branchIndex;

    // Add bounds checking to prevent go_router assertion failure
    if (branchIndex < 0 || branchIndex >= statefulNavigationShell.route.branches.length) {
      log.error(
        'Invalid branch index: $branchIndex, available branches: ${statefulNavigationShell.route.branches.length}',
      );
      return;
    }

    statefulNavigationShell.goBranch(
      branchIndex,
      initialLocation: switch (cNavigationTab) {
        NavigationTab.home => initialLocation.isHome,
      },
    );
  }

  void go({required String location, List<ViewArguments>? extra, BuildContext? context}) {
    log.debug('Going to route: $location');
    context == null
        ? _baseRouterService.context.go(location, extra: extra?.toExtraArguments)
        : context.go(location, extra: extra?.toExtraArguments);
  }

  Future<T?> push<T>({
    required String location,
    List<ViewArguments>? extra,
    BuildContext? context,
  }) {
    log.info('Pushing route: $location');
    return context == null
        ? _baseRouterService.context.push<T>(location, extra: extra?.toExtraArguments)
        : context.push<T?>(location, extra: extra?.toExtraArguments);
  }

  void pushReplacement({
    required String location,
    List<ViewArguments>? extra,
    BuildContext? context,
  }) {
    log.info('Pushing route: $location');
    return context == null
        ? _baseRouterService.context.pushReplacement(location, extra: extra?.toExtraArguments)
        : context.pushReplacement(location, extra: extra?.toExtraArguments);
  }

  bool canPop({BuildContext? context}) {
    log.debug('Checking if route can pop');
    final canPop = context == null ? _baseRouterService.context.canPop() : context.canPop();
    log.info('Can pop: $canPop');
    return canPop;
  }

  String makeRootRoutes(List<String> routes) => '$root/${routes.join('/')}';
  String makeRoutes(List<String> routes) => '$location';
}
