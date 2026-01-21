import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';

class StylingViewModel extends TBaseViewModel<Object?> {
  final TNotifier<bool> _isPlaygroundExpanded = TNotifier(true);
  final TNotifier<bool> _isContextualButtonsShowcaseExpanded = TNotifier(true);
  final TNotifier<bool> _isNavigationShowcaseExpanded = TNotifier(true);
  final TNotifier<bool> _isViewBuilderShowcaseExpanded = TNotifier(true);

  TNotifier<bool> get isPlaygroundExpanded => _isPlaygroundExpanded;
  TNotifier<bool> get isContextualButtonsShowcaseExpanded =>
      _isContextualButtonsShowcaseExpanded;
  TNotifier<bool> get isNavigationShowcaseExpanded =>
      _isNavigationShowcaseExpanded;
  TNotifier<bool> get isViewBuilderShowcaseExpanded =>
      _isViewBuilderShowcaseExpanded;

  @override
  void dispose() {
    _isPlaygroundExpanded.dispose();
    _isContextualButtonsShowcaseExpanded.dispose();
    _isNavigationShowcaseExpanded.dispose();
    _isViewBuilderShowcaseExpanded.dispose();
    super.dispose();
  }

  void togglePlayground() {
    _isPlaygroundExpanded.updateCurrent((current) => !current);
  }

  void toggleContextualButtonsShowcase() {
    _isContextualButtonsShowcaseExpanded.updateCurrent((current) => !current);
  }

  void toggleNavigationShowcase() {
    _isNavigationShowcaseExpanded.updateCurrent((current) => !current);
  }

  void toggleViewBuilderShowcase() {
    _isViewBuilderShowcaseExpanded.updateCurrent((current) => !current);
  }

  static StylingViewModel get locate => StylingViewModel();
}
