import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/views/auth/auth_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/constants/routes.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/view_type.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/home_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/shell/shell_view_model.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/k_widgets.dart';
import 'package:veto/veto.dart';

class ShellView extends StatelessWidget {
  const ShellView({super.key});

  static const String path = Routes.shell;

  @override
  Widget build(BuildContext context) => ViewModelBuilder<ShellViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) return kWidgetsNothing;

      return ValueListenableBuilder<ViewType>(
        valueListenable: model.viewType,
        builder: (context, viewType, child) {
          switch (viewType) {
            case ViewType.auth:
              return const AuthView();
            case ViewType.home:
              return const HomeView();
          }
        },
      );
    },
    viewModelBuilder: () => ShellViewModel.locate,
  );
}
