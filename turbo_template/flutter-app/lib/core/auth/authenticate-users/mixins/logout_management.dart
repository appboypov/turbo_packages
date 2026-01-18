import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/auth_service.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_busy.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/dialog_service.dart';
import 'package:turbo_flutter_template/core/ux/provide-feedback/services/toast_service.dart';
import 'package:veto/data/models/base_view_model.dart';

mixin LogoutManagement on BaseViewModel {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  final _dialogService = DialogService.lazyLocate;
  final _authService = AuthService.lazyLocate;
  final _toastService = ToastService.lazyLocate;

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<void> onLogoutPressed({required BuildContext context}) async {
    try {
      final shouldLogout = await _dialogService().showOkCancelDialog(
        title: context.strings.logout,
        message: context.strings.areYouSureYouWantToLogout,
        context: context,
      );

      if (shouldLogout == true) {
        try {
          gSetBusy();
          final response = await _authService().logout(context: context);
          await response.when(
            success: (response) async {
              _toastService().showToast(
                context: context,
                title: context.strings.loggedOut,
                subtitle: context.strings.pleaseComeBackSoon,
              );
            },
            fail: (response) {
              _toastService().showToast(
                context: context,
                title: context.strings.unableToLogYouOut,
                subtitle: context.strings.somethingWentWrongPleaseTryAgainLater,
              );
            },
          );
        } catch (error, stackTrace) {
          Log(
            location: 'LogoutMixin',
          ).error('$error caught while logging out', error: error, stackTrace: stackTrace);
        } finally {
          gSetIdle();
        }
      }
    } catch (error, stackTrace) {
      Log(location: 'LogoutMixin').error(
        'Unexpected ${error.runtimeType} caught while logging out.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
