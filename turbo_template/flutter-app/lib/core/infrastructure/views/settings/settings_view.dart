import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/settings/settings_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_scaffold.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_sliver_body.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => TViewModelBuilder<SettingsViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) {
        return const SizedBox.shrink();
      }

      return TScaffold(
        child: TSliverBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.settings,
                style: context.texts.h2,
              ),
              const TGap.app(),
              Text(
                'Manage your preferences and application settings.',
                style: context.texts.p,
              ),
            ],
          ),
        ),
      );
    },
    viewModelBuilder: () => SettingsViewModel.locate,
  );
}
