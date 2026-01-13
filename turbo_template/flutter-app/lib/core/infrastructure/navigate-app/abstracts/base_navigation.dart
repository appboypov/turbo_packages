import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loglytics/loglytics.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/abstracts/view_arguments.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/services/base_router_service.dart';

abstract class BaseNavigation with Loglytics {
  final _baseRouterService = BaseRouterService.locate;

  String get root;

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
}
