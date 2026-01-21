import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:turbo_flutter_template/core/infrastructure/abstracts/view_arguments.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/page_transition_type.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/router_type.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/navigation_tab_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/home/home_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/playground/playground_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/shell/shell_view.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/shared/views/oops/oops_view.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/widgets/transition_builders.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbolytics/turbolytics.dart';

part 'base_router_service.g.dart';

@JsonSerializable(
  includeIfNull: false,
  explicitToJson: true,
)
class ExtraArguments extends ViewArguments {
  ExtraArguments({
    this.messageId,
    this.id,
  });

  final String? messageId;
  final String? id;

  static const fromJsonFactory = _$ExtraArgumentsFromJson;
  factory ExtraArguments.fromJson(Map<String, dynamic> json) => _$ExtraArgumentsFromJson(json);
  static const toJsonFactory = _$ExtraArgumentsToJson;
  @override
  Map<String, dynamic> toJson() => _$ExtraArgumentsToJson(this);
}

extension GoRouterStateExtension on GoRouterState {
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  ExtraArguments? arguments() => extra?.asType<ExtraArguments>();
  String? get id => _id(TKeys.id) ?? arguments()?.id;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  String? _id(String key) => pathParameters[key] ?? uri.queryParameters[key];
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

  static final _routerType = TNotifier<RouterType>(RouterType.defaultValue);

  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  String _route = '';
  bool didInitialLocation = false;

  // 🛣️ ROUTERS ------------------------------------------------------------------------------- \\

  final coreRouter = GoRouter(
    redirect: (context, state) {
      _updateRouterType(routerType: RouterType.core);
      return null;
    },
    observers: [
      FirebaseAnalyticsObserver(
        analytics: FirebaseAnalytics.instance,
      ),
    ],
    navigatorKey: rootNavigatorKey,
    initialLocation: HomeView.path.asRootPath,
    routes: [
      oopsView,
      shellView,
    ],
  );

  static GoRoute get homeRouter => GoRoute(
    path: HomeView.path.asRootPath,
    redirect: (context, state) {
      _updateRouterType(routerType: RouterType.home);
      return _onAuthAccess(context: context, state: state, navigationTab: NavigationTab.home);
    },
    pageBuilder: (context, state) => _buildPage(
      child: const HomeView(),
    ),
    routes: [
      playgroundView,
    ],
  );

  // 🎭 VIEWS --------------------------------------------------------------------------------- \\

  static StatefulShellRoute shellView = StatefulShellRoute.indexedStack(
    restorationScopeId: 'shell',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state, navigationShell) =>
        _buildPage(child: ShellView(statefulNavigationShell: navigationShell)),
    branches: [
      StatefulShellBranch(
        routes: [
          homeRouter,
        ],
        restorationScopeId: 'household',
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'household'),
      ),
    ],
  );

  static GoRoute get playgroundView => GoRoute(
    path: PlaygroundView.path,
    pageBuilder: (context, state) => _buildPage(child: const PlaygroundView()),
    routes: const [],
  );

  static GoRoute oopsView = GoRoute(
    path: OopsView.path.asRootPath,
    pageBuilder: (context, state) => const MaterialPage(child: OopsView()),
  );

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<RouterType> get routerType => _routerType;
  String get route => _route;
  BuildContext get context => rootNavigatorKey.currentContext!;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  static FutureOr<String?> _onAuthAccess({
    required BuildContext context,
    required GoRouterState state,
    required NavigationTab? navigationTab,
  }) async {
    if (navigationTab != null) {
      final navigationTabService = NavigationTabService.locate;
      if (!BaseRouterService.locate.didInitialLocation) {
        BaseRouterService.locate.didInitialLocation = true;
        return navigationTabService.initialLocation;
      } else {
        navigationTabService.onGo(navigationTab: navigationTab);
      }
    }
    return null;
  }

  static Page<dynamic> _buildPage({
    required Widget child,
    bool fullscreenDialog = false,
    PageTransitionType transitionType = PageTransitionType.platform,
  }) {
    switch (transitionType) {
      case PageTransitionType.platform:
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            return MaterialPage(
              child: child,
              fullscreenDialog: fullscreenDialog,
              maintainState: true,
            );
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoPage(
              child: child,
              fullscreenDialog: fullscreenDialog,
              maintainState: true,
            );
        }
      case PageTransitionType.custom:
        return CustomTransitionPage(
          child: child,
          barrierColor: null,
          barrierDismissible: true,
          maintainState: true,
          opaque: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          fullscreenDialog: fullscreenDialog,
          transitionDuration: TDurations.animationX0p5,
          reverseTransitionDuration: Duration.zero,
        );
      case PageTransitionType.modal:
        return ModalSheetPage(
          child: child,
          barrierColor: null,
          barrierDismissible: true,
          maintainState: true,
          fullscreenDialog: fullscreenDialog,
          transitionDuration: TDurations.animationX0p5,
        );
    }
  }

  void _trySendScreenAnalytic({required String route}) {
    if (_route != route) {
      analytics.service.screen(subject: route);
      _route = route;
    }
  }

  static void _updateRouterType({required RouterType routerType}) {
    _routerType.update(routerType);
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}
