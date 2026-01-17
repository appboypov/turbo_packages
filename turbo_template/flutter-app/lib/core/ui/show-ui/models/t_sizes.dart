import 'dart:math';

import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';

class TSizes {
  TSizes({required this.context, required this.deviceType});

  final BuildContext context;
  final TDeviceType deviceType;

  static const dialogMaxWidth = 480.0;

  MediaQueryData get _media => MediaQuery.of(context);
  RenderBox? get _renderBox => context.findRenderObject() as RenderBox?;

  double get width => _media.size.width;
  double get height => _media.size.height;
  double get keyboardInsets => _media.viewInsets.bottom;

  bool get hasKeyboard => _media.viewInsets.bottom > 0;

  double get topSafeArea => _media.viewPadding.top;
  double get bottomSafeArea => _media.viewPadding.bottom;
  double get bottomSafeAreaWithMinimum =>
      hasKeyboard ? 16 : max(bottomSafeArea, 16);
  double get bottomViewInsets => _media.viewInsets.bottom;

  double get appBarSafeHeight => kToolbarHeight + topSafeArea;

  Offset get globalTopLeftPosition {
    final rb = _renderBox;
    return rb == null
        ? Offset.zero
        : rb.localToGlobal(rb.size.topLeft(Offset.zero));
  }

  Offset get globalTopRightPosition {
    final rb = _renderBox;
    return rb == null
        ? Offset.zero
        : rb.localToGlobal(rb.size.topRight(Offset.zero));
  }

  Offset get globalBottomLeftPosition {
    final rb = _renderBox;
    return rb == null
        ? Offset.zero
        : rb.localToGlobal(rb.size.bottomLeft(Offset.zero));
  }

  Offset get globalBottomRightPosition {
    final rb = _renderBox;
    return rb == null
        ? Offset.zero
        : rb.localToGlobal(rb.size.bottomRight(Offset.zero));
  }

  Offset get globalCenterPosition {
    final rb = _renderBox;
    return rb == null
        ? Offset.zero
        : rb.localToGlobal(rb.size.center(Offset.zero));
  }

  double get globalTopInPositioned => globalTopLeftPosition.dy;
  double get globalBottomInPositioned => height - globalBottomLeftPosition.dy;
  double get globalLeftInPositioned => globalTopLeftPosition.dx;
  double get globalRightInPositioned => width - globalTopRightPosition.dx;

  double get sideNavBarWidth {
    switch (deviceType) {
      case TDeviceType.mobile:
        return width * 0.8;
      case TDeviceType.tablet:
        return width * 0.6;
      case TDeviceType.desktop:
        return 400;
    }
  }
}
