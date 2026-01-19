import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_preview_mode.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_screen_types.dart';
import 'package:turbo_widgets/src/models/playground/t_playground_parameter_model.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_component_wrapper.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_parameter_panel.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_prompt_generator.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_screen_type_selector.dart';
import 'package:turbo_widgets/src/widgets/t_shrink.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

/// Builder function that creates a widget using the current parameter model.
///
/// The [model] contains all parameter values organized by primitive type.
/// Components should extract their values from the model using their parameter keys.
typedef TPlaygroundChildBuilder = Widget Function(
  BuildContext context,
  TPlaygroundParameterModel model,
);

class TPlayground extends StatelessWidget {
  const TPlayground({
    required this.activeTab,
    required this.isDarkMode,
    required this.isGeneratorOpen,
    required this.isSafeAreaEnabled,
    required this.onActiveTabChanged,
    required this.onCopyPrompt,
    required this.onDeviceChanged,
    required this.onPreviewModeChanged,
    required this.onPreviewScaleChanged,
    required this.onScreenTypeChanged,
    required this.onToggleDarkMode,
    required this.onToggleGenerator,
    required this.onToggleSafeArea,
    required this.onUserRequestChanged,
    required this.onVariationsChanged,
    required this.previewMode,
    required this.previewScale,
    required this.screenType,
    required this.userRequest,
    required this.variations,
    super.key,
    this.child,
    this.childBuilder,
    this.clearCanvasInstructions = TurboWidgetsDefaults.clearCanvasInstructions,
    this.instructions = TurboWidgetsDefaults.instructions,
    this.isParameterPanelExpanded = true,
    this.onInstructionsChanged,
    this.onParametersChanged,
    this.onToggleParameterPanel,
    this.parametersListenable,
    this.selectedDevice,
    this.solidifyInstructions = TurboWidgetsDefaults.solidifyInstructions,
  }) : assert(
          childBuilder == null || parametersListenable != null,
          'childBuilder requires parametersListenable to be provided',
        );

  final bool isDarkMode;
  final bool isGeneratorOpen;
  final bool isSafeAreaEnabled;
  final DeviceInfo? selectedDevice;
  final double previewScale;
  final String activeTab;
  final String userRequest;
  final String variations;
  final TurboWidgetsPreviewMode previewMode;
  final TurboWidgetsScreenTypes screenType;
  final ValueChanged<DeviceInfo> onDeviceChanged;
  final ValueChanged<double> onPreviewScaleChanged;
  final ValueChanged<String> onActiveTabChanged;
  final ValueChanged<String> onUserRequestChanged;
  final ValueChanged<String> onVariationsChanged;
  final ValueChanged<TurboWidgetsPreviewMode> onPreviewModeChanged;
  final ValueChanged<TurboWidgetsScreenTypes> onScreenTypeChanged;
  final VoidCallback onCopyPrompt;
  final VoidCallback onToggleDarkMode;
  final VoidCallback onToggleGenerator;
  final VoidCallback onToggleSafeArea;

  /// Static child widget to display in the preview area.
  /// Use this for simple cases where parameters are not needed.
  final Widget? child;

  /// Builder function that receives the current parameter model.
  /// Use this when the preview widget needs to react to parameter changes.
  /// Requires [parametersListenable] to be provided.
  final TPlaygroundChildBuilder? childBuilder;

  /// The parameter model listenable that holds all component parameters.
  /// When provided, the parameter panel is displayed and the preview
  /// is wrapped in a ValueListenableBuilder to react to changes.
  final ValueListenable<TPlaygroundParameterModel>? parametersListenable;

  /// Callback invoked when a parameter value changes.
  /// Use this to update the model in the view model.
  final ValueChanged<TPlaygroundParameterModel>? onParametersChanged;

  final bool isParameterPanelExpanded;
  final String clearCanvasInstructions;
  final String instructions;
  final String solidifyInstructions;
  final ValueChanged<String>? onInstructionsChanged;
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
          TVerticalShrink(
            show: isGeneratorOpen,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                solidifyInstructions: solidifyInstructions,
                clearCanvasInstructions: clearCanvasInstructions,
              ),
            ),
          ),
          if (parametersListenable != null)
            ValueListenableBuilder<TPlaygroundParameterModel>(
              valueListenable: parametersListenable!,
              builder: (context, model, _) {
                if (model.isEmpty) return const SizedBox.shrink();
                return TVerticalShrink(
                  show: isParameterPanelExpanded,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TPlaygroundParameterPanel(
                      model: model,
                      onModelChanged: onParametersChanged,
                    ),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              isDarkMode: isDarkMode,
              onToggleDarkMode: onToggleDarkMode,
              isSafeAreaEnabled: isSafeAreaEnabled,
              onToggleSafeArea: onToggleSafeArea,
            ),
          ),
          _buildPreviewArea(context, theme),
        ],
      ),
    );
  }

  Widget _buildPreviewArea(BuildContext context, ShadThemeData theme) {
    final Widget previewChild;

    if (parametersListenable != null && childBuilder != null) {
      previewChild = ValueListenableBuilder<TPlaygroundParameterModel>(
        valueListenable: parametersListenable!,
        builder: (context, model, _) => childBuilder!(context, model),
      );
    } else {
      previewChild = _buildStaticContent(context, theme);
    }

    return TPlaygroundComponentWrapper(
      screenType: screenType,
      previewMode: previewMode,
      previewScale: previewScale,
      selectedDevice: selectedDevice,
      isDarkMode: isDarkMode,
      isSafeAreaEnabled: isSafeAreaEnabled,
      child: previewChild,
    );
  }

  Widget _buildStaticContent(BuildContext context, ShadThemeData theme) {
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
