import 'package:get_it/get_it.dart';
import 'package:turbolytics/turbolytics.dart';

/// Service for comparing semantic version strings in the format 0.0.0 (major.minor.patch).
///
/// Provides functionality to determine if one version is newer than another by
/// comparing each component of the version number in order of significance.
class VersionComparatorService with Turbolytics {
  VersionComparatorService();

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  /// Returns the registered instance of [VersionComparatorService].
  static VersionComparatorService get locate => GetIt.I.get();

  /// Registers a factory for [VersionComparatorService] with the GetIt service locator.
  static void registerFactory() => GetIt.I.registerFactory(VersionComparatorService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  /// Determines if [currentVersion] is newer than [lastReadVersion].
  ///
  /// Compares version strings by splitting them into major, minor, and patch components
  /// and comparing each component numerically in order of significance.
  ///
  /// Returns `true` if [currentVersion] is newer than [lastReadVersion] or if
  /// [lastReadVersion] is `null`. Returns `false` otherwise.
  ///
  /// ```dart
  /// isNewerVersion(currentVersion: '1.2.3', lastReadVersion: '1.2.2') == true
  /// isNewerVersion(currentVersion: '2.0.0', lastReadVersion: '1.9.9') == true
  /// isNewerVersion(currentVersion: '1.2.3', lastReadVersion: '1.2.3') == false
  /// isNewerVersion(currentVersion: '1.2.0', lastReadVersion: '1.2.1') == false
  /// ```
  bool isNewerVersion({required String currentVersion, String? lastReadVersion}) {
    if (lastReadVersion == null) return true;

    final current = currentVersion.split('.');
    final lastRead = lastReadVersion.split('.');

    final currentMajor = int.tryParse(current[0]) ?? 0;
    final lastReadMajor = int.tryParse(lastRead[0]) ?? 0;
    if (currentMajor > lastReadMajor) return true;
    if (currentMajor < lastReadMajor) return false;

    if (current.length > 1 && lastRead.length > 1) {
      final currentMinor = int.tryParse(current[1]) ?? 0;
      final lastReadMinor = int.tryParse(lastRead[1]) ?? 0;
      if (currentMinor > lastReadMinor) return true;
      if (currentMinor < lastReadMinor) return false;
    }

    if (current.length > 2 && lastRead.length > 2) {
      final currentPatch = int.tryParse(current[2]) ?? 0;
      final lastReadPatch = int.tryParse(lastRead[2]) ?? 0;
      if (currentPatch > lastReadPatch) return true;
    }

    return false;
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}
