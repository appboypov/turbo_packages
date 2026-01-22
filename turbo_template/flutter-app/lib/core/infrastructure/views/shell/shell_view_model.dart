import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/routers/home_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/routers/styling_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/t_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/contextual_button_entry.dart';
import 'package:turbo_widgets/turbo_widgets.dart';
import 'package:turbolytics/turbolytics.dart';

class ShellViewModel extends TViewModel<StatefulNavigationShell> with Turbolytics {
  static ShellViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(() => ShellViewModel());

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  TRoute? get contextualButtonsRoute => TRoute.shell;

  @override
  List<ContextualButtonEntry> get contextualButtons {
    final currentRoute = _baseRouterService.currentRoute;
    final isStyling = currentRoute.contains('/${TRoute.styling.rawPath}');
    final isHome = currentRoute.contains('/${TRoute.home.rawPath}');

    if (!isStyling && !isHome) {
      return const [];
    }

    return [
      ContextualButtonEntry(
        id: 'shell-home',
        config: TButtonConfig(
          label: 'Home',
          tooltip: 'Go home',
          icon: Icons.home_rounded,
          onPressed: onHomePressed,
          isActive: isHome,
        ),
        position: TContextualPosition.bottom,
        variation: TContextualVariation.primary,
      ),
      ContextualButtonEntry(
        id: 'shell-styling',
        config: TButtonConfig(
          label: 'Styling',
          tooltip: 'Open styling',
          icon: Icons.palette_rounded,
          onPressed: onStylingPressed,
          isActive: isStyling,
        ),
        position: TContextualPosition.bottom,
        variation: TContextualVariation.primary,
      ),
    ];
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  final BaseRouterService _baseRouterService = BaseRouterService.locate;

  void onHomePressed() {
    HomeRouter.locate.goHomeView(statefulNavigationShell: arguments);
  }

  void onStylingPressed() {
    StylingRouter.locate.goStylingView(statefulNavigationShell: arguments);
  }
}
