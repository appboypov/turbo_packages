import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/animation_durations.dart';

class ToastService with Turbolytics {
  static ToastService Function() get lazyLocate =>
      () => GetIt.I.get();
  static ToastService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(ToastService.new);

  Duration calculateDisplayDuration({required String title, String? subtitle}) {
    final titleLength = title.length;
    final subtitleLength = subtitle?.length ?? 0;
    final totalLength = titleLength + subtitleLength;

    if (totalLength <= 40) {
      return AnimationDurations.toastDefault;
    }

    final extraDuration = Duration(milliseconds: ((totalLength - 40) / 10).ceil() * 150);
    final calculatedDuration = AnimationDurations.toastDefault + extraDuration;

    return calculatedDuration > const Duration(seconds: 6)
        ? const Duration(seconds: 6)
        : calculatedDuration;
  }

  void showToast({
    required String title,
    String? subtitle,
    required BuildContext? context,
    VoidCallback? onPressed,
    String? onPressedText,
    IconData iconData = Icons.info_rounded,
    Duration? displayDuration,
    Duration animationDuration = AnimationDurations.animation,
    Curve animationCurve = Curves.decelerate,
  }) {
    if (context == null) {
      log.warning('ToastService: Context is null, cannot show toast.');
      return;
    }

    final effectiveDisplayDuration =
        displayDuration ?? calculateDisplayDuration(title: title, subtitle: subtitle);

    try {
      showTopSnackBar(
        padding: EdgeInsets.zero,
        curve: animationCurve,
        Overlay.of(context, rootOverlay: true),
        onTap: onPressed,
        animationDuration: animationDuration,
        displayDuration: effectiveDisplayDuration,
        Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(iconData, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white)),
                      if (subtitle != null) Text(subtitle, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Error caught while trying to show snackbar: $error');
      debugPrint('StackTrace: $stackTrace');
    }
  }
}
