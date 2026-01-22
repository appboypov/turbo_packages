import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/t_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/contextual_button_entry.dart';
import 'package:turbolytics/turbolytics.dart';

class StylingViewModel extends TViewModel with Turbolytics {
  static StylingViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(
    () => StylingViewModel(),
  );

  @override
  TRoute? get contextualButtonsRoute => TRoute.styling;

  @override
  List<ContextualButtonEntry> get contextualButtons => const [];
}
