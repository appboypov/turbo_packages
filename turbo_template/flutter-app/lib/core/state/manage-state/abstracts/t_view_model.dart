import 'package:flutter/foundation.dart';
import 'package:turbo_flutter_template/core/auth/services/auth_service.dart';
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
  }

  @mustCallSuper
  @override
  Future<void> dispose() async {
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<bool> get hasAuth => authService().hasAuth;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}
