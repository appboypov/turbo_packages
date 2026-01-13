# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-01-XX

### Changed
- Updated example to use `TurboViewModel` and `TurboViewModelBuilder` (renamed from `BaseViewModel` and `ViewModelBuilder`)

## [1.0.0] - 2025-01-06

### Added
- Enhanced `ValueNotifier` with `TurboNotifier` class
- Force update mode for reference types
- Silent updates without triggering listeners
- `data` getter/setter as alias for `value`/`update()`
- `silentUpdateCurrent` for functional updates without notifications
- Standard value setter support
- `doNotifyListeners` option for batch updates
- All features from previous versions (0.0.1 - 0.0.4)

### Changed
- Package renamed from `informers` to `turbo_listenables` and then to `turbo_notifiers`
- Class renamed from `Informer` to `TurboNotifier`
- Updated import paths to use `package:turbo_notifiers/turbo_notifiers.dart`
- Default `forceUpdate` behavior set to false
- Improved equality checks for `updateCurrent` methods
- Better listener notification handling
- Enhanced example project and documentation

### Removed
- `ListInformer` - use `TurboNotifier<List<T>>` instead
- `MapInformer` - use `TurboNotifier<Map<K, V>>` instead
- `SetInformer` - use `TurboNotifier<Set<T>>` instead
- `MaxLengthListInformer` - use `TurboNotifier<List<T>>` with custom logic instead

### Fixed
- Fixed equality checks in update methods
- Improved current value update methods
