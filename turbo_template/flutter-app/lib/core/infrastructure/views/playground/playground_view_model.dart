import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/t_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/contextual_button_entry.dart';
import 'package:turbolytics/turbolytics.dart';

class PlaygroundViewModel extends TViewModel with Turbolytics {
  PlaygroundViewModel();

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static PlaygroundViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(PlaygroundViewModel.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  TRoute? get contextualButtonsRoute => TRoute.playground;

  @override
  List<ContextualButtonEntry> get contextualButtons => const [];

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗 HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}
