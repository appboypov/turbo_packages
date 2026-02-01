import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/mixins/logout_management.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/routers/home_router.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/t_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/contextual_button_entry.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_flutter_template/core/ui/abstract/slidable_management.dart';
import 'package:turbo_flutter_template/core/ui/services/badge_service.dart';
import 'package:turbo_widgets/turbo_widgets.dart';
import 'package:turbolytics/turbolytics.dart';

class HomeViewModel extends TViewModel with Turbolytics, SlidableManagement, LogoutManagement {
  HomeViewModel({
    required BadgeService badgeService,
    required LazyLocatorDef<HomeRouter> homeRouter,
  }) : _badgeService = badgeService,
       _homeRouter = homeRouter;

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static HomeViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(
    () => HomeViewModel(
      badgeService: BadgeService.locate,
      homeRouter: () => HomeRouter.locate,
    ),
  );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final BadgeService _badgeService;
  final LazyLocatorDef<HomeRouter> _homeRouter;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> initialise({bool doSetInitialised = true}) async {
    await updateContextualButtonsAnimated((current) => current.copyWith());
    await super.initialise(doSetInitialised: doSetInitialised);
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  TRoute? get contextualButtonsRoute => TRoute.home;

  @override
  List<ContextualButtonEntry> get contextualButtons => [
    ContextualButtonEntry(
      id: 'home-playground',
      config: TButtonConfig(
        label: 'Playground',
        tooltip: 'Open playground',
        icon: Icons.play_arrow_rounded,
        onPressed: onPlaygroundPressed,
      ),
      position: TContextualPosition.top,
    ),
    ContextualButtonEntry(
      id: 'home-settings',
      config: TButtonConfig(
        label: 'Settings',
        tooltip: 'Open settings',
        icon: Icons.settings_rounded,
        onPressed: onSettingsPressed,
      ),
      position: TContextualPosition.top,
    ),
    ContextualButtonEntry(
      id: 'home-logout',
      config: TButtonConfig(
        label: 'Logout',
        tooltip: 'Log out',
        icon: Icons.logout_rounded,
        onPressed: onLogoutTapped,
      ),
      position: TContextualPosition.top,
    ),
    ContextualButtonEntry(
      id: 'home-dummy',
      config: TButtonConfig(
        label: 'Dummy',
        tooltip: 'No-op',
        icon: Icons.circle_outlined,
        onPressed: () {},
      ),
      position: TContextualPosition.bottom,
    ),
  ];

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<bool> get showInboxBadge => _badgeService.showInboxBadge;

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void onPlaygroundPressed() => _homeRouter().goPlaygroundView();

  void onSettingsPressed() => _homeRouter().goSettingsView();

  void onLogoutTapped() {
    final currentContext = context;
    if (currentContext == null) {
      return;
    }
    onLogoutPressed(context: currentContext);
  }
}
