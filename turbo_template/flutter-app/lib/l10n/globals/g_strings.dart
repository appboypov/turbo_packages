import 'package:turbo_flutter_template/generated/l10n.dart';

/// Returns the current instance of [Strings] for localization.
///
/// Provides context-free access to localized strings.
/// Must be called after the app has initialized with localization delegates.
///
/// Note: This requires a BuildContext. For context-free access, use
/// `Strings.of(context)` directly.
///
/// ```dart
/// Text(gStrings.appName)
/// ```
Strings get gStrings => throw UnimplementedError('Use Strings.of(context) instead');
