import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/auth/views/auth/auth_view.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/shell/shell_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/services/contextual_buttons_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/widgets/unfocusable.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_scaffold.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    super.key,
    required this.statefulNavigationShell,
    this.contextualPositionOverrides = const {},
  });

  final StatefulNavigationShell statefulNavigationShell;
  final Map<TContextualPosition, TContextualPosition> contextualPositionOverrides;

  @override
  Widget build(BuildContext context) => TResponsiveBuilder(
    builder: (context, child, constraints, tools, data) {
      final contextualButtonsService = ContextualButtonsService.locate; // #FEEDBACK #TODO | 25 Jan 2026 | never use direct located - retrieve from view model instead
      contextualButtonsService.setPresentation( // #FEEDBACK #TODO | 25 Jan 2026 | do not run business logic inside build methods - anti pattern
        deviceType: data.deviceType,
        positionOverrides: {
          ...contextualPositionOverrides,
        },
      );

      return TViewBuilder<ShellViewModel>(
        argumentBuilder: () => statefulNavigationShell,
        contextualButtonsService: contextualButtonsService,
        builder: (context, model, isInitialised, child) {
          if (!isInitialised) {
            return const TScaffold(
              child: TWidgets.nothing,
              showBackgroundPattern: true,
            );
          }
          return Unfocusable(
            child: ValueListenableBuilder(
              valueListenable: model.hasAuth,
              builder: (context, value, child) => Scaffold(
                key: ValueKey(value),
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
            ),
          );
        },
        viewModelBuilder: () => ShellViewModel.locate,
      );
    },
  );
}
