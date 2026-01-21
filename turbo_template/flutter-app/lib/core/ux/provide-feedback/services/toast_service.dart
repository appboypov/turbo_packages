import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_snackbar.dart';
import 'package:turbo_flutter_template/l10n/globals/g_context.dart';
import 'package:turbolytics/turbolytics.dart';

class ToastService with Turbolytics {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static ToastService Function() get lazyLocate =>
      () => GetIt.I.get();
  static ToastService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(ToastService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  /// Calculate appropriate display duration based on message length
  /// Ensures messages have enough time to be read comfortably
  Duration calculateDisplayDuration({required String title, String? subtitle}) {
    final titleLength = title.length;
    final subtitleLength = subtitle?.length ?? 0;
    final totalLength = titleLength + subtitleLength;

    // Base duration of 3 seconds for short messages
    if (totalLength <= 40) {
      return TDurations.toastDefault;
    }

    // Add extra time for longer messages (roughly 150ms per 10 characters)
    final extraDuration = Duration(milliseconds: ((totalLength - 40) / 10).ceil() * 150);
    final calculatedDuration = TDurations.toastDefault + extraDuration;

    // Cap at maximum of 6 seconds to avoid overly long displays
    return calculatedDuration > const Duration(seconds: 6)
        ? const Duration(seconds: 6)
        : calculatedDuration;
  }

  Future<void> showSomethingWentWrongToast({required BuildContext context}) async => showToast(
    context: context,
    title: context.strings.somethingWentWrong,
    subtitle: context.strings.somethingWentWrongPleaseTryAgainLater,
  );

  Future<void> showUnknownErrorToast({required BuildContext context}) async => showToast(
    context: context,
    title: context.strings.unknownError,
    subtitle: context.strings.anUnknownErrorOccurredPleaseTryAgainLater,
  );

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void showToast({
    required String title,
    String? subtitle,
    required BuildContext? context,
    VoidCallback? onPressed,
    String? onPressedText,
    IconData iconData = Icons.info_rounded,
    Duration? displayDuration,
    Duration animationDuration = TDurations.animation,
    Curve animationCurve = Curves.decelerate,
  }) {
    final pContext = context ?? gContext;
    if (pContext == null) {
      log.warning('ToastService: Context is null, cannot show toast.');
      return;
    }

    // Use provided duration or calculate based on message length
    final effectiveDisplayDuration =
        displayDuration ?? calculateDisplayDuration(title: title, subtitle: subtitle);

    try {
      showTopSnackBar(
        padding: EdgeInsets.zero,
        curve: animationCurve,
        pContext.overlayState,
        onTap: onPressed,
        animationDuration: animationDuration,
        displayDuration: effectiveDisplayDuration,
        TSnackbar(
          onPressed: onPressed,
          onPressedText: onPressedText,
          iconData: iconData,
          title: title,
          subtitle: subtitle,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Error caught while trying to show snackbar: $error');
      debugPrint('StackTrace: $stackTrace');
    }
  }
}
