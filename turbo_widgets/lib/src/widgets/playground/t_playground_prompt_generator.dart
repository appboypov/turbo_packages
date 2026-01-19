import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

const String _kDefaultInstructions = '''Context:
We are working in the Component Playground, which is integrated into the Styling page (turbo_widgets/example/lib/views/styling/styling_view.dart).
The TPlayground widget (turbo_widgets/lib/src/widgets/t_playground.dart) provides a controlled environment with a screen size selector (Mobile, Tablet, Desktop) and a layout wrapper to test responsiveness.

Structure:
1. The TPlayground uses TViewModel to manage state like screen size and generator visibility.
2. It renders a 'TPlaygroundPromptGenerator' (this card) and a 'TPlaygroundComponentWrapper'.
3. Inside the TPlaygroundComponentWrapper, there is a placeholder area where components under test should be placed.
4. The playground is located at the top of the styling page, before the Design System Tokens section.

Theme Support:
- The project supports two themes: 'light' and 'dark' (default is 'dark')
- Themes are applied via the ShadApp theme configuration
- Components MUST work correctly in both light and dark themes
- Use theme-aware colors from ShadTheme that automatically adapt to the theme
- Test components in both themes using the theme toggle in the app bar
- Ensure proper contrast ratios and visibility in both themes

Your Goal:
- Create the requested widget(s) in an appropriate location within the project structure (typically in a domain area's core/widgets folder, or shared/core/widgets if it's truly shared).
- Add the widget(s) inside the TPlaygroundComponentWrapper's children area in t_playground.dart, replacing the placeholder content.
- If multiple variants are requested, stack them vertically within the wrapper or use multiple sections with titles.
- IMPORTANT: When multiple variants are requested, they MUST share the exact same props interface but have completely different visual designs/layouts. We are brainstorming distinct design approaches, not minor style tweaks.
- CRITICAL: Create ALL variants of the widget (if variants are requested, create all of them, not just one)
- CRITICAL: Test the widget(s) in BOTH light and dark themes to ensure proper appearance and contrast
- Ensure the widget is stateless and follows the design system.
- Use theme-aware design tokens from ShadTheme (colors, typography, spacing, etc.)
- After creating and testing in the playground, add the widget to the Styling page's widget catalog (styling_view.dart) for documentation.

<components_rules_and_knowledge>
    - Stateless unless used for temporary user input or animation states
    - Added to project's Components View/Page before actual implementation
    - Receives state from parent view models/hooks linked to views/pages or from global application state management solutions like services
    - Use primitive parameters as parameters to promote general reusability
    - Research and use existing project's UI framework and existing custom widgets before creating new ones to avoid duplication
    - Integrate existing widgets as part of new ones if logical to do so
    - Understand a project's UI framework, theme and design token locations for colors, typography, spacings, sizes, etc and use them accordingly
    - Aim for compact and clean designs as seen in frameworks such a ShadCN and Radix UI
    - Does not contain build methods, but instead creates and uses smaller stateless widgets if absolutely necessary
    - Handles overflows of text and other content gracefully
    - Deliberately uses padding/margin and alignments of elements to ensure proper spacing and layout
    - Follows accessibility best practices such as proper contrast ratios, font sizes, and semantic structure
    - Max lines, overflow types, clipping and properties alike are well thought through to avoid UI breakages
</components_rules_and_knowledge>''';

