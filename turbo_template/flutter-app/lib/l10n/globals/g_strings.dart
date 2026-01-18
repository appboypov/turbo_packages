import 'package:turbo_flutter_template/generated/l10n.dart';
import 'package:turbo_flutter_template/l10n/globals/g_context.dart';

/// Returns the current instance of [Strings] for localization.
///
/// Provides context-free access to localized strings.
/// Must be called after the app has initialized with localization delegates.
///
/// Note: This requires the navigator context to be available. For direct
/// context-based access, use `Strings.of(context)` or `context.strings`.
///
/// ```dart
/// Text(gStrings.appName)
/// ```
Strings get gStrings {
  final context = gContext;
  assert(context != null, 'gContext is null - navigator not yet available');
  return Strings.of(context!);
}
