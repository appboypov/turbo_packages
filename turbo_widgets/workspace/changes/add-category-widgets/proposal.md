# Change: Add category view widgets

## Why
Developers need reusable category view components (header, section, card) in turbo_widgets.

## What Changes
- Add TCategoryHeader, TCategorySection, and TCategoryCard widgets
- Add TCategorySectionLayout enum for layout modes
- Export new API from turbo_widgets

## Impact
- Affected specs: category-widgets
- Affected code: lib/src/enums, lib/src/widgets, lib/turbo_widgets.dart
