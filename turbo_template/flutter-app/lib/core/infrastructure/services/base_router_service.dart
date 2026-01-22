import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/view_arguments.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_router.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbolytics/turbolytics.dart';

part 'base_router_service.g.dart';

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
      final resolvedRoute = location ?? _resolveCurrentRoute();
      if (resolvedRoute == null) {
        return;
      }
      _trySendScreenAnalytic(route: resolvedRoute);
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
  final Set<void Function(String route)> _routeListeners = {};

  // 🛣️ ROUTERS ------------------------------------------------------------------------------- \\

  final coreRouter = GoRouter(
    observers: [
      FirebaseAnalyticsObserver(
        analytics: FirebaseAnalytics.instance,
      ),
    ],
    navigatorKey: rootNavigatorKey,
    initialLocation: TRoute.home.routerPath,
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
      _notifyRouteListeners(route);
    }
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void addRouteListener(void Function(String route) listener) {
    _routeListeners.add(listener);
  }

  void removeRouteListener(void Function(String route) listener) {
    _routeListeners.remove(listener);
  }

  String? _resolveCurrentRoute() {
    final configuration = coreRouter.routerDelegate.currentConfiguration;
    if (configuration.isEmpty) {
      return null;
    }
    final RouteMatch lastMatch = configuration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : configuration;
    return matchList.uri.toString();
  }

  void _notifyRouteListeners(String route) {
    for (final listener in _routeListeners) {
      listener(route);
    }
  }
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
