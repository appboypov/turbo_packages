import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/config/turbo_breakpoint_config.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';

extension BoxConstraintsExtension on BoxConstraints {
  TDeviceType turboDeviceType({required TBreakpointConfig breakpointConfig}) {
    if (maxWidth < 600) {
      return TDeviceType.mobile;
    } else if (maxWidth < 1024) {
      return TDeviceType.tablet;
    } else {
      return TDeviceType.desktop;
    }
  }

  Orientation get turboOrientation {
    return maxWidth > maxHeight ? Orientation.landscape : Orientation.portrait;
  }
}

