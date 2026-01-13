import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loglytics/loglytics.dart';

class OverlayService with Loglytics {
  static OverlayService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(OverlayService.new);

  void showRandomConfetti({required BuildContext? context}) {
    log.debug('showRandomConfetti called');
  }

  void showConfetti({
    required BuildContext? context,
    double size = 80,
    double leftOffset = 0,
    double topOffset = 0,
    double? bottomOffset,
  }) {
    log.debug('showConfetti called');
  }
}

