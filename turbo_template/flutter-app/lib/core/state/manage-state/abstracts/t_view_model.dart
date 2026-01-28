import 'package:flutter/foundation.dart';
import 'package:turbo_flutter_template/core/auth/services/auth_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/contextual_button_entry.dart';
import 'package:turbo_flutter_template/core/state/manage-state/services/contextual_buttons_service.dart';
import 'package:turbo_mvvm/data/models/t_base_view_model.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

abstract class TViewModel<ARGUMENTS> extends TBaseViewModel<ARGUMENTS>
    with TContextualButtonsManagement {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  @protected
  @override
  late final contextualButtonsService = ContextualButtonsService.locate;

  @protected
  final authService = AuthService.lazyLocate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @mustCallSuper
  @override
  Future<void> initialise() async {
    super.initialise();
    _registerContextualButtons();
  }

  @mustCallSuper
  @override
  Future<void> dispose() async {
    _unregisterContextualButtons();
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<bool> get hasAuth => authService().hasAuth;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  @protected
  TRoute? get contextualButtonsRoute;

  @protected
  List<ContextualButtonEntry> get contextualButtons;

  @protected
  ContextualButtonsBuilder get contextualButtonsBuilder =>
      () => isMounted ? contextualButtons : null;

  void _registerContextualButtons() {
    if (!isMounted) {
      return;
    }
    final route = contextualButtonsRoute;
    if (route == null) {
      return;
    }
    ContextualButtonsService.locate.registerButtons(
      route: route,
      owner: this,
      builder: contextualButtonsBuilder,
    );
  }

  void _unregisterContextualButtons() {
    ContextualButtonsService.locate.unregisterButtons(owner: this);
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}
