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
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
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
                            return const Center(
                              child: Text('Drop a widget here'),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<bool>(
                  valueListenable: model.isContextualButtonsShowcaseExpanded,
                  builder: (context, isExpanded, _) {
                    return TCollapsibleSection(
                      title: 'TContextualButtons',
                      subtitle:
                          'Contextual overlay buttons with position and variation support',
                      isExpanded: isExpanded,
                      onToggle: model.toggleContextualButtonsShowcase,
                      child: Column(
                        children: [
                          _TContextualButtonsShowcase(
                            title: 'Basic - All Positions',
                            config: TContextualButtonsConfig(
                              top: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Top')],
                              ),
                              bottom: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Bottom')],
                              ),
                              left: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Left')],
                              ),
                              right: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Right')],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _TContextualButtonsShowcase(
                            title: 'Position Filter - Bottom Only',
                            config: TContextualButtonsConfig(
                              allowFilter: TContextualAllowFilter.bottom,
                              top: const TContextualButtonsSlotConfig(
                                primary: [
                                  _ShowcaseBar(label: 'Filtered to Bottom')
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _TContextualButtonsShowcase(
                            title: 'Multiple Variations',
                            config: TContextualButtonsConfig(
                              activeVariations: const {
                                TContextualVariation.primary,
                                TContextualVariation.secondary,
                              },
                              bottom: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Primary')],
                                secondary: [_ShowcaseBar(label: 'Secondary')],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        viewModelBuilder: () => StylingViewModel.locate,
      );
}

class _TContextualButtonsShowcase extends StatelessWidget {
  _TContextualButtonsShowcase({
    required this.title,
    required TContextualButtonsConfig config,
  }) : _service = TContextualButtonsService(config);

  final String title;
  final TContextualButtonsService _service;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ShadCard(
            padding: EdgeInsets.zero,
            child: TContextualButtons(
              service: _service,
              child: Center(
                child: Text(
                  'Main Content',
                  style: theme.textTheme.muted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShowcaseBar extends StatelessWidget {
  const _ShowcaseBar({required this.label});

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
