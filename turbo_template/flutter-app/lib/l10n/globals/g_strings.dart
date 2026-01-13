import 'package:turbo_flutter_template/generated/l10n.dart';

/// Returns the current instance of [S] for localization.
///
/// Provides context-free access to localized strings.
/// Must be called after the app has initialized with localization delegates.
///
/// ```dart
/// Text(gStrings.appName)
/// ```
S get gStrings => S.current;
