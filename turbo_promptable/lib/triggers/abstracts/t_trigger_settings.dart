import 'package:turbo_promptable/triggers/dtos/t_trigger_kind_dto.dart';

/// plx trigger settings. Subclass it once in the `triggers/` folder of the
/// plx settings folder and declare one top-level value of the subclass.
abstract class TTriggerSettings {
  const TTriggerSettings();

  /// The trigger kinds, with unique names. Every watched folder uses them.
  List<TTriggerKindDto> get kinds;

  /// Gitignore-style rules relative to each watched folder. plx skips the
  /// files and folders they exclude, also behind symlinks.
  List<String> get ignore => const [];
}
