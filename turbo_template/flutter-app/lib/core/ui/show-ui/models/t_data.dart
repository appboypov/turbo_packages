import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';

class TData {
  const TData({
    required this.currentWidth,
    required this.currentHeight,
    required this.orientation,
    required this.deviceType,
    required this.media,
  });

  final double currentWidth;
  final double currentHeight;
  final Orientation orientation;
  final TDeviceType deviceType;
  final MediaQueryData media;
}

