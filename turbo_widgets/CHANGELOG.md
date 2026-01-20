# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-20

### Added
- TContextualButtons widget for contextual overlay buttons with position and variation support
- TContextualButtonsService and TContextualButtonsConfig for flexible button configuration
- TContextualAllowFilter for position filtering (top, bottom, left, right, all)
- TContextualVariation for primary/secondary button variations
- TBottomNavigation, TTopNavigation, TSideNavigation components with TButtonConfig model
- TPlayground device frame preview mode with device selection
- TPlayground dynamic parameter system with TPlaygroundParameterModel
- TCollapsibleSection widget for expandable content sections

### Changed
- TPlayground layout restructured with improved padding and component organization
- Parameter handling streamlined in playground components

### Fixed
- Playground expansion state handling
- Dark mode button text and hover colors

## [1.0.0] - 2025-01-06

### Added
- Common reusable UI widgets, extensions, and animation utilities for Flutter
- Widget library for Flutter applications
- Animation utilities using `flutter_animate`
- Layout utilities using `gap` package
- Reusable components for consistent UI
