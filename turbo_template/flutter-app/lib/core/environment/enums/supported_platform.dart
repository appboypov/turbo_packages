import 'package:flutter/foundation.dart';

/// Represents the supported platforms for the application.
enum SupportedPlatform {
  android,
  ios,
  macos,
  windows,
  linux,
  web;

  /// Returns the current platform the application is running on.
  static SupportedPlatform get current {
    if (kIsWeb) return SupportedPlatform.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return SupportedPlatform.android;
      case TargetPlatform.iOS:
        return SupportedPlatform.ios;
      case TargetPlatform.macOS:
        return SupportedPlatform.macos;
      case TargetPlatform.windows:
        return SupportedPlatform.windows;
      case TargetPlatform.linux:
        return SupportedPlatform.linux;
      default:
        return SupportedPlatform.ios;
    }
  }

  /// Whether the current platform is mobile (Android or iOS).
  bool get isMobile =>
      this == SupportedPlatform.android || this == SupportedPlatform.ios;

  /// Whether the current platform is desktop (Windows, macOS, or Linux).
  bool get isDesktop =>
      this == SupportedPlatform.windows ||
      this == SupportedPlatform.macos ||
      this == SupportedPlatform.linux;

  /// Whether the current platform is web.
  bool get isWeb => this == SupportedPlatform.web;
}
