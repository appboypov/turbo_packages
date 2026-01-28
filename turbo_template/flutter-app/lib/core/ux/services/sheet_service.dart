import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbolytics/turbolytics.dart';

class SheetService with Turbolytics {
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget shadSheet,
    bool useRootNavigator = false,
  }) async {
    try {
      return showShadSheet<T>(
        context: context,
        backgroundColor: context.colors.background,
        builder: (context) => MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: shadSheet,
        ),
        useRootNavigator: useRootNavigator,
      );
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while showing custom bottom sheet',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static SheetService get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(() => SheetService());
}
