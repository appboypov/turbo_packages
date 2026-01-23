## ADDED Requirements

### Requirement: TContextualNavButton Vertical Layout
The TContextualNavButton widget SHALL render with a vertical layout (icon above label) instead of horizontal layout.

#### Scenario: Button displays icon above label
- **WHEN** TContextualNavButton renders with icon and label
- **THEN** icon displays above the label in a Column layout

#### Scenario: Button displays icon only when label hidden
- **WHEN** TContextualNavButton renders with showLabel set to false
- **THEN** only the icon displays without label

### Requirement: TViewBuilder Spacing Awareness
TViewBuilder SHALL automatically measure contextual button overlay sizes and provide animated padding to child content via InheritedWidget.

#### Scenario: Content receives padding from overlays
- **WHEN** contextual buttons are active at a position included in spacingPositions
- **THEN** content receives animated padding equal to the overlay size at that position

#### Scenario: Default spacing positions exclude bottom
- **WHEN** TViewBuilder uses default spacingPositions
- **THEN** spacing is applied for left, top, and right positions only (bottom excluded)

#### Scenario: Spacing animation matches button animation
- **WHEN** contextual button overlay size changes
- **THEN** padding animation duration matches the contextual buttons animation duration

#### Scenario: Custom spacing positions
- **WHEN** TViewBuilder is configured with custom spacingPositions
- **THEN** only positions in the set add padding to content

### Requirement: Side Navigation Top Offset
TContextualSideNavigation SHALL position buttons below any active top navigation height to avoid visual overlap.

#### Scenario: Side navigation starts below top navigation
- **WHEN** top contextual navigation is active
- **THEN** side navigation buttons start below the top navigation height

#### Scenario: Side navigation aligns to top when no top navigation
- **WHEN** no top contextual navigation is active
- **THEN** side navigation buttons align to the top of the container

### Requirement: Top Navigation Centering
TContextualAppBar SHALL center navigation buttons horizontally.

#### Scenario: Top navigation buttons centered
- **WHEN** TContextualAppBar renders buttons
- **THEN** buttons are centered horizontally in the container

### Requirement: Bottom Navigation Even Distribution
TContextualBottomNavigation SHALL spread navigation buttons evenly across the available width.

#### Scenario: Bottom navigation buttons spread evenly
- **WHEN** TContextualBottomNavigation renders buttons
- **THEN** buttons are distributed evenly using Expanded widgets

## ADDED Requirements

### Requirement: TCategorySection Proportional Layout
TCategorySection SHALL support a proportional layout option that renders items using TProportionalGrid.

#### Scenario: Proportional layout renders bento-style grid
- **WHEN** TCategorySection layout is set to proportional
- **THEN** items render via TProportionalGrid in treemap/bento style

#### Scenario: Item weights affect proportional sizing
- **WHEN** items have different weight values
- **THEN** TProportionalGrid sizes items proportionally to their weights

## MODIFIED Requirements

### Requirement: Navigation Structure
The turbo_template app SHALL use bottom navigation for Home and Playground tabs, with Styling accessible via top contextual navigation.

#### Scenario: Bottom navigation shows Home and Playground
- **WHEN** user views the app shell
- **THEN** bottom navigation displays Home and Playground tabs

#### Scenario: Styling accessible via top contextual nav
- **WHEN** user taps Styling button in top contextual navigation
- **THEN** app navigates to StylingView as a core route

#### Scenario: Back navigation via contextual buttons
- **WHEN** user is on a nested page
- **THEN** back navigation is provided via top contextual button (not TSliverAppBar)

### Requirement: View Hierarchy Demonstration
Views in turbo_template SHALL demonstrate specific widget categories according to their purpose.

#### Scenario: Home demonstrates category widgets
- **WHEN** user views Home page
- **THEN** TCategorySection displays with horizontal, grid, and proportional layouts

#### Scenario: Category page demonstrates collection widgets
- **WHEN** user navigates from Home to a category
- **THEN** page displays TCollectionHeader, TCollectionToolbar, and TCollectionSection

#### Scenario: Detail page demonstrates detail widgets
- **WHEN** user navigates from Category to a detail
- **THEN** page displays TDetailHeader, TFormSection, TKeyValueField, and TMarkdownSection

#### Scenario: Styling page demonstrates all widgets
- **WHEN** user views Styling page
- **THEN** page showcases ALL turbo_widgets components organized by category

#### Scenario: Playground accessible as bottom tab
- **WHEN** user taps Playground in bottom navigation
- **THEN** PlaygroundView renders with TPlayground widget

## REMOVED Requirements

### Requirement: TSliverAppBar Usage in Views
Views SHALL NOT use TSliverAppBar for navigation.

**Reason**: All navigation is handled via contextual buttons for consistency and flexibility.

**Migration**: Replace TSliverAppBar with contextual button registration for back navigation and titles.

#### Scenario: No TSliverAppBar in any view
- **WHEN** any view renders
- **THEN** no TSliverAppBar widget is present in the widget tree
