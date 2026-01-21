import 'package:get_it/get_it.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class ContextualButtonsService extends TContextualButtonsService {
  static ContextualButtonsService get locate => GetIt.I.get();
  static ContextualButtonsService Function() get lazyLocate =>
      () => GetIt.I.get();
  static void registerLazySingleton() =>
      GetIt.I.registerLazySingleton(ContextualButtonsService.new);
}
