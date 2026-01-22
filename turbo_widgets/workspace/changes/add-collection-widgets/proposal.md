# Change: Add collection view widgets

## Why
Developers need reusable collection view components (header, toolbar, section, card, list item) that support multiple layout modes, including a proportional bento layout.

## What Changes
- Add collection widgets: TCollectionHeader, TCollectionToolbar, TCollectionSection, TCollectionCard, TCollectionListItem
- Add TCollectionSectionLayout enum for bento/list/grid layouts
- Port TProportionalGrid (and supporting types) into turbo_widgets for bento layout
- Export new API from turbo_widgets

## Impact
- Affected specs: collection-widgets
- Affected code: lib/src/enums, lib/src/models, lib/src/utils, lib/src/widgets, lib/turbo_widgets.dart
