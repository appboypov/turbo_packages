import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/mixins/logout_management.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbolytics/turbolytics.dart';

class OopsViewModel extends TViewModel with Turbolytics, LogoutManagement {
  OopsViewModel();

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static OopsViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(() => OopsViewModel());

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> initialise() async {
    super.initialise();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗 HELPERS ------------------------------------------------------------------------------- \\

  bool canPop(BuildContext context) => Navigator.of(context).canPop();

  void goBack(BuildContext context) {
    if (canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}
