import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:loglytics/loglytics.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/services/overlay_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/vibrate_service.dart';

class ShakeGestureService with Loglytics {
  ShakeGestureService({
    required LazyLocatorDef<VibrateService> vibrateService,
    required LazyLocatorDef<OverlayService> overlayService,
  }) : _vibrateService = vibrateService,
       _overlayService = overlayService;

  static ShakeGestureService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(
    () => ShakeGestureService(
      vibrateService: () => VibrateService.locate,
      overlayService: () => OverlayService.locate,
    ),
  );

  final LazyLocatorDef<VibrateService> _vibrateService;
  final LazyLocatorDef<OverlayService> _overlayService;

  void dispose() {
    _cooldownTimer?.cancel();
  }

  Timer? _cooldownTimer;
  bool _isOnCooldown = false;

  void onShakeDetected({required BuildContext context}) {
    log.debug('Shake detected');
    if (_isOnCooldown) return;

    try {
      _isOnCooldown = true;
      _vibrateService().vibrate(HapticsType.heavy);
      _overlayService().showRandomConfetti(context: context);

      _cooldownTimer?.cancel();
      _cooldownTimer = Timer(const Duration(seconds: 2), () {
        _isOnCooldown = false;
      });
    } catch (error, stackTrace) {
      log.error('Error during shake detection', error: error, stackTrace: stackTrace);
      _isOnCooldown = false;
    }
  }
}
