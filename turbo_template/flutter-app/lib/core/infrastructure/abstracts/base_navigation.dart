import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/view_arguments.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/navigation_tab_service.dart';
import 'package:turbolytics/turbolytics.dart';

abstract class BaseNavigation with Turbolytics {
  BaseNavigation({
    required this.router,
  }) : _baseRouterService = BaseRouterService.locate,
       _navigationTabService = NavigationTabService.locate;

  final TRouter router;

  final BaseRouterService _baseRouterService;
  final NavigationTabService _navigationTabService;

  String get root => router.root;
  NavigationTab? get navigationTab => router.navigationTab;
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

  void go({
    TRoute? route,
    List<TRoute>? routes,
    List<ViewArguments>? extra,
    BuildContext? context,
  }) {
    final path = _mapRoutes(
      [
        if (routes != null) ...routes,
        if (route != null) route,
      ],
    );
    log.debug('Going to route: $path');
    context == null
        ? _baseRouterService.context.go(path, extra: extra?.toRouteArguments)
        : context.go(path, extra: extra?.toRouteArguments);
  }

  Future<T?> push<T>({
    TRoute? route,
    List<TRoute>? routes,
    List<ViewArguments>? extra,
    BuildContext? context,
  }) {
    final path = _mapRoutes(
      [
        if (routes != null) ...routes,
        if (route != null) route,
      ],
    );
    log.info('Pushing route: $path');
    return context == null
        ? _baseRouterService.context.push<T>(path, extra: extra?.toRouteArguments)
        : context.push<T?>(path, extra: extra?.toRouteArguments);
  }

  void pushReplacement({
    TRoute? route,
    List<TRoute>? routes,
    List<ViewArguments>? extra,
    BuildContext? context,
  }) {
    final path = _mapRoutes(
      [
        if (routes != null) ...routes,
        if (route != null) route,
      ],
    );
    log.info('Pushing route: $path');
    return context == null
        ? _baseRouterService.context.pushReplacement(path, extra: extra?.toRouteArguments)
        : context.pushReplacement(path, extra: extra?.toRouteArguments);
  }

  bool canPop({BuildContext? context}) {
    log.debug('Checking if route can pop');
    final canPop = context == null ? _baseRouterService.context.canPop() : context.canPop();
    log.info('Can pop: $canPop');
    return canPop;
  }

  String _mapRoutes(List<TRoute> routes) => routes.isNotEmpty ? '$root/${_asPaths(routes)}' : root;
  String _asPaths(List<TRoute> routes) => routes.map((e) => e.rawPath).join('/');
}
