import 'package:flutter/cupertino.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_device.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

extension TTargetPlatformExtensionExtension on TargetPlatform {
  TDevice get defaultDevice {
    switch (this) {
      case TargetPlatform.android:
        return TDevice.androidCompact;
      case TargetPlatform.iOS:
        return TDevice.iPhone16Pro;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return TDevice.desktop;
    }
  }

  TDeviceType get defaultDeviceType {
    switch (this) {
      case TargetPlatform.android:
        return TDeviceType.mobile;
      case TargetPlatform.iOS:
        return TDeviceType.mobile;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return TDeviceType.desktop;
    }
  }

  double get defaultWidthInDesign => TDevice.desktop.width;

  double get defaultHeightInDesign => TDevice.desktop.height;
}
