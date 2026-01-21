import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';

/// Returns the top-level safe area padding.
double? get gTopSafeArea {
  final context = gContext;
  if (context == null) return null;
  return MediaQuery.of(context).padding.top;
}

/// Returns the bottom-level safe area padding.
double? get gBottomSafeArea {
  final context = gContext;
  if (context == null) return null;
  return MediaQuery.of(context).padding.bottom;
}

/// Returns the current global BuildContext from the root navigator.
///
/// Useful for accessing context outside of widget tree, such as in services.
/// Returns null if the navigator state is not available.
BuildContext? get gContext {
  return BaseRouterService.rootNavigatorKey.currentState?.context;
}
