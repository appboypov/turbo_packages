import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class StylingViewModel extends TViewModel<Object?> {
  StylingViewModel() {
    _initializePlaygroundParameters();
  }

  final TNotifier<bool> _isPlaygroundExpanded = TNotifier(true);
  final TNotifier<bool> _isContextualButtonsShowcaseExpanded = TNotifier(true);
  final TNotifier<TurboWidgetsScreenTypes> _screenType = TNotifier(TurboWidgetsScreenTypes.mobile);
  final TNotifier<bool> _isGeneratorOpen = TNotifier(true);
  final TNotifier<String> _userRequest = TNotifier('');
  final TNotifier<String> _variations = TNotifier('1');
  final TNotifier<String> _activeTab = TNotifier('request');
  final TNotifier<String> _instructions = TNotifier(TurboWidgetsDefaults.instructions);
  final TNotifier<TurboWidgetsPreviewMode> _previewMode = TNotifier(TurboWidgetsPreviewMode.none);
  final TNotifier<DeviceInfo?> _selectedDevice = TNotifier(null);
  final TNotifier<double> _previewScale = TNotifier(1.0);
  final TNotifier<bool> _isDarkMode = TNotifier(false);
  final TNotifier<bool> _isSafeAreaEnabled = TNotifier(false);

  /// The component parameters model.
  /// Agents update this with default values when creating components.
  /// Form fields are auto-generated from this model's type-specific maps.
  final TNotifier<TPlaygroundParameterModel> _componentParameters = TNotifier(
    const TPlaygroundParameterModel.empty(),
  );

  void _initializePlaygroundParameters() {
    _componentParameters.update(const TPlaygroundParameterModel.empty());
  }

  TNotifier<bool> get isPlaygroundExpanded => _isPlaygroundExpanded;
  TNotifier<bool> get isContextualButtonsShowcaseExpanded =>
      _isContextualButtonsShowcaseExpanded;
  TNotifier<TurboWidgetsScreenTypes> get screenType => _screenType;
  TNotifier<bool> get isGeneratorOpen => _isGeneratorOpen;
  TNotifier<String> get userRequest => _userRequest;
  TNotifier<String> get variations => _variations;
  TNotifier<String> get activeTab => _activeTab;
  TNotifier<String> get instructions => _instructions;
  TNotifier<TurboWidgetsPreviewMode> get previewMode => _previewMode;
  TNotifier<DeviceInfo?> get selectedDevice => _selectedDevice;
  TNotifier<double> get previewScale => _previewScale;
  TNotifier<bool> get isDarkMode => _isDarkMode;
  TNotifier<bool> get isSafeAreaEnabled => _isSafeAreaEnabled;
  TNotifier<TPlaygroundParameterModel> get componentParameters => _componentParameters;

  @override
  void dispose() {
    _isPlaygroundExpanded.dispose();
    _isContextualButtonsShowcaseExpanded.dispose();
    _screenType.dispose();
    _isGeneratorOpen.dispose();
    _userRequest.dispose();
    _variations.dispose();
    _activeTab.dispose();
    _instructions.dispose();
    _previewMode.dispose();
    _selectedDevice.dispose();
    _previewScale.dispose();
    _isDarkMode.dispose();
    _isSafeAreaEnabled.dispose();
    _componentParameters.dispose();
    super.dispose();
  }

  void togglePlayground() {
    _isPlaygroundExpanded.updateCurrent((current) => !current);
  }

  void toggleContextualButtonsShowcase() {
    _isContextualButtonsShowcaseExpanded.updateCurrent((current) => !current);
  }

  void setScreenType(TurboWidgetsScreenTypes value) {
    _screenType.update(value);
    _selectedDevice.update(TurboWidgetsDevices.deviceForScreenType(value));
  }

  void toggleGenerator() {
    _isGeneratorOpen.updateCurrent((current) => !current);
  }

  void setUserRequest(String value) {
    _userRequest.update(value);
  }

  void setVariations(String value) {
    _variations.update(value);
  }

  void setActiveTab(String value) {
    _activeTab.update(value);
  }

  void setInstructions(String value) {
    _instructions.update(value);
  }

  void setPreviewMode(TurboWidgetsPreviewMode value) {
    _previewMode.update(value);
    if (value == TurboWidgetsPreviewMode.deviceFrame) {
      if (_selectedDevice.value == null) {
        _selectedDevice.update(TurboWidgetsDevices.deviceForScreenType(_screenType.value));
      }
      if (_previewScale.value > 1.0) {
        _previewScale.update(1.0);
      }
    }
  }

  void setSelectedDevice(DeviceInfo value) {
    _selectedDevice.update(value);
  }

  void setPreviewScale(double value) {
    _previewScale.update(value);
  }

  void toggleDarkMode() {
    _isDarkMode.updateCurrent((current) => !current);
  }

  void toggleSafeArea() {
    _isSafeAreaEnabled.updateCurrent((current) => !current);
  }

  /// Updates the component parameters model.
  /// Use this when form fields change or when setting initial component defaults.
  void setComponentParameters(TPlaygroundParameterModel value) {
    _componentParameters.update(value);
  }

  static StylingViewModel get locate => StylingViewModel();
}
