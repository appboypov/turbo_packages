import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/playground/playground_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_scaffold.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_sliver_app_bar.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_sliver_body.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class PlaygroundView extends StatelessWidget {
  const PlaygroundView({super.key});

  static const String path = 'playground';

  @override
  Widget build(BuildContext context) => TViewModelBuilder<PlaygroundViewModel>(
        builder: (context, model, isInitialised, child) {
          if (!isInitialised) return TWidgets.nothing;

          return TScaffold(
            child: TSliverBody(
              isEmpty: false,
              appBar: TSliverAppBar(
                title: context.strings.playground,
                emoji: Emoji.testTube,
                onBackPressed: ({required BuildContext context}) =>
                    Navigator.of(context).pop(),
              ),
              children: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: TPlayground<TPlaygroundParameterModel>(
                      parametersBuilder: TPlaygroundParameterModel.new,
                      childBuilder: (context, params) {
                        return const Center(
                          child: Text('Add your widget here'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        viewModelBuilder: () => PlaygroundViewModel.locate,
      );
}
