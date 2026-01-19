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
                  child: ValueListenableBuilderX6<TurboWidgetsScreenTypes, bool, String, String,
                      String, String>(
                    valueListenable: model.screenType,
                    valueListenable2: model.isGeneratorOpen,
                    valueListenable3: model.userRequest,
                    valueListenable4: model.variations,
                    valueListenable5: model.activeTab,
                    valueListenable6: model.instructions,
                    builder: (
                      context,
                      screenType,
                      isGeneratorOpen,
                      userRequest,
                      variations,
                      activeTab,
                      instructions,
                      _,
                    ) =>
                        ValueListenableBuilderX3<TurboWidgetsPreviewMode, DeviceInfo?, double>(
                      valueListenable: model.previewMode,
                      valueListenable2: model.selectedDevice,
                      valueListenable3: model.previewScale,
                      builder: (context, previewMode, selectedDevice, previewScale, _) =>
                          TPlayground(
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
                        previewMode: previewMode,
                        onPreviewModeChanged: model.setPreviewMode,
                        selectedDevice: selectedDevice,
                        onDeviceChanged: model.setSelectedDevice,
                        previewScale: previewScale,
                        onPreviewScaleChanged: model.setPreviewScale,
                      ),
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
