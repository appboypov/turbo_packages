abstract final class TurboWidgetsDefaults {
  static const Duration animation = Duration(milliseconds: 225);
  static const Duration animationX0p5 = Duration(milliseconds: 113);
  static const Duration animationX1p5 = Duration(milliseconds: 338);
  static const Duration animationX2 = Duration(milliseconds: 450);
  static const Duration animationX3 = Duration(milliseconds: 675);
  static const Duration animationX4 = Duration(milliseconds: 900);

  static const Duration hover = Duration(milliseconds: 100);

  static const Duration sheetAnimation = Duration(milliseconds: 300);
  static const Duration sheetAnimationX0p5 = Duration(milliseconds: 150);

  static const Duration throttle = Duration(milliseconds: 100);
  static const Duration debounce = Duration(milliseconds: 300);

  static const String instructions = '''We are working on a new widget in the Component Playground.

## Role
Flutter Widget Developer

## Expertise
Flutter widget architecture, performance optimization, animations, custom painting, UI/UX best practices

## Mandatory Skills
IMPORTANT: If the `flutter-widgets` skill is available, load it FIRST before doing anything else. This skill contains Widget Design Principles and deep reference knowledge that MUST be applied.

## Workflow
1. **Research**: Read Widget Design Principles from the skill, identify relevant reference files, consult them before implementing
2. **Act**: Apply the knowledge. If new concepts arise (animations, gestures, custom painting), consult the corresponding reference before proceeding
3. **Review**: Verify implementation follows Widget Design Principles and relevant deep knowledge was applied

## Constraints
- Do not deviate from skill guidance without explicit user approval
- Maintain absolute fidelity to the request without making assumptions
- No unrequested features, no "improvements" that weren't asked for
- No workarounds, quick fixes, or dirty hacks

## Context
We are working in the Component Playground, a controlled environment with a screen size selector (Mobile, Tablet, Desktop) and a layout wrapper to test widget responsiveness.

## Structure
1. The TPlayground renders a prompt generator card, optional parameter panel, and a component wrapper area.
2. Inside the component wrapper, there is a placeholder area where widgets under test should be placed.
3. The playground can be integrated into any styling/components page in your project.
4. When parameters are configured, the parameter panel displays form controls for adjusting widget props in real-time.

Theme Support:
- Components MUST work correctly in both light and dark themes
- Use theme-aware colors from ShadTheme that automatically adapt to the theme
- NEVER hardcode colors - always use theme.colorScheme values
- Ensure proper contrast ratios and visibility in both themes

Parameter Configuration (MANDATORY):
- EVERY parameter of EVERY stateless widget MUST be configurable through TPlaygroundParameterModel
- ALWAYS use childBuilder, NEVER use child directly - all widget values must be adjustable in real-time
- Initialize componentParameters in the ViewModel with a TPlaygroundParameterModel containing all widget parameters
- Use the typed maps: strings, ints, doubles, bools, selects (for enums via TSelectOption)
- If a widget has 5 parameters, you MUST have 5 entries across the typed maps - no exceptions

Example parameter setup (note: ALL props are parameters):
```dart
// In ViewModel - initialize componentParameters with TPlaygroundParameterModel
void _initializePlaygroundParameters() {
  _componentParameters.update(
    TPlaygroundParameterModel(
      strings: {
        'title': 'Default Title',
        'subtitle': 'Subtitle text',
      },
      bools: {
        'isEnabled': true,
      },
      doubles: {
        'size': 48.0,
      },
      selects: {
        'variant': TSelectOption<String>(
          value: 'primary',
          options: ['primary', 'secondary', 'destructive'],
        ),
      },
    ),
  );
}

// In TPlayground - ALWAYS use childBuilder, NEVER child
TPlayground(
  parametersListenable: viewModel.componentParameters,
  onParametersChanged: viewModel.setComponentParameters,
  childBuilder: (context, model) => MyWidget(
    title: model.strings['title'] ?? '',
    subtitle: model.strings['subtitle'] ?? '',
    isEnabled: model.bools['isEnabled'] ?? true,
    size: model.doubles['size'] ?? 48.0,
    variant: model.selects['variant']?.value ?? 'primary',
  ),
  // ... other TPlayground props
)
```

Your Goal:
- Create the requested widget(s) in an appropriate location within the project structure.
- ALWAYS add the widget(s) using childBuilder with full parameter configuration - NEVER use child directly.
- EVERY widget prop MUST have a corresponding TPlaygroundParameter so it can be adjusted in real-time.
- If multiple variants are requested, stack them vertically within the wrapper or use multiple sections with titles.
- IMPORTANT: When multiple variants are requested, they MUST share the exact same props interface but have completely different visual designs/layouts. We are brainstorming distinct design approaches, not minor style tweaks.
- CRITICAL: Create ALL variants of the widget (if variants are requested, create all of them, not just one)
- CRITICAL: Test the widget(s) in BOTH light and dark themes to ensure proper appearance and contrast
- Ensure the widget is stateless and follows the design system.
- Use theme-aware design tokens from ShadTheme (colors, typography, spacing, etc.)
- After creating and testing in the playground, add the widget to the appropriate showcase section in your components/styling page. Create a new section if one doesn't exist for this widget type.

<components_rules_and_knowledge>
    - Stateless unless used for temporary user input or animation states
    - Added to project's Components View/Page before actual implementation
    - Receives state from parent view models/hooks linked to views/pages or from global application state management solutions like services
    - Use primitive parameters as parameters to promote general reusability
    - Research and use existing project's UI framework and existing custom widgets before creating new ones to avoid duplication
    - Integrate existing widgets as part of new ones if logical to do so
    - Understand a project's UI framework, theme and design token locations for colors, typography, spacings, sizes, etc and use them accordingly
    - Aim for compact and clean designs as seen in frameworks such a ShadCN and Radix UI
    - NEVER creates build methods that use "any" patterns (dynamic types, Object types, or any type parameters)
    - ALWAYS creates stateless sub stateless widgets instead of using build methods with any patterns
    - Break down complex widgets into smaller, reusable stateless widgets
    - Handles overflows of text and other content gracefully
    - Deliberately uses padding/margin and alignments of elements to ensure proper spacing and layout
    - Follows accessibility best practices such as proper contrast ratios, font sizes, and semantic structure
    - Max lines, overflow types, clipping and properties alike are well thought through to avoid UI breakages
</components_rules_and_knowledge>

Task:
Create the following widget in the Playground:
{{USER_REQUEST}}

Requirements:
- Create {{VARIATIONS}} variant(s) of this widget.
- Ensure it follows the rules above.
- MANDATORY: Configure TPlaygroundParameterModel with entries in the typed maps (strings, bools, ints, doubles, selects) for EVERY widget prop.
- MANDATORY: Use childBuilder to render the widget - NEVER use child directly.
- Add the widget(s) to the TPlayground's childBuilder, replacing the placeholder content.
''';

  static const String solidifyInstructions = '''Solidify the widget from the Component Playground.

Context:
We are working in the Component Playground.
A widget has been created and tested in the playground and is ready to be added to the project.

Theme Support:
- Widgets MUST work correctly in both light and dark themes
- Use theme-aware colors and design tokens from ShadTheme
- NEVER hardcode colors - always use theme.colorScheme values

Your Goal:
1. Move the widget from the playground to its proper location:
   - Determine the appropriate category based on what the widget does
   - Place in the appropriate folder following your project structure
   - Follow naming conventions (snake_case for files, PascalCase for widget classes)
   - Ensure ALL variants of the widget are included (if multiple variants were created, include all of them)

2. Add the widget to the components/styling page catalog:
   - Import the widget at the top with other widget imports
   - Find the appropriate showcase section or create a new one if it doesn't exist
   - Add showcase entries for ALL variants within the section
   - If multiple variants exist, add a showcase for each variant with descriptive names
   - Ensure demo props showcase the widget properly in both light and dark themes

3. Clear the playground canvas:
   - Remove widgets from the playground's childBuilder or child parameter
   - Restore the placeholder content

4. Follow project conventions:
   - Widgets are stateless and receive state from ViewModels
   - Use primitive parameters (String, int, double, bool) not DTOs
   - Follow existing showcase patterns in your project
   - Ensure proper Dart types and imports
   - Verify theme compatibility: widgets should use ShadTheme colors that adapt to theme
   - Test in both light and dark themes before considering the widget complete

<components_rules_and_knowledge>
- Stateless unless used for temporary user input or animation states
- Added to project's Components View/Page before actual implementation
- Receives state from parent view models/hooks linked to views/pages or from global application state management solutions like services
- Use primitive parameters as parameters to promote general reusability
- Research and use existing project's UI framework and existing custom widgets before creating new ones to avoid duplication
- Integrate existing widgets as part of new ones if logical to do so
- Understand a project's UI framework, theme and design token locations for colors, typography, spacings, sizes, etc and use them accordingly
    - Aim for compact and clean designs as seen in frameworks such a ShadCN and Radix UI
    - NEVER creates build methods that use "any" patterns (dynamic types, Object types, or any type parameters)
    - ALWAYS creates stateless sub stateless widgets instead of using build methods with any patterns
    - Break down complex widgets into smaller, reusable stateless widgets
    - Handles overflows of text and other content gracefully
- Deliberately uses padding/margin and alignments of elements to ensure proper spacing and layout
- Follows accessibility best practices such as proper contrast ratios, font sizes, and semantic structure
- Max lines, overflow types, clipping and properties alike are well thought through to avoid UI breakages
</components_rules_and_knowledge>

ALWAYS apply these widget rules and knowledge when creating or modifying widgets.

Task:
Add the widget from the playground to the project following conventions, add it to your components/styling page catalog, and clear the canvas.''';

  static const String clearCanvasInstructions = '''Clear the Component Playground canvas.

Context:
We are working in the Component Playground.
The playground currently contains widgets that need to be cleared to prepare for new widget creation.

Your Goal:
- Remove all widgets currently passed to the TPlayground's childBuilder or child parameter
- Set childBuilder/child to null or remove them entirely to restore the default placeholder
- The default placeholder shows "Component Testing Area" with a description
- This clears the canvas for starting fresh with a new widget creation

Task:
Clear the playground canvas and restore the placeholder content.''';
}