const String _kSolidifyInstructions = '''Context:
We are working in the Component Playground, which is integrated into the Styling page.
A widget has been created and tested in the playground and is ready to be added to the project.

Theme Support:
- The project supports two themes: 'light' and 'dark' (default is 'dark')
- Widgets MUST work correctly in both light and dark themes
- Use theme-aware colors and design tokens from ShadTheme
- Verify the widget looks correct in both themes before solidifying

Your Goal:
1. Move the widget from the playground to its proper location:
   - Determine the appropriate domain/category (Product, Vendor, Category, Recipe, Meal Plan, Shopping Bag, Health, Specialist, User, Search, Price, Layout, Form, Action, Proposal, Admin, or create new)
   - Place in the appropriate folder following project structure:
     * Shared widgets: lib/src/widgets/{category}/
     * Domain-specific: lib/{domain}/widgets/
   - Follow naming conventions (snake_case for files, PascalCase with T prefix for widget classes)
   - Ensure ALL variants of the widget are included (if multiple variants were created, include all of them)

2. Add the widget to the Styling page catalog:
   - Open turbo_widgets/example/lib/views/styling/styling_view.dart
   - Import the widget at the top with other widget imports
   - Find the appropriate TShowcaseSection or create a new one
   - Add TShowcaseItem entries for ALL variants within the section
   - If multiple variants exist, add a showcase for each variant with descriptive names
   - Ensure demo props showcase the widget properly in both light and dark themes

3. Clear the playground canvas:
   - Remove all widgets from TPlaygroundComponentWrapper in t_playground.dart
   - Restore the placeholder content (Component Testing Area with title and description)

4. Follow project conventions:
   - Widgets are stateless and receive state from ViewModels
   - Use primitive parameters (String, int, double, bool) not DTOs
   - Follow the existing TShowcaseItem pattern
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
- Does not contain build methods, but instead creates and uses smaller stateless widgets if absolutely necessary
- Handles overflows of text and other content gracefully
- Deliberately uses padding/margin and alignments of elements to ensure proper spacing and layout
- Follows accessibility best practices such as proper contrast ratios, font sizes, and semantic structure
- Max lines, overflow types, clipping and properties alike are well thought through to avoid UI breakages
</components_rules_and_knowledge>

ALWAYS apply these widget rules and knowledge when creating or modifying widgets.''';

const String _kClearCanvasInstructions = '''Context:
We are working in the Component Playground, which is integrated into the Styling page (turbo_widgets/example/lib/views/styling/styling_view.dart).
The TPlaygroundComponentWrapper currently contains widgets that need to be cleared to prepare for new widget creation.

Structure:
1. The TPlayground widget is located at turbo_widgets/lib/src/widgets/t_playground.dart
2. Inside the TPlayground, there is a TPlaygroundComponentWrapper that contains the widgets under test
3. The placeholder content should be restored to its original state

Your Goal:
- Remove all widgets currently inside the TPlaygroundComponentWrapper's children area in t_playground.dart
- Restore the original placeholder content (Component Testing Area with title and description)
- The placeholder should be located in t_playground.dart, inside the TPlaygroundComponentWrapper
- Ensure the placeholder matches the original structure:
  - A Column with centered content
  - A Text widget with "Component Testing Area" as the title
  - A Text widget with description "Use the prompt generator above to create new widgets, or add widgets here to test them."
- This clears the canvas for starting fresh with a new widget creation''';

class TPlaygroundPromptGenerator extends StatelessWidget {
  const TPlaygroundPromptGenerator({
    required this.userRequest,
    required this.onUserRequestChanged,
    required this.variations,
    required this.onVariationsChanged,
    required this.activeTab,
    required this.onActiveTabChanged,
    required this.onCopyPrompt,
    super.key,
    this.instructions,
    this.onInstructionsChanged,
  });

  final String userRequest;
  final ValueChanged<String> onUserRequestChanged;
  final String variations;
  final ValueChanged<String> onVariationsChanged;
  final String activeTab;
  final ValueChanged<String> onActiveTabChanged;
  final VoidCallback onCopyPrompt;
  final String? instructions;
  final ValueChanged<String>? onInstructionsChanged;

  String get _effectiveInstructions => instructions ?? _kDefaultInstructions;

  String _buildPrompt() {
    if (activeTab == 'solidify') {
      return '''Solidify the widget from the Component Playground.
Current File: turbo_widgets/lib/src/widgets/t_playground.dart
Styling Page: turbo_widgets/example/lib/views/styling/styling_view.dart

$_kSolidifyInstructions

Task:
Add the widget from the playground to the project following conventions, add it to the styling page catalog, and clear the canvas.''';
    } else if (activeTab == 'clear') {
      return '''Clear the Component Playground canvas.
Current File: turbo_widgets/lib/src/widgets/t_playground.dart
Playground Location: Integrated into the Styling page at turbo_widgets/example/lib/views/styling/styling_view.dart

$_kClearCanvasInstructions

Task:
Clear the playground canvas and restore the placeholder content.''';
    } else {
      return '''We are working on a new widget in the Component Playground.
Current File: turbo_widgets/lib/src/widgets/t_playground.dart
Playground Location: Integrated into the Styling page at turbo_widgets/example/lib/views/styling/styling_view.dart

$_effectiveInstructions

Task:
Create the following widget in the Playground:
$userRequest

Requirements:
- Create $variations variant(s) of this widget.
- Ensure it follows the rules above.
- Add the widget(s) inside the TPlaygroundComponentWrapper's children area, replacing the placeholder content.
''';
    }
  }

