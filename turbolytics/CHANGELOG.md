# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-01-XX

### Changed
- **BREAKING**: Renamed `Loglytics<D>` mixin → `Turbolytics<D>` for consistency with package naming
- **BREAKING**: Renamed `_Loglytics<X>` class → `_Turbolytics<X>` for consistency with package naming
- Renamed folder `lib/src/loglytics/` → `lib/src/turbolytics/`
- Updated all documentation, examples, and references to use new class names

### Migration Guide
To migrate from v1.0.0 to v1.1.0:
- Replace `with Loglytics` with `with Turbolytics` in all mixin declarations
- Replace `Loglytics.setUp()` with `Turbolytics.setUp()` in setup code
- Replace `Loglytics.create()` with `Turbolytics.create()` in factory usage
- Update variable names from `loglytics` to `turbolytics` if used

## [1.0.0] - 2025-01-06

### Added
- Complete logging, analytics and crash reporting solution
- Integration with Firebase Analytics and Firebase Crashlytics
- Feature-based analytics organization with subjects and parameters
- `Turbolytics` mixin for easy integration
- `Log` class for standalone logging
- `AnalyticsService` for analytics operations
- `EventBus` for chronological event handling
- Support for custom analytics implementations
- Multiple analytics types per class via `analyticsAs<A>()`
- Log level filtering and time logging
- Tag support for debugging
- Crash report type configuration
- Silent updates and force updates
- Analytics to crash reports integration
- Custom analytic objects
- Individual usage support (Log, Loglytics, AnalyticsService objects)
- All features from previous versions (0.1.0 - 0.15.0)

### Changed
- Package renamed from `loglytics` to `turbolytics`
- Updated import paths to use `package:turbolytics/turbolytics.dart`
- Updated dependencies (get_it 8.0.3, flutter_lints 5.0.0)
- Enhanced error handling
- Improved stack trace handling
- Better IntelliSense support
- Refactored API for better clarity
- Comprehensive documentation

### Fixed
- Fixed EventBus stream handling
- Fixed Turbolytics.create return type
- Fixed various logging and crash reporting issues
- Fixed stack trace printing
- Fixed equality checks

### Removed
- Various deprecated APIs from previous versions
- Removed convenience methods and deprecated functionality
