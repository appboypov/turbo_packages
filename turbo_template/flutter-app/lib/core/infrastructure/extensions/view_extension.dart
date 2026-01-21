import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/page_transition_type.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/widgets/transition_builders.dart';

extension ViewExtensionExtension on StatelessWidget {
  Page<dynamic> asPage({
    bool fullscreenDialog = false,
    PageTransitionType transitionType = PageTransitionType.platform,
  }) {
    switch (transitionType) {
      case PageTransitionType.platform:
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            return MaterialPage(
              child: this,
              fullscreenDialog: fullscreenDialog,
              maintainState: true,
            );
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoPage(
              child: this,
              fullscreenDialog: fullscreenDialog,
              maintainState: true,
            );
        }
      case PageTransitionType.custom:
        return CustomTransitionPage(
          child: this,
          barrierColor: null,
          barrierDismissible: true,
          maintainState: true,
          opaque: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          fullscreenDialog: fullscreenDialog,
          transitionDuration: TDurations.animationX0p5,
          reverseTransitionDuration: Duration.zero,
        );
      case PageTransitionType.modal:
        return ModalSheetPage(
          child: this,
          barrierColor: null,
          barrierDismissible: true,
          maintainState: true,
          fullscreenDialog: fullscreenDialog,
          transitionDuration: TDurations.animationX0p5,
        );
    }
  }
}
