import 'package:get_it/get_it.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService with Turbolytics {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static UrlLauncherService get locate => GetIt.I.get();
  static void registerFactory() =>
      GetIt.I.registerFactory(UrlLauncherService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<void> tryLaunchUrl({required String url}) async {
    log.debug('Trying to launch url $url..');
    final uri = tryParseUrl(url: url);
    if (uri == null) {
      log.warning('Cannot launch url $url, URI was null');
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log.warning(
          'canLaunchUrl returned false for $url, attempting launch anyway',
        );
        // Fallback: try launching even if canLaunchUrl returns false
        // This handles edge cases where queries aren't configured but launch still works
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (error, stackTrace) {
      log.error(
        'Failed to launch url $url',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Uri? tryParseUrl({required String url}) {
    try {
      log.debug('Trying to parse url $url to Uri..');
      final parsedUrl = Uri.parse(url);
      log.debug('parsedUrl: $parsedUrl');
      return parsedUrl;
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to parse url $url to Uri',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
