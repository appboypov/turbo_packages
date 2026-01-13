import 'package:flutter/foundation.dart';

/// Represents the supported platforms for the application.
enum SupportedPlatform {
  android,
  ios,
  web;

  /// Returns the current platform the application is running on.
  static SupportedPlatform get current {
    if (kIsWeb) return SupportedPlatform.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return SupportedPlatform.android;
      case TargetPlatform.iOS:
        return SupportedPlatform.ios;
      default:
        return SupportedPlatform.android;
    }
  }

  /// Whether the current platform is mobile (Android or iOS).
  bool get isMobile => this == SupportedPlatform.android || this == SupportedPlatform.ios;

  /// Whether the current platform is web.
  bool get isWeb => this == SupportedPlatform.web;
}
