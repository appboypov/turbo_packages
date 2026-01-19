import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_screen_types.dart';

/// Default device mappings for each screen type.
abstract final class TurboWidgetsDevices {
  /// Returns the default device for the given screen type.
  static DeviceInfo deviceForScreenType(TurboWidgetsScreenTypes screenType) {
    switch (screenType) {
      case TurboWidgetsScreenTypes.mobile:
        return Devices.ios.iPhone13;
      case TurboWidgetsScreenTypes.tablet:
        return Devices.ios.iPadPro11Inches;
      case TurboWidgetsScreenTypes.desktop:
        return Devices.macOS.macBookPro;
    }
  }

  /// All available mobile devices.
  static List<DeviceInfo> get mobileDevices => [
        Devices.ios.iPhoneSE,
        Devices.ios.iPhone12Mini,
        Devices.ios.iPhone12,
        Devices.ios.iPhone13Mini,
        Devices.ios.iPhone13,
        Devices.ios.iPhone13ProMax,
        Devices.ios.iPhone14Pro,
        Devices.android.samsungGalaxyA50,
        Devices.android.samsungGalaxyS20,
        Devices.android.samsungGalaxyNote20,
        Devices.android.samsungGalaxyNote20Ultra,
        Devices.android.onePlus8Pro,
        Devices.android.sonyXperia1II,
      ];

  /// All available tablet devices.
  static List<DeviceInfo> get tabletDevices => [
        Devices.ios.iPad,
        Devices.ios.iPadAir4,
        Devices.ios.iPadPro11Inches,
        Devices.ios.iPad12InchesGen2,
        Devices.ios.iPad12InchesGen4,
      ];

  /// All available desktop/laptop devices.
  static List<DeviceInfo> get desktopDevices => [
        Devices.macOS.macBookPro,
      ];

  /// Returns available devices for the given screen type.
  static List<DeviceInfo> devicesForScreenType(TurboWidgetsScreenTypes screenType) {
    switch (screenType) {
      case TurboWidgetsScreenTypes.mobile:
        return mobileDevices;
      case TurboWidgetsScreenTypes.tablet:
        return tabletDevices;
      case TurboWidgetsScreenTypes.desktop:
        return desktopDevices;
    }
  }
}
