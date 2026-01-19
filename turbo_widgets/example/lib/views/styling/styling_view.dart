import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
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
            child: ValueListenableBuilder<bool>(
              valueListenable: model.isPlaygroundExpanded,
              builder: (context, isPlaygroundExpanded, _) {
                return TCollapsibleSection(
                  title: 'Component Playground',
                  subtitle: 'Create and test widgets with responsive preview',
                  isExpanded: isPlaygroundExpanded,
                  onToggle: model.togglePlayground,
                  child: MultiListenableBuilder(
                    listenables: [
                      model.screenType,
                      model.isGeneratorOpen,
                      model.userRequest,
                      model.variations,
                      model.activeTab,
                      model.instructions,
                      model.previewMode,
                      model.selectedDevice,
                      model.previewScale,
                      model.isDarkMode,
                      model.isSafeAreaEnabled,
                    ],
                    builder: (context, _, __) => TPlayground(
                      screenType: model.screenType.value,
                      onScreenTypeChanged: model.setScreenType,
                      isGeneratorOpen: model.isGeneratorOpen.value,
                      onToggleGenerator: model.toggleGenerator,
                      userRequest: model.userRequest.value,
                      onUserRequestChanged: model.setUserRequest,
                      variations: model.variations.value,
                      onVariationsChanged: model.setVariations,
                      activeTab: model.activeTab.value,
                      onActiveTabChanged: model.setActiveTab,
                      onCopyPrompt: () {
                        ShadToaster.of(context).show(
                          const ShadToast(
                            title: Text('Copied!'),
                            description: Text('Prompt copied to clipboard.'),
                          ),
                        );
                      },
                      instructions: model.instructions.value.isEmpty
                          ? null
                          : model.instructions.value,
                      onInstructionsChanged: model.setInstructions,
                      previewMode: model.previewMode.value,
                      onPreviewModeChanged: model.setPreviewMode,
                      selectedDevice: model.selectedDevice.value,
                      onDeviceChanged: model.setSelectedDevice,
                      previewScale: model.previewScale.value,
                      onPreviewScaleChanged: model.setPreviewScale,
                      isDarkMode: model.isDarkMode.value,
                      onToggleDarkMode: model.toggleDarkMode,
                      isSafeAreaEnabled: model.isSafeAreaEnabled.value,
                      onToggleSafeArea: model.toggleSafeArea,
                      parametersListenable: model.componentParameters,
                      onParametersChanged: model.setComponentParameters,
                    ),
                  ),
                );
              },
            ),
          );
        },
        viewModelBuilder: () => StylingViewModel.locate,
      );
}
