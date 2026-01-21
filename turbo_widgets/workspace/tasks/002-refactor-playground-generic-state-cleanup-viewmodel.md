---
status: done
skill-level: junior
parent-type: change
parent-id: refactor-playground-generic-state
type: chore
blocked-by:
  - 001-refactor-playground-generic-state-refactor-widget
---

# 🧹 Remove playground state from StylingViewModel

Use this template for maintenance tasks, cleanup, and housekeeping work.

**Title Format**: `🧹 <Verb> <thing>`

**Examples**:
- 🧹 Update dependencies to latest versions
- 🧹 Remove unused feature flags

---

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [x] 001-refactor-playground-generic-state-refactor-widget

## 🧹 Maintenance Area
> What part of the system needs attention?

`example/lib/views/styling/styling_view_model.dart` - Remove all playground-related state that is now managed internally by `TPlayground`.

## 📍 Current State
> What needs cleaning, updating, or removing?

The `StylingViewModel` contains the following playground-related state that is now obsolete:

```dart
// State variables to remove:
final TNotifier<bool> _isGeneratorOpen = TNotifier(true);
final TNotifier<TurboWidgetsScreenTypes> _screenType = TNotifier(TurboWidgetsScreenTypes.mobile);
final TNotifier<String> _userRequest = TNotifier('');
final TNotifier<String> _variations = TNotifier('1');
final TNotifier<String> _activeTab = TNotifier('request');
final TNotifier<String> _instructions = TNotifier(TurboWidgetsDefaults.instructions);
final TNotifier<TurboWidgetsPreviewMode> _previewMode = TNotifier(TurboWidgetsPreviewMode.none);
final TNotifier<DeviceInfo?> _selectedDevice = TNotifier(null);
final TNotifier<double> _previewScale = TNotifier(1.0);
final TNotifier<bool> _isDarkMode = TNotifier(false);
final TNotifier<bool> _isSafeAreaEnabled = TNotifier(false);
final TNotifier<TPlaygroundParameterModel> _componentParameters = TNotifier(...);

// Methods to remove:
void _initializePlaygroundParameters()
void setScreenType(TurboWidgetsScreenTypes value)
void toggleGenerator()
void setUserRequest(String value)
void setVariations(String value)
void setActiveTab(String value)
void setInstructions(String value)
void setPreviewMode(TurboWidgetsPreviewMode value)
void setSelectedDevice(DeviceInfo value)
void setPreviewScale(double value)
void toggleDarkMode()
void toggleSafeArea()
void setComponentParameters(TPlaygroundParameterModel value)

// Getters to remove:
TNotifier<bool> get isGeneratorOpen
TNotifier<TurboWidgetsScreenTypes> get screenType
TNotifier<String> get userRequest
TNotifier<String> get variations
TNotifier<String> get activeTab
TNotifier<String> get instructions
TNotifier<TurboWidgetsPreviewMode> get previewMode
TNotifier<DeviceInfo?> get selectedDevice
TNotifier<double> get previewScale
TNotifier<bool> get isDarkMode
TNotifier<bool> get isSafeAreaEnabled
TNotifier<TPlaygroundParameterModel> get componentParameters

// Dispose calls to remove:
_isGeneratorOpen.dispose();
_screenType.dispose();
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
```

## 🎯 Target State
> What should exist after this chore is complete?

`StylingViewModel` should only contain state unrelated to TPlayground:

```dart
class StylingViewModel extends TViewModel<Object?> {
  final TNotifier<bool> _isPlaygroundExpanded = TNotifier(true);
  final TNotifier<bool> _isContextualButtonsShowcaseExpanded = TNotifier(true);
  final TNotifier<bool> _isNavigationShowcaseExpanded = TNotifier(true);
  final TNotifier<bool> _isViewBuilderShowcaseExpanded = TNotifier(true);

  TNotifier<bool> get isPlaygroundExpanded => _isPlaygroundExpanded;
  TNotifier<bool> get isContextualButtonsShowcaseExpanded => _isContextualButtonsShowcaseExpanded;
  TNotifier<bool> get isNavigationShowcaseExpanded => _isNavigationShowcaseExpanded;
  TNotifier<bool> get isViewBuilderShowcaseExpanded => _isViewBuilderShowcaseExpanded;

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
```

## 💡 Justification
> Why is this maintenance needed now?

This state is now managed internally by `TPlayground`. Keeping it in the view model would be dead code that adds confusion and maintenance burden.

## ✅ Completion Criteria
> How do we verify the chore is done?

- [x] All playground-related TNotifier instances removed from StylingViewModel
- [x] All playground-related getters removed
- [x] All playground-related setters/methods removed
- [x] Dispose method updated to only dispose remaining notifiers
- [x] No unused imports remain
- [x] Code compiles without errors
- [x] dart analyze passes with no warnings

## 🚧 Constraints
> Any limitations or things to avoid?

- [x] Keep `_isPlaygroundExpanded` and `togglePlayground()` - these control the collapsible section, not playground internal state
- [ ] Ensure no references to removed state remain in StylingView

## 📝 Notes
> Additional context if needed

This cleanup depends on task 001 completing first, as removing this state before updating TPlayground would break compilation.
