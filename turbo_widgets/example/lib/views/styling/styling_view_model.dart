import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class StylingViewModel extends TViewModel<Object?> {
  StylingViewModel();

  final TNotifier<TurboWidgetsScreenTypes> _screenType = TNotifier(TurboWidgetsScreenTypes.desktop);
  final TNotifier<bool> _isGeneratorOpen = TNotifier(true);
  final TNotifier<String> _userRequest = TNotifier('');
  final TNotifier<String> _variations = TNotifier('1');
  final TNotifier<String> _activeTab = TNotifier('request');
  final TNotifier<String> _instructions = TNotifier('');

  TNotifier<TurboWidgetsScreenTypes> get screenType => _screenType;
  TNotifier<bool> get isGeneratorOpen => _isGeneratorOpen;
  TNotifier<String> get userRequest => _userRequest;
  TNotifier<String> get variations => _variations;
  TNotifier<String> get activeTab => _activeTab;
  TNotifier<String> get instructions => _instructions;

  @override
  void dispose() {
    _screenType.dispose();
    _isGeneratorOpen.dispose();
    _userRequest.dispose();
    _variations.dispose();
    _activeTab.dispose();
    _instructions.dispose();
    super.dispose();
  }

  void setScreenType(TurboWidgetsScreenTypes value) {
    _screenType.update(value);
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

  static StylingViewModel get locate => StylingViewModel();
}
