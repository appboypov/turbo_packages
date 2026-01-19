import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

const String _kDefaultInstructions = '''Context:
We are working in the Component Playground, a controlled environment with a screen size selector (Mobile, Tablet, Desktop) and a layout wrapper to test widget responsiveness.

Structure:
1. The TPlayground renders a prompt generator card and a component wrapper area.
2. Inside the component wrapper, there is a placeholder area where widgets under test should be placed.
3. The playground can be integrated into any styling/components page in your project.

Theme Support:
- Components MUST work correctly in both light and dark themes
- Use theme-aware colors from ShadTheme that automatically adapt to the theme
- Test components in both themes to ensure proper appearance and contrast
- Ensure proper contrast ratios and visibility in both themes

Your Goal:
- Create the requested widget(s) in an appropriate location within the project structure.
- Add the widget(s) inside the playground's child parameter, replacing the placeholder content.
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
    - Does not contain build methods, but instead creates and uses smaller stateless widgets if absolutely necessary
    - Handles overflows of text and other content gracefully
    - Deliberately uses padding/margin and alignments of elements to ensure proper spacing and layout
    - Follows accessibility best practices such as proper contrast ratios, font sizes, and semantic structure
    - Max lines, overflow types, clipping and properties alike are well thought through to avoid UI breakages
</components_rules_and_knowledge>''';

const String _kSolidifyInstructions = '''Context:
We are working in the Component Playground.
A widget has been created and tested in the playground and is ready to be added to the project.

Theme Support:
- Widgets MUST work correctly in both light and dark themes
- Use theme-aware colors and design tokens from ShadTheme
- Verify the widget looks correct in both themes before solidifying

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
   - Remove all widgets from the playground's child parameter
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
- Does not contain build methods, but instead creates and uses smaller stateless widgets if absolutely necessary
- Handles overflows of text and other content gracefully
- Deliberately uses padding/margin and alignments of elements to ensure proper spacing and layout
- Follows accessibility best practices such as proper contrast ratios, font sizes, and semantic structure
- Max lines, overflow types, clipping and properties alike are well thought through to avoid UI breakages
</components_rules_and_knowledge>

ALWAYS apply these widget rules and knowledge when creating or modifying widgets.''';

const String _kClearCanvasInstructions = '''Context:
We are working in the Component Playground.
The playground currently contains widgets that need to be cleared to prepare for new widget creation.

Your Goal:
- Remove all widgets currently passed to the TPlayground's child parameter
- Set the child parameter to null or remove it entirely to restore the default placeholder
- The default placeholder shows "Component Testing Area" with a description
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

$_kSolidifyInstructions

Task:
Add the widget from the playground to the project following conventions, add it to your components/styling page catalog, and clear the canvas.''';
    } else if (activeTab == 'clear') {
      return '''Clear the Component Playground canvas.

$_kClearCanvasInstructions

Task:
Clear the playground canvas and restore the placeholder content.''';
    } else {
      return '''We are working on a new widget in the Component Playground.

$_effectiveInstructions

Task:
Create the following widget in the Playground:
$userRequest

Requirements:
- Create $variations variant(s) of this widget.
- Ensure it follows the rules above.
- Add the widget(s) to the TPlayground's child parameter, replacing the placeholder content.
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
