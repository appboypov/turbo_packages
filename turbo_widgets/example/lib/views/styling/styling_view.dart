import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/turbo_widgets.dart';
import 'package:turbo_widgets_example/views/styling/styling_view_model.dart';

class StylingView extends StatelessWidget {
  const StylingView({super.key});

  static const String path = 'styling';

  @override
  Widget build(BuildContext context) => TViewModelBuilder<StylingViewModel>(
        builder: (context, model, isInitialised, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ValueListenableBuilder(
              valueListenable: model.screenType,
              builder: (context, screenType, _) {
                return ValueListenableBuilder(
                  valueListenable: model.isGeneratorOpen,
                  builder: (context, isGeneratorOpen, _) {
                    return ValueListenableBuilder(
                      valueListenable: model.userRequest,
                      builder: (context, userRequest, _) {
                        return ValueListenableBuilder(
                          valueListenable: model.variations,
                          builder: (context, variations, _) {
                            return ValueListenableBuilder(
                              valueListenable: model.activeTab,
                              builder: (context, activeTab, _) {
                                return ValueListenableBuilder(
                                  valueListenable: model.instructions,
                                  builder: (context, instructions, _) {
                                    return TPlayground(
                                      screenType: screenType,
                                      onScreenTypeChanged: model.setScreenType,
                                      isGeneratorOpen: isGeneratorOpen,
                                      onToggleGenerator: model.toggleGenerator,
                                      userRequest: userRequest,
                                      onUserRequestChanged: model.setUserRequest,
                                      variations: variations,
                                      onVariationsChanged: model.setVariations,
                                      activeTab: activeTab,
                                      onActiveTabChanged: model.setActiveTab,
                                      onCopyPrompt: () {
                                        ShadToaster.of(context).show(
                                          const ShadToast(
                                            title: Text('Copied!'),
                                            description: Text('Prompt copied to clipboard.'),
                                          ),
                                        );
                                      },
                                      instructions: instructions.isEmpty ? null : instructions,
                                      onInstructionsChanged: model.setInstructions,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
        viewModelBuilder: () => StylingViewModel.locate,
      );
}