  void _handleCopyPrompt() {
    final prompt = _buildPrompt();
    Clipboard.setData(ClipboardData(text: prompt));
    onCopyPrompt();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Component Request',
                  style: theme.textTheme.large.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ShadButton(
                  onPressed: _handleCopyPrompt,
                  leading: const Icon(LucideIcons.copy, size: 16),
                  child: const Text('Copy Prompt'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ShadTabs<String>(
              value: activeTab,
              onChanged: onActiveTabChanged,
              tabs: [
                ShadTab(
                  value: 'request',
                  content: _RequestTabContent(
                    userRequest: userRequest,
                    onUserRequestChanged: onUserRequestChanged,
                    variations: variations,
                    onVariationsChanged: onVariationsChanged,
                  ),
                  child: const Text('Request'),
                ),
                ShadTab(
                  value: 'instructions',
                  content: _InstructionsTabContent(
                    instructions: _effectiveInstructions,
                    onInstructionsChanged: onInstructionsChanged,
                  ),
                  child: const Text('Instructions'),
                ),
                const ShadTab(
                  value: 'solidify',
                  content: _SolidifyTabContent(),
                  child: Text('Solidify'),
                ),
                const ShadTab(
                  value: 'clear',
                  content: _ClearTabContent(),
                  child: Text('Clear'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestTabContent extends StatelessWidget {
  const _RequestTabContent({
    required this.userRequest,
    required this.onUserRequestChanged,
    required this.variations,
    required this.onVariationsChanged,
  });

  final String userRequest;
  final ValueChanged<String> onUserRequestChanged;
  final String variations;
  final ValueChanged<String> onVariationsChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Describe the widget you want to create',
          style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ShadTextarea(
          placeholder: const Text(
            'E.g., A user profile card with avatar, name, and stats...',
          ),
          initialValue: userRequest,
          onChanged: onUserRequestChanged,
          minHeight: 120,
          maxHeight: 240,
        ),
        const SizedBox(height: 16),
        Text(
          'Number of Variants',
          style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ShadSelect<String>(
          initialValue: variations,
          onChanged: (value) {
            if (value != null) onVariationsChanged(value);
          },
          options: const [
            ShadOption(value: '1', child: Text('1 Variant')),
            ShadOption(value: '2', child: Text('2 Variants')),
            ShadOption(value: '3', child: Text('3 Variants')),
          ],
          selectedOptionBuilder: (context, value) => Text('$value Variant${value == '1' ? '' : 's'}'),
        ),
        const SizedBox(height: 4),
        Text(
          'Select how many design variations you want to see.',
          style: theme.textTheme.muted,
        ),
      ],
    );
  }
}

class _InstructionsTabContent extends StatelessWidget {
  const _InstructionsTabContent({
    required this.instructions,
    this.onInstructionsChanged,
  });

  final String instructions;
  final ValueChanged<String>? onInstructionsChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              LucideIcons.info,
              size: 16,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 8),
            Text(
              'These instructions will be included in the prompt to guide the AI.',
              style: theme.textTheme.muted,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ShadTextarea(
          initialValue: instructions,
          onChanged: onInstructionsChanged,
          minHeight: 280,
          maxHeight: 500,
          style: theme.textTheme.small.copyWith(fontFamily: 'monospace'),
        ),
      ],
    );
  }
}

class _SolidifyTabContent extends StatelessWidget {
  const _SolidifyTabContent();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              LucideIcons.info,
              size: 16,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'These instructions will add the widget to the project following conventions, add it to the styling page catalog, and clear the canvas.',
                style: theme.textTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ShadTextarea(
          initialValue: _kSolidifyInstructions,
          readOnly: true,
          minHeight: 280,
          maxHeight: 500,
          style: theme.textTheme.small.copyWith(fontFamily: 'monospace'),
        ),
      ],
    );
  }
}

class _ClearTabContent extends StatelessWidget {
  const _ClearTabContent();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              LucideIcons.info,
              size: 16,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'These instructions will clear the playground canvas and restore the placeholder content for starting a new widget.',
                style: theme.textTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ShadTextarea(
          initialValue: _kClearCanvasInstructions,
          readOnly: true,
          minHeight: 280,
          maxHeight: 500,
          style: theme.textTheme.small.copyWith(fontFamily: 'monospace'),
        ),
      ],
    );
  }
}
