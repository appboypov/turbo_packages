import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/auth/views/auth/auth_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/shell/shell_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/services/contextual_buttons_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/widgets/unfocusable.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_responsive_builder.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_scaffold.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    super.key,
    required this.statefulNavigationShell,
  });

  static const String path = 'welcome-to';

  final StatefulNavigationShell statefulNavigationShell;

  @override
  Widget build(BuildContext context) => TResponsiveBuilder(
    builder: (context, child, constraints, tools, data) => TViewBuilder<ShellViewModel>(
      argumentBuilder: () => statefulNavigationShell,
      contextualButtonsService: ContextualButtonsService.locate,
      builder: (context, model, isInitialised, child) {
        if (!isInitialised) {
          return const TScaffold(
            child: TWidgets.nothing,
            showBackgroundPattern: true,
          );
        }
        return Unfocusable(
          child: Scaffold(
            body: ShadSonner(
              child: ValueListenableBuilder(
                valueListenable: model.hasAuth,
                builder: (context, value, child) =>
                    value ? statefulNavigationShell : const AuthView(),
                child: statefulNavigationShell,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.appPadding * 1.5,
                vertical: TSizes.appPadding * 0.75,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        );
      },
      viewModelBuilder: () => ShellViewModel.locate,
    ),
  );
}
