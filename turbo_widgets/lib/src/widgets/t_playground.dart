import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

/// A self-contained playground widget for prototyping and testing components.
///
/// All playground state is managed internally. Consumers only need to provide:
/// - [parametersBuilder]: Factory to create initial parameter values
/// - [childBuilder]: Builder that receives the typed parameters
///
/// Example:
/// ```dart
/// TPlayground<TPlaygroundParameterModel>(
///   parametersBuilder: () => TPlaygroundParameterModel(
///     strings: {'title': 'Hello'},
///     bools: {'isEnabled': true},
///   ),
///   childBuilder: (context, params) {
///     return MyWidget(
///       title: params.strings['title'] ?? '',
///       isEnabled: params.bools['isEnabled'] ?? true,
///     );
///   },
/// )
/// ```
class TPlayground<T extends TPlaygroundParameterModel> extends StatefulWidget {
  const TPlayground({
    required this.parametersBuilder,
    required this.childBuilder,
    super.key,
    this.initialScreenType = TurboWidgetsScreenTypes.mobile,
    this.initialIsGeneratorOpen = true,
    this.initialPreviewMode = TurboWidgetsPreviewMode.none,
    this.initialIsDarkMode = false,
    this.initialIsSafeAreaEnabled = false,
    this.initialPreviewScale = 1.0,
    this.initialInstructions = TurboWidgetsDefaults.instructions,
    this.initialUserRequest = '',
    this.initialVariations = '1',
    this.initialActiveTab = TurboWidgetsPlaygroundTab.request,
    this.initialIsParameterPanelExpanded = true,
    this.clearCanvasInstructions = TurboWidgetsDefaults.clearCanvasInstructions,
    this.solidifyInstructions = TurboWidgetsDefaults.solidifyInstructions,
  });

  /// Factory function to create initial parameter values.
  final T Function() parametersBuilder;

  /// Builder function that creates the preview widget using the typed parameters.
  final Widget Function(BuildContext context, T parameters) childBuilder;

  /// Initial screen type selection. Defaults to mobile.
  final TurboWidgetsScreenTypes initialScreenType;

  /// Initial generator panel visibility. Defaults to true (open).
  final bool initialIsGeneratorOpen;

  /// Initial preview mode. Defaults to none.
  final TurboWidgetsPreviewMode initialPreviewMode;

  /// Initial dark mode state. Defaults to false.
  final bool initialIsDarkMode;

  /// Initial safe area state. Defaults to false.
  final bool initialIsSafeAreaEnabled;

  /// Initial preview scale. Defaults to 1.0.
  final double initialPreviewScale;

  /// Initial instructions text. Defaults to TurboWidgetsDefaults.instructions.
  final String initialInstructions;

  /// Initial user request text. Defaults to empty string.
  final String initialUserRequest;

  /// Initial variations count. Defaults to '1'.
  final String initialVariations;

  /// Initial active tab. Defaults to request.
  final TurboWidgetsPlaygroundTab initialActiveTab;

  /// Initial parameter panel expanded state. Defaults to true.
  final bool initialIsParameterPanelExpanded;

  /// Clear canvas instructions text.
  final String clearCanvasInstructions;

  /// Solidify instructions text.
  final String solidifyInstructions;

  @override
  State<TPlayground<T>> createState() => _TPlaygroundState<T>();
}

class _TPlaygroundState<T extends TPlaygroundParameterModel> extends State<TPlayground<T>> {
  late T _parameters;
  late bool _isGeneratorOpen;
  late TurboWidgetsScreenTypes _screenType;
  late TurboWidgetsPreviewMode _previewMode;
  DeviceInfo? _selectedDevice;
  late double _previewScale;
  late bool _isDarkMode;
  late bool _isSafeAreaEnabled;
  late TurboWidgetsPlaygroundTab _activeTab;
  late String _userRequest;
  late String _variations;
  late String _instructions;
  late bool _isParameterPanelExpanded;

  @override
  void initState() {
    super.initState();
    _parameters = widget.parametersBuilder();
    _isGeneratorOpen = widget.initialIsGeneratorOpen;
    _screenType = widget.initialScreenType;
    _previewMode = widget.initialPreviewMode;
    _previewScale = widget.initialPreviewScale;
    _isDarkMode = widget.initialIsDarkMode;
    _isSafeAreaEnabled = widget.initialIsSafeAreaEnabled;
    _activeTab = widget.initialActiveTab;
    _userRequest = widget.initialUserRequest;
    _variations = widget.initialVariations;
    _instructions = widget.initialInstructions;
    _isParameterPanelExpanded = widget.initialIsParameterPanelExpanded;
  }

