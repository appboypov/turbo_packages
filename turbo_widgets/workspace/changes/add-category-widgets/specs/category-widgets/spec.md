# Category Widgets Capability

## ADDED Requirements

### Requirement: TCategoryHeader widget
The system SHALL provide a `TCategoryHeader` widget for category pages with a title, description, optional background image, theme-aware gradient styling, and configurable radius.

#### Scenario: Header renders core content
- **WHEN** a title and description are provided
- **THEN** the header displays the title and description with theme-aware styles

#### Scenario: Optional background image
- **WHEN** a background image is provided
- **THEN** the header renders the image behind the gradient and text content

### Requirement: TCategoryCard widget
The system SHALL provide a `TCategoryCard` widget for category tiles with a title, optional icon and background image, theme-aware gradient styling, configurable radius, and tap/hover feedback.

#### Scenario: Card renders title and icon
- **WHEN** a title and optional icon are provided
- **THEN** the card displays the title and icon with theme-aware styles

#### Scenario: Card interactivity
- **WHEN** a user hovers or taps the card
- **THEN** the card shows hover or tap feedback and invokes the callback if provided

### Requirement: TCategorySection widget
The system SHALL provide a `TCategorySection` widget that renders a section header with title/caption and trailing actions, then renders category items via a builder in either horizontal or grid layouts with configurable limits and show-all behavior.

#### Scenario: Section header layout
- **WHEN** a title and optional caption are provided
- **THEN** the header renders them in a column with trailing actions adjacent to the column

#### Scenario: Horizontal layout with row limit
- **WHEN** layout is horizontal and maxLines is provided
- **THEN** the section arranges items in columns with at most maxLines items per column and scrolls horizontally

#### Scenario: Grid layout
- **WHEN** layout is grid
- **THEN** the section renders a non-horizontal-scrolling grid using the configured dimensions

#### Scenario: Show all behavior
- **WHEN** itemCount exceeds maxItems
- **THEN** a show-all action appears in the header and a show-all card appears at the end of the list
- **AND** if onShowAll is provided it is invoked on action
- **AND** if onShowAll is not provided the section expands to show all items
