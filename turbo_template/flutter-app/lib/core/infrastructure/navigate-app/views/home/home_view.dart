import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/auth/widgets/logout_button.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/home/home_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_empty_placeholder.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_scaffold.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_sliver_app_bar.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_sliver_body.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String path = 'household';

  @override
  Widget build(BuildContext context) => TViewModelBuilder<HomeViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) return TWidgets.nothing;

      return ValueListenableBuilder<bool>(
        valueListenable: model.showInboxBadge,
        builder: (context, hasUnreadChangelog, _) => TScaffold(
          child: TSliverBody(
            emptyPlaceholder: (context) => Center(
              child: TEmptyPlaceholder(
                title: context.strings.welcome,
              ),
            ),
            isEmpty: true,
            appBar: TSliverAppBar(
              title: context.strings.home,
              emoji: Emoji.house,
              actions: [
                LogoutButton(onPressed: model.onLogoutPressed),
              ],
              onBackPressed: null,
            ),
          ),
        ),
      );
    },
    viewModelBuilder: () => HomeViewModel.locate,
  );
}