  void _setParameters(TPlaygroundParameterModel newParams) {
    setState(() {
      _parameters = newParams as T;
    });
  }

  void _setScreenType(TurboWidgetsScreenTypes value) {
    setState(() {
      _screenType = value;
    });
  }

  void _toggleGenerator() {
    setState(() {
      _isGeneratorOpen = !_isGeneratorOpen;
    });
  }

  void _setPreviewMode(TurboWidgetsPreviewMode value) {
    setState(() {
      _previewMode = value;
    });
  }

  void _setSelectedDevice(DeviceInfo value) {
    setState(() {
      _selectedDevice = value;
    });
  }

  void _setPreviewScale(double value) {
    setState(() {
      _previewScale = value;
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _toggleSafeArea() {
    setState(() {
      _isSafeAreaEnabled = !_isSafeAreaEnabled;
    });
  }

  void _setActiveTab(TurboWidgetsPlaygroundTab value) {
    setState(() {
      _activeTab = value;
    });
  }

  void _setUserRequest(String value) {
    setState(() {
      _userRequest = value;
    });
  }

  void _setVariations(String value) {
    setState(() {
      _variations = value;
    });
  }

  void _setInstructions(String value) {
    setState(() {
      _instructions = value;
    });
  }

  String _buildPrompt() {
    switch (_activeTab) {
      case TurboWidgetsPlaygroundTab.solidify:
        return widget.solidifyInstructions;
      case TurboWidgetsPlaygroundTab.clear:
        return widget.clearCanvasInstructions;
      case TurboWidgetsPlaygroundTab.request:
      case TurboWidgetsPlaygroundTab.instructions:
        return _instructions
            .replaceAll('{{USER_REQUEST}}', _userRequest)
            .replaceAll('{{VARIATIONS}}', _variations);
    }
  }

  void _copyPrompt() {
    final prompt = _buildPrompt();
    Clipboard.setData(ClipboardData(text: prompt));
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TVerticalShrink(
          show: _isGeneratorOpen,
          child: TPlaygroundPromptGenerator(
            userRequest: _userRequest,
            onUserRequestChanged: _setUserRequest,
            variations: _variations,
            onVariationsChanged: _setVariations,
            activeTab: _activeTab,
            onActiveTabChanged: _setActiveTab,
            onCopyPrompt: _copyPrompt,
            instructions: _instructions,
            onInstructionsChanged: _setInstructions,
            solidifyInstructions: widget.solidifyInstructions,
            clearCanvasInstructions: widget.clearCanvasInstructions,
          ),
        ),
        if (_parameters.isNotEmpty)
          TVerticalShrink(
            show: _isParameterPanelExpanded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TPlaygroundParameterPanel(
                model: _parameters,
                onModelChanged: _setParameters,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TPlaygroundScreenTypeSelector(
            currentType: _screenType,
            onTypeChange: _setScreenType,
            isGeneratorOpen: _isGeneratorOpen,
            onToggleGenerator: _toggleGenerator,
            previewMode: _previewMode,
            onPreviewModeChange: _setPreviewMode,
            selectedDevice: _selectedDevice,
            onDeviceChange: _setSelectedDevice,
            previewScale: _previewScale,
            onPreviewScaleChange: _setPreviewScale,
            isDarkMode: _isDarkMode,
            onToggleDarkMode: _toggleDarkMode,
            isSafeAreaEnabled: _isSafeAreaEnabled,
            onToggleSafeArea: _toggleSafeArea,
          ),
        ),
        _buildPreviewArea(context, theme),
      ],
    );
  }

  Widget _buildPreviewArea(BuildContext context, ShadThemeData theme) {
    final previewChild = widget.childBuilder(context, _parameters);

    return TPlaygroundComponentWrapper(
      screenType: _screenType,
      previewMode: _previewMode,
      previewScale: _previewScale,
      selectedDevice: _selectedDevice,
      isDarkMode: _isDarkMode,
      isSafeAreaEnabled: _isSafeAreaEnabled,
      child: previewChild,
    );
  }
}
