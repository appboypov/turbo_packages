import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_preview_mode.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_screen_types.dart';
import 'package:turbo_widgets/src/models/playground/t_playground_parameters.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_component_wrapper.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_parameter_panel.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_prompt_generator.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_screen_type_selector.dart';
import 'package:turbo_widgets/src/widgets/t_shrink.dart';

/// Builder function that creates a widget using the current parameter values.
typedef TPlaygroundChildBuilder = Widget Function(
  BuildContext context,
  TPlaygroundParameters parameters,
);

class TPlayground extends StatelessWidget {
  const TPlayground({
    required this.screenType,
    required this.onScreenTypeChanged,
    required this.isGeneratorOpen,
    required this.onToggleGenerator,
    required this.userRequest,
    required this.onUserRequestChanged,
    required this.variations,
    required this.onVariationsChanged,
    required this.activeTab,
    required this.onActiveTabChanged,
    required this.onCopyPrompt,
    required this.previewMode,
    required this.onPreviewModeChanged,
    required this.onDeviceChanged,
    required this.previewScale,
    required this.onPreviewScaleChanged,
    super.key,
    this.child,
    this.childBuilder,
    this.parameters,
    this.instructions,
    this.onInstructionsChanged,
    this.selectedDevice,
    this.isParameterPanelExpanded = true,
    this.onToggleParameterPanel,
  }) : assert(
          childBuilder == null || parameters != null,
          'childBuilder requires parameters to be provided',
        );

  final TurboWidgetsScreenTypes screenType;
  final ValueChanged<TurboWidgetsScreenTypes> onScreenTypeChanged;
  final bool isGeneratorOpen;
  final VoidCallback onToggleGenerator;
  final String userRequest;
  final ValueChanged<String> onUserRequestChanged;
  final String variations;
  final ValueChanged<String> onVariationsChanged;
  final String activeTab;
  final ValueChanged<String> onActiveTabChanged;
  final VoidCallback onCopyPrompt;
  final TurboWidgetsPreviewMode previewMode;
  final ValueChanged<TurboWidgetsPreviewMode> onPreviewModeChanged;
  final DeviceInfo? selectedDevice;
  final ValueChanged<DeviceInfo> onDeviceChanged;
  final double previewScale;
  final ValueChanged<double> onPreviewScaleChanged;
  final Widget? child;
  final TPlaygroundChildBuilder? childBuilder;
  final TPlaygroundParameters? parameters;
  final String? instructions;
  final ValueChanged<String>? onInstructionsChanged;
  final bool isParameterPanelExpanded;
  final VoidCallback? onToggleParameterPanel;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TPlaygroundScreenTypeSelector(
              currentType: screenType,
              onTypeChange: onScreenTypeChanged,
              isGeneratorOpen: isGeneratorOpen,
              onToggleGenerator: onToggleGenerator,
              previewMode: previewMode,
              onPreviewModeChange: onPreviewModeChanged,
              selectedDevice: selectedDevice,
              onDeviceChange: onDeviceChanged,
              previewScale: previewScale,
              onPreviewScaleChange: onPreviewScaleChanged,
            ),
          ),
          TVerticalShrink(
            show: isGeneratorOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TPlaygroundPromptGenerator(
                userRequest: userRequest,
                onUserRequestChanged: onUserRequestChanged,
                variations: variations,
                onVariationsChanged: onVariationsChanged,
                activeTab: activeTab,
                onActiveTabChanged: onActiveTabChanged,
                onCopyPrompt: onCopyPrompt,
                instructions: instructions,
                onInstructionsChanged: onInstructionsChanged,
              ),
            ),
          ),
          if (parameters != null && parameters!.isNotEmpty)
            TVerticalShrink(
              show: isParameterPanelExpanded,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TPlaygroundParameterPanel(parameters: parameters!),
              ),
            ),
          TPlaygroundComponentWrapper(
            screenType: screenType,
            previewMode: previewMode,
            previewScale: previewScale,
            selectedDevice: selectedDevice,
            child: _buildPreviewContent(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context, ShadThemeData theme) {
    if (childBuilder != null && parameters != null) {
      return childBuilder!(context, parameters!);
    }

    if (child != null) {
      return child!;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Text(
            'Component Testing Area',
            style: theme.textTheme.large.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Use the prompt generator above to create new widgets, '
            'or add widgets here to test them.',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
