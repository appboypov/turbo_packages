# Changelog

All notable changes to the turbo_packages monorepo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.1.0] - 2026-01-20

### Changed
- turbo_mvvm v1.1.0: Added TurboMvvmDefaults class, breaking renames (BaseViewModel → TurboViewModel, ViewModelBuilder → TurboViewModelBuilder)
- turbo_widgets v1.1.0: Added TViewBuilder, TContextualButtons, navigation components, TPlayground enhancements

## [1.0.0] - 2026-01-13

### Added
- Melos 7.x workspace configuration with pub workspaces
- Root pubspec.yaml with workspace definition for all 7 packages
- Standard Melos scripts: analyze, format, test, build_runner
- Monorepo README.md with package overview and development instructions
- Monorepo spec documentation in workspace/specs/monorepo-structure

### Changed
- All packages now use `resolution: workspace` for dependency management
- Internal dependencies (turbo_response, turbo_serializable) resolved via workspace
- SDK constraints aligned to ^3.6.0 across all packages
- Repository URLs updated to point to monorepo (github.com/appboypov/turbo_packages)
- Dev dependencies aligned (lints ^6.0.0, get_it ^9.2.0)

### Packages
- turbo_response v1.0.1
- turbo_serializable v0.2.0
- turbo_notifiers v1.1.0
- turbo_mvvm v1.1.0
- turbolytics v1.1.0
- turbo_firestore_api v0.8.4
- turbo_promptable v0.0.1
