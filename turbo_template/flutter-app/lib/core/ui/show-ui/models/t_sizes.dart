import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';

class TSizes {
  TSizes({required this.context, required this.deviceType});

  final BuildContext context;
  final TDeviceType deviceType;

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get keyboardInsets => MediaQuery.of(context).viewInsets.bottom;
}

