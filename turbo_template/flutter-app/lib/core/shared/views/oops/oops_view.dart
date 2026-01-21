import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_empty_placeholder.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_scaffold.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

import 'oops_view_model.dart';

class OopsView extends StatelessWidget {
  const OopsView({super.key});

  @override
  Widget build(BuildContext context) {
    return TViewModelBuilder<OopsViewModel>(
      builder: (context, model, isInitialised, child) {
        if (!isInitialised) return TWidgets.nothing;
        return Semantics(
          identifier: 'oops_screen',
          child: TScaffold(
            child: Center(
              child: TEmptyPlaceholder(
                title: context.strings.oopsSomethingWentWrong,
                subtitle: context.strings.weEncounteredAnUnexpectedErrorPleaseTryAgainOrContact,
                iconData: Icons.error_outline_rounded,
                actionLabel: context.strings.logout,
                onActionPressed: () => model.onLogoutPressed(context: context),
                actionSemanticIdentifier: 'retry_button',
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => OopsViewModel.locate,
    );
  }
}
