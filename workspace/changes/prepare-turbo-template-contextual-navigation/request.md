# Request: Prepare Turbo Template with Organized Components and Contextual Navigation System

## Source Input

User requests preparing the turbo_template to:
1. Have all components shown as a configurable app
2. Organize turbo_widgets and turbo_forms for release
3. Demonstrate category, collection, and detail pages with contextual navigation
4. Replace sliver app bars with contextual buttons for all navigation
5. Make views aware of contextual button overlay spacing

## Current Understanding

### Packages Involved
- **turbo_template**: The Flutter app template demonstrating all widgets
- **turbo_widgets**: Reusable widget library containing contextual navigation, category, collection, and detail widgets
- **turbo_forms**: Form configuration library

### Current State (from code exploration)
1. **TViewBuilder**: Wraps TContextualButtons around TViewModelBuilder, but does NOT handle spacing/margins for overlay content
2. **TContextualButtons**: Displays overlays at top/bottom/left/right positions using Stack, but content underneath is NOT aware of overlay sizes
3. **Contextual navigation widgets exist**:
   - TContextualNavButton: Shows icon + inline label (horizontal layout)
   - TContextualSideNavigation: Vertical column layout, aligned to top
   - TContextualBottomNavigation: Horizontal row with Expanded items, evenly spread
   - TContextualAppBar: Not yet read
4. **Current views**:
   - HomeView: Empty placeholder, uses TScaffold/TSliverBody
   - StylingView: Has TSliverAppBar, demonstrates category/collection/detail widgets
   - PlaygroundView: Has TSliverAppBar, contains TPlayground widget
   - ShellView: Uses TViewBuilder with TResponsiveBuilder
5. **TCategorySection**: Supports horizontal and grid layouts (NOT proportional grid yet)
6. **TProportionalGrid**: Exists as separate widget for bento-style layouts

### Identified Components
- Category widgets: TCategoryCard, TCategoryHeader, TCategorySection
- Collection widgets: TCollectionCard, TCollectionHeader, TCollectionListItem, TCollectionSection, TCollectionToolbar
- Detail widgets: TDetailHeader, TFormSection, TKeyValueField, TMarkdownSection
- Navigation widgets: TContextualAppBar, TContextualBottomNavigation, TContextualNavButton, TContextualSideNavigation
- Layout widgets: TProportionalGrid

## Identified Ambiguities

1. **Contextual nav button design**: You want "icon + small label underneath" - does this mean a vertical layout (icon on top, label below) instead of the current horizontal (icon left, label right)?

2. **Spacing awareness mechanism**: How should views become aware of contextual button overlay sizes?
   - Option A: TViewBuilder measures overlay sizes and provides margin/padding via inherited widget
   - Option B: TContextualButtons reports sizes to a service that views can subscribe to
   - Option C: Views manually specify expected overlay positions and receive corresponding padding

3. **Default spacing positions**: You mention "default this set to left, top and right" - does this mean:
   - Bottom navigation should NOT add spacing (content goes behind it)?
   - Or just that left/top/right are the default active positions?

4. **Side navigation top alignment**: "avoiding space taken by any active top contextual buttons" - should side navigation start below the top navigation height, or should they share the same top edge?

5. **Playground as separate page**: Should Playground be:
   - A new bottom navigation tab alongside Home/Styling?
   - Or a separate page accessible from somewhere else?

6. **TCategorySection + TProportionalGrid**: You want TCategorySection to "also support showing things using the proportional grid widget" - should this be:
   - A new layout option (alongside horizontal/grid)?
   - Or a separate widget entirely?

7. **Sliver app bar removal**: Should ALL views lose their sliver app bars, or only specific ones?

8. **Navigation tab structure**: Current tabs are Home and Styling. With Playground becoming a bottom nav page, what's the final tab structure?

## Decisions

1. **Nav button layout**: Vertical stack (icon on top, small label underneath) - NOT the current horizontal layout
2. **Spacing mechanism**: TViewBuilder auto-measures overlay sizes and provides padding via InheritedWidget, with animated padding transitions matching the contextual buttons animation speed
3. **Spacing positions**: Configurable Set<TContextualPosition> determines which positions add spacing. Default is {left, top, right} - bottom excluded means content goes behind bottom nav. User can override to include/exclude any position.
4. **Side nav position**: Side navigation (left/right) starts below top navigation height to avoid overlap/interference
5. **Playground location**: Playground becomes the third bottom navigation tab (Home, Styling, Playground)
6. **Category proportional layout**: Add 'proportional' to TCategorySectionLayout enum - TCategorySection renders TProportionalGrid when this layout is selected
7. **Sliver app bars**: Remove ALL TSliverAppBar usage from views - use contextual buttons exclusively for all navigation (including back buttons)
8. **Page hierarchy and content**:
   - **Home page**: Demonstrates category widgets (TCategoryHeader, TCategorySection with horizontal, grid, proportional layouts)
   - **Category page**: Demonstrates collection widgets (TCollectionHeader, TCollectionToolbar, TCollectionSection) - navigated to from Home
   - **Detail page**: Demonstrates detail widgets (TDetailHeader, TFormSection, TMarkdownSection) - navigated to from Category
9. **Styling page**:
   - Shows ALL available widgets (category, collection, detail, forms, etc.)
   - NOT a bottom navigation tab
   - Accessible via top contextual navigation buttons
   - Core route (not a child of home or shell)
10. **Bottom nav tabs**: Home and Playground only (2 tabs)

## Final Intent

### 1. TContextualNavButton Widget Update
- Change layout from horizontal (icon left, label right) to vertical (icon on top, small label underneath)
- Apply to all contextual navigation widgets that use this button

### 2. TViewBuilder Spacing Awareness
- TViewBuilder auto-measures contextual button overlay sizes
- Provides animated padding via InheritedWidget to child content
- Animation speed matches contextual buttons transition speed
- Configurable Set<TContextualPosition> determines which positions add spacing
- Default set: {left, top, right} - bottom excluded (content goes behind bottom nav)
- User can override to include/exclude any position

### 3. Contextual Navigation Layout Behavior
- **Top**: Buttons centered horizontally
- **Bottom**: Buttons spread evenly (current Expanded behavior)
- **Left/Right**: Buttons aligned to top vertically, stacked under each other, starting BELOW any active top navigation height

### 4. Navigation Structure
- **Bottom nav tabs**: Home, Playground (2 tabs)
- **Top contextual nav**: Styling (accessible from top, core route)
- Remove ALL TSliverAppBar usage - use contextual buttons exclusively

### 5. Page Hierarchy
- **Home** → demonstrates category widgets (horizontal, grid, proportional layouts)
- **Category page** → navigated from Home, demonstrates collection widgets
- **Detail page** → navigated from Category, demonstrates detail widgets
- **Styling** → core route via top nav, shows ALL widget types
- **Playground** → bottom nav tab, component testing sandbox

### 6. TCategorySection Enhancement
- Add 'proportional' to TCategorySectionLayout enum
- When proportional layout selected, render using TProportionalGrid

### 7. Styling Page Cleanup
- Remove playground content from Styling
- Ensure all widget categories are showcased (category, collection, detail, forms)

### 8. Side Quests
- Update existing packages in progress
- Move code around as needed
- Fix analysis errors
- Prepare packages for release (turbo_widgets, turbo_forms)
