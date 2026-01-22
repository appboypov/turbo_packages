## ADDED Requirements

### Requirement: TCollectionHeader widget
The system SHALL provide a `TCollectionHeader` widget for collection pages with a title, description, optional background image, theme-aware gradient styling, and configurable radius.

#### Scenario: Header renders core content
- **WHEN** a title and description are provided
- **THEN** the header displays the title and description with theme-aware styles

#### Scenario: Optional background image
- **WHEN** a background image is provided
- **THEN** the header renders the image behind the gradient and text content

### Requirement: TCollectionToolbar widget
The system SHALL provide a `TCollectionToolbar` widget with search input, sort and filter controls, and layout toggle actions.

#### Scenario: Toolbar renders controls
- **WHEN** the toolbar is built with search, sort, filter, and layout callbacks
- **THEN** the toolbar displays the corresponding controls with theme-aware styles

#### Scenario: Toolbar actions are invoked
- **WHEN** a user interacts with search, sort, filter, or layout controls
- **THEN** the corresponding callback is invoked with the selected value

### Requirement: TCollectionCard widget
The system SHALL provide a `TCollectionCard` widget for collection tiles with a title, optional subtitle, metadata, thumbnail, and tap/hover feedback.

#### Scenario: Card renders content
- **WHEN** a title and optional content are provided
- **THEN** the card displays the content with theme-aware styles and overflow handling

#### Scenario: Card interactivity
- **WHEN** a user hovers or taps the card
- **THEN** the card shows feedback and invokes the callback if provided

### Requirement: TCollectionListItem widget
The system SHALL provide a `TCollectionListItem` widget for list layouts with a leading visual, title, subtitle, metadata, and trailing actions.

#### Scenario: List item renders content
- **WHEN** a title and optional content are provided
- **THEN** the list item displays the content with theme-aware styles and overflow handling

#### Scenario: List item actions
- **WHEN** a user taps the list item or trailing action
- **THEN** the corresponding callback is invoked if provided

### Requirement: TCollectionSection widget
The system SHALL provide a `TCollectionSection` widget that renders a section header and a collection body in bento, list, or grid layouts with configurable spacing and sizing.

#### Scenario: Section header layout
- **WHEN** a title and optional caption are provided
- **THEN** the header renders them with optional trailing actions

#### Scenario: Bento layout
- **WHEN** layout is bento
- **THEN** the section renders items using a proportional grid layout

#### Scenario: List layout
- **WHEN** layout is list
- **THEN** the section renders a vertical list of collection list items

#### Scenario: Grid layout
- **WHEN** layout is grid
- **THEN** the section renders a non-scrollable grid using the configured dimensions

### Requirement: TProportionalGrid widget
The system SHALL provide a `TProportionalGrid` widget and supporting types to render proportional bento layouts.

#### Scenario: Proportional grid renders items
- **WHEN** a list of proportional items is provided
- **THEN** the grid positions items to fill the available space proportionally

#### Scenario: Layout animation support
- **WHEN** an animation type is provided
- **THEN** the grid transitions layout changes using the chosen animation
