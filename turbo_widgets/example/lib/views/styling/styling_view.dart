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
                      instructions: model.instructions.value,
                      isDarkMode: model.isDarkMode.value,
                      isSafeAreaEnabled: model.isSafeAreaEnabled.value,
                      onDeviceChanged: model.setSelectedDevice,
                      onInstructionsChanged: model.setInstructions,
                      onParametersChanged: model.setComponentParameters,
                      onPreviewModeChanged: model.setPreviewMode,
                      onPreviewScaleChanged: model.setPreviewScale,
                      onToggleDarkMode: model.toggleDarkMode,
                      onToggleSafeArea: model.toggleSafeArea,
                      parametersListenable: model.componentParameters,
                      previewMode: model.previewMode.value,
                      previewScale: model.previewScale.value,
                      selectedDevice: model.selectedDevice.value,
                      childBuilder: (context, params) {
                        final allowFilter =
                            params.selects['allowFilter']?.value as TContextualAllowFilter? ??
                                TContextualAllowFilter.all;
                        final showTop = params.bools['showTopContent'] ?? true;
                        final showBottom = params.bools['showBottomContent'] ?? true;
                        final showLeft = params.bools['showLeftContent'] ?? true;
                        final showRight = params.bools['showRightContent'] ?? true;
                        final showPrimary = params.bools['showPrimaryVariation'] ?? true;
                        final showSecondary = params.bools['showSecondaryVariation'] ?? true;
                        final showTertiary = params.bools['showTertiaryVariation'] ?? false;
                        final animationDuration = params.ints['animationDuration'] ?? 300;

                        final activeVariations = <TContextualVariation>{
                          if (showPrimary) TContextualVariation.primary,
                          if (showSecondary) TContextualVariation.secondary,
                          if (showTertiary) TContextualVariation.tertiary,
                        };

                        model.updateContextualButtonsConfig(
                          TContextualButtonsConfig(
                            allowFilter: allowFilter,
                            activeVariations: activeVariations,
                            animationDuration: Duration(milliseconds: animationDuration),
                            top: TContextualButtonsSlotConfig(
                              primary: showTop
                                  ? const [_DemoContentBar(label: 'Top Primary')]
                                  : const [],
                              secondary: showTop
                                  ? const [_DemoContentBar(label: 'Top Secondary')]
                                  : const [],
                              tertiary: showTop
                                  ? const [_DemoContentBar(label: 'Top Tertiary')]
                                  : const [],
                            ),
                            bottom: TContextualButtonsSlotConfig(
                              primary: showBottom
                                  ? const [_DemoContentBar(label: 'Bottom Primary')]
                                  : const [],
                              secondary: showBottom
                                  ? const [_DemoContentBar(label: 'Bottom Secondary')]
                                  : const [],
                              tertiary: showBottom
                                  ? const [_DemoContentBar(label: 'Bottom Tertiary')]
                                  : const [],
                            ),
                            left: TContextualButtonsSlotConfig(
                              primary: showLeft
                                  ? const [_DemoContentBar(label: 'Left Primary')]
                                  : const [],
                              secondary: showLeft
                                  ? const [_DemoContentBar(label: 'Left Secondary')]
                                  : const [],
                              tertiary: showLeft
                                  ? const [_DemoContentBar(label: 'Left Tertiary')]
                                  : const [],
                            ),
                            right: TContextualButtonsSlotConfig(
                              primary: showRight
                                  ? const [_DemoContentBar(label: 'Right Primary')]
                                  : const [],
                              secondary: showRight
                                  ? const [_DemoContentBar(label: 'Right Secondary')]
                                  : const [],
                              tertiary: showRight
                                  ? const [_DemoContentBar(label: 'Right Tertiary')]
                                  : const [],
                            ),
                          ),
                        );

                        return TContextualButtons(
                          child: const Center(
                            child: Text('Main Content Area'),
                          ),
                        );
                      },
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

class _DemoContentBar extends StatelessWidget {
  const _DemoContentBar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Text(
        label,
        style: theme.textTheme.small.copyWith(
          color: theme.colorScheme.secondaryForeground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
