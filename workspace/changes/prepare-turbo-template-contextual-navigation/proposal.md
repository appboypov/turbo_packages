# 🧾 Prepare Turbo Template with Organized Components and Contextual Navigation System

## Summary

Transform the turbo_template into a production-ready demonstration app with a complete contextual navigation system. This change updates navigation widgets, implements spacing awareness for contextual overlays, reorganizes views to demonstrate all widget categories, and prepares turbo_widgets and turbo_forms for release.

## Scope

### Packages Affected
- **turbo_widgets**: Navigation widgets, TViewBuilder spacing awareness, TCategorySection proportional layout
- **turbo_template/flutter-app**: Views, routing, navigation structure

### Out of Scope
- New widget creation beyond specified updates
- Backend/API changes
- Authentication flow changes

## Problem Statement

1. **Navigation layout**: TContextualNavButton uses horizontal layout (icon left, label right) instead of vertical (icon above label)
2. **No spacing awareness**: Views are unaware of contextual button overlay sizes, causing content to render behind overlays
3. **Scattered demo content**: Components are spread across views without clear category/collection/detail hierarchy
4. **Sliver app bars conflict**: TSliverAppBar doesn't integrate with contextual navigation system
5. **No proportional layout**: TCategorySection lacks TProportionalGrid layout option

## Solution

### 1. TContextualNavButton Vertical Layout
Update widget to render icon above label in a Column instead of Row layout.

### 2. TViewBuilder Spacing Awareness
- Add `spacingPositions` parameter (Set<TContextualPosition>) defaulting to {left, top, right}
- Measure overlay sizes at each position via GlobalKey/SizeChangedLayoutNotifier
- Provide animated padding via InheritedWidget to child content
- Animation speed matches contextual buttons transition speed

### 3. Contextual Navigation Positioning
- **Top**: Buttons centered horizontally
- **Bottom**: Buttons spread evenly (existing Expanded behavior)
- **Left/Right**: Buttons aligned to top vertically, stacked, starting BELOW top navigation height

### 4. Navigation Structure
- **Bottom tabs**: Home, Playground
- **Top contextual nav**: Styling (core route)
- Remove ALL TSliverAppBar usage

### 5. View Hierarchy
- **Home** → Category widget showcase (horizontal, grid, proportional layouts)
- **Category page** → Collection widget showcase (navigated from Home)
- **Detail page** → Detail widget showcase (navigated from Category)
- **Styling** → ALL widget types showcase
- **Playground** → Component testing sandbox (bottom tab)

### 6. TCategorySection Proportional Layout
Add `proportional` to TCategorySectionLayout enum, render via TProportionalGrid when selected.

## Tasks Overview

| ID | Type | Title | Blocked By |
|----|------|-------|------------|
| 001 | components | 🧩 TContextualNavButton vertical layout | - |
| 002 | business-logic | ⚙️ TViewBuilder spacing awareness | 001 |
| 003 | components | 🧩 Contextual navigation positioning | 001 |
| 004 | components | 🧩 TCategorySection proportional layout | - |
| 005 | business-logic | ⚙️ Navigation structure and routing | - |
| 006 | components | 🧩 Home view category showcase | 004, 005 |
| 007 | components | 🧩 Category page collection showcase | 005 |
| 008 | components | 🧩 Detail page widgets showcase | 005 |
| 009 | refactor | 🧱 Remove TSliverAppBar from views | 002, 003 |
| 010 | refactor | 🧱 Styling view cleanup | 005 |
| 011 | components | 🧩 Playground as bottom tab | 005 |
| 012 | chore | 🧹 Fix analysis errors | 001-011 |
| 013 | chore | 🧹 Prepare packages for release | 012 |

## Acceptance Criteria

- [ ] TContextualNavButton displays icon above label vertically
- [ ] Views automatically adjust padding based on active contextual overlays
- [ ] Side navigation starts below top navigation height
- [ ] Bottom navigation spreads items evenly
- [ ] Top navigation centers items
- [ ] Home demonstrates category widgets with all layout types
- [ ] Category page demonstrates collection widgets
- [ ] Detail page demonstrates detail widgets
- [ ] Styling page shows ALL widget types
- [ ] Playground is accessible via bottom navigation
- [ ] No TSliverAppBar usage in any view
- [ ] Zero analysis errors
- [ ] Packages ready for pub.dev release

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Spacing animation performance | Medium | Use RepaintBoundary, limit rebuilds |
| Breaking existing TViewBuilder usage | High | Default spacingPositions maintains backward compatibility |
| Routing changes break navigation | High | Test all navigation flows after changes |

## Design Decisions

### Spacing Position Set Default
Default to `{left, top, right}` excludes bottom navigation, allowing content to flow behind bottom nav for a more immersive experience. Users can override to include bottom if needed.

### Side Navigation Below Top
Side navigation starts below top navigation height to prevent visual overlap and ensure clean separation of navigation areas.

### Proportional Layout in TCategorySection
Adding proportional layout as enum option rather than separate widget maintains API consistency and allows easy switching between layouts.
