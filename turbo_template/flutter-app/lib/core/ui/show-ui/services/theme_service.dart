import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';

class ThemeService with Turbolytics {
  static ThemeService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(ThemeService.new);

  final _localStorageService = LocalStorageService.locate;

  late final _themeMode = TurboNotifier<TThemeMode>(TThemeMode.defaultValue);

  TThemeMode get themeMode => _themeMode.value;
  ValueListenable<TThemeMode> get themeModeListenable => _themeMode;

  void updateThemeMode({required TThemeMode themeMode}) {
    log.info('Updating theme mode..');
    _localStorageService.updateTThemeMode(themeMode: themeMode);
    _themeMode.update(themeMode);
    log.info('Theme update!');
  }

  Future<void> toggleThemeMode() async {
    log.info('Switching theme mode..');
    if (_themeMode.value == TThemeMode.light) {
      await _localStorageService.updateTThemeMode(themeMode: TThemeMode.dark);
      _themeMode.update(TThemeMode.dark);
    } else {
      await _localStorageService.updateTThemeMode(themeMode: TThemeMode.light);
      _themeMode.update(TThemeMode.light);
    }
    log.info('Theme mode switched!');
  }
}
