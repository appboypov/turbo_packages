import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/view_arguments.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbolytics/turbolytics.dart';

part 'base_router_service.g.dart';

enum TRouter {
  core,
  home;

  NavigationTab? get navigationTab {
    switch (this) {
      case TRouter.home:
        return NavigationTab.home;
      case TRouter.core:
        return null;
    }
  }

  TRoute get root => switch (this) {
    TRouter.home => TRoute.home,
    TRouter.core => TRoute.core,
  };

  static TRouter of(TRoute route) {
    switch (route) {
      case TRoute.core:
      case TRoute.shell:
      case TRoute.oops:
        return TRouter.core;
      case TRoute.home:
      case TRoute.playground:
        return TRouter.home;
    }
  }

  List<RouteBase> get routes => root.routes;
  RouteBase get route => root.route;
  String get path => root.path;
  GoRouterPageBuilder get pageBuilder => root.pageBuilder();
  String get initialLocation => root.path;
}

class BaseRouterService with Turbolytics {
  BaseRouterService() {
    coreRouter.routerDelegate.addListener(onRouteChanged);
  }

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static BaseRouterService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(BaseRouterService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\

  void onRouteChanged({String? location}) {
    try {
      if (location != null) {
        _trySendScreenAnalytic(route: location);
        return;
      }
      final RouteMatch lastMatch = coreRouter.routerDelegate.currentConfiguration.last;
      final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
          ? lastMatch.matches
          : coreRouter.routerDelegate.currentConfiguration;
      final route = matchList.uri.toString();
      _trySendScreenAnalytic(route: route);
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while fetching location',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  String _currentRoute = '';
  bool didInitialLocation = false;

  // 🛣️ ROUTERS ------------------------------------------------------------------------------- \\

  final coreRouter = GoRouter(
    redirect: (context, state) {
      return null;
    },
    observers: [
      FirebaseAnalyticsObserver(
        analytics: FirebaseAnalytics.instance,
      ),
    ],
    navigatorKey: rootNavigatorKey,
    initialLocation: TRouter.core.initialLocation,
    routes: TRouter.core.routes,
  );

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  String get currentRoute => _currentRoute;
  BuildContext get context => rootNavigatorKey.currentContext!;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  void _trySendScreenAnalytic({required String route}) {
    if (_currentRoute != route) {
      analytics.service.screen(subject: route);
      _currentRoute = route;
    }
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}

@JsonSerializable(
  includeIfNull: false,
  explicitToJson: true,
)
class RouteArguments extends ViewArguments {
  RouteArguments({
    this.messageId,
    this.id,
  });

  final String? messageId;
  final String? id;

  static const fromJsonFactory = _$RouteArgumentsFromJson;
  factory RouteArguments.fromJson(Map<String, dynamic> json) => _$RouteArgumentsFromJson(json);
  static const toJsonFactory = _$RouteArgumentsToJson;
  @override
  Map<String, dynamic> toJson() => _$RouteArgumentsToJson(this);
}

extension GoRouterStateExtension on GoRouterState {
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  RouteArguments? arguments() => extra?.asType<RouteArguments>();
  String? get id => _id(TKeys.id) ?? arguments()?.id;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  String? _id(String key) => pathParameters[key] ?? uri.queryParameters[key];
}
