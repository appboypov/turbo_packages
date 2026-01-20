# Request: Add Navigation Components

## Source Input

```text
# ✨ Developer is able to use bottom, top, and side navigation components with configurable buttons

* TBottomNavigation should exist with shadcn shizzles
* TTopNavigation should exist
* TSideNavigation should exist

we want these components to exist for usage inside the TContextualButtons

it should take a map new model TButtonConfig

has: onPressed VoidCallback - iconData IconData? - label String? and a buttonBuilder Function(IconData? icon, String? label, VoidCallback onPressed)?

default to using the right shadbutton if button builder is null

## Dependencies: None

## User Story
As a 👨‍💻 Developer, I want to use pre-built navigation components with contextual button support, so that I can quickly implement consistent navigation patterns across different screen layouts.

## End Goal
Three navigation components (TBottomNavigation, TTopNavigation, TSideNavigation) exist and are ready for use within TContextualButtons, accepting a standardized button configuration model that supports both default shadcn_ui buttons and custom button builders.
```

## Current Understanding

### Target Package
- turbo_widgets (inferred from context and Linear issue metadata)

### Core Requirements
1. Create three navigation components: TBottomNavigation, TTopNavigation, TSideNavigation
2. Create TButtonConfig model with fields: onPressed (VoidCallback), iconData (IconData?), label (String?), buttonBuilder (Function?)
3. Components accept a map of TButtonConfig models
4. Default button rendering uses shadcn_ui buttons
5. Components are stateless and use primitive parameters
6. Components integrate with TContextualButtons

### Stated Constraints
- Must remain stateless
- Must use shadcn_ui as default button system
- Must follow package architecture patterns
- Must support icon-only and label-only scenarios
- Must support light and dark themes
- Must be responsive

## Identified Ambiguities

### 1. Map Key Type
- What type should the map key be for `Map<?, TButtonConfig>`?
- Options: String (route names), int (indices), enum (navigation items), or generic key type?

### 2. TContextualButtons Integration
- How exactly do these navigation components integrate with TContextualButtons?
- Are they meant to be passed as children, or is there a different integration pattern?

### 3. Button Layout and Spacing
- Should the navigation components handle button layout automatically (equal spacing, flex, wrap)?
- Should developers have control over spacing, alignment, and arrangement?

### 4. Active State Management
- Should TButtonConfig support an active/selected state indicator?
- Who manages which button is currently active - the parent or the navigation component?

### 5. Responsive Behavior
- Should TSideNavigation collapse on mobile, or is it desktop-only?
- Should TTopNavigation and TBottomNavigation adapt their button layout based on screen size?

### 6. Button Variant Support
- Should TButtonConfig allow specifying shadcn_ui button variants (primary, secondary, outline, ghost)?
- Should there be a default variant per navigation type?

### 7. Icon-Label Combination
- When both icon and label are provided, what's the default layout (icon above label, icon beside label)?
- Should this be configurable?

### 8. Builder Function Signature
- The buttonBuilder signature is `Function(IconData? icon, String? label, VoidCallback onPressed)?`
- Should it return Widget?
- Should it receive additional context (isActive, theme, etc.)?

## Decisions

_(Will be populated as questions are answered)_

## Final Intent

_(Will be populated when 100% clarity is achieved)_
