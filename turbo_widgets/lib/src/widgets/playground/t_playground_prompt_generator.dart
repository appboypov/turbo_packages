import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/constants/turbo_widgets_defaults.dart';

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
    this.instructions = TurboWidgetsDefaults.instructions,
    this.onInstructionsChanged,
    this.solidifyInstructions = TurboWidgetsDefaults.solidifyInstructions,
    this.clearCanvasInstructions = TurboWidgetsDefaults.clearCanvasInstructions,
  });

  final String activeTab;
  final String clearCanvasInstructions;
  final String instructions;
  final String solidifyInstructions;
  final String userRequest;
  final String variations;
  final ValueChanged<String> onActiveTabChanged;
  final ValueChanged<String> onUserRequestChanged;
  final ValueChanged<String> onVariationsChanged;
  final ValueChanged<String>? onInstructionsChanged;
  final VoidCallback onCopyPrompt;

  String get _effectiveInstructions => instructions ?? TurboWidgetsDefaults.instructions;

  String get _effectiveSolidifyInstructions =>
      solidifyInstructions ?? TurboWidgetsDefaults.solidifyInstructions;

  String get _effectiveClearCanvasInstructions =>
      clearCanvasInstructions ?? TurboWidgetsDefaults.clearCanvasInstructions;

  String _buildPrompt() {
    if (activeTab == 'solidify') {
      return '''Solidify the widget from the Component Playground.

$_effectiveSolidifyInstructions

Task:
Add the widget from the playground to the project following conventions, add it to your components/styling page catalog, and clear the canvas.''';
    } else if (activeTab == 'clear') {
      return '''Clear the Component Playground canvas.

$_effectiveClearCanvasInstructions

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
- MANDATORY: Configure TPlaygroundParameters with a TPlaygroundParameter for EVERY widget prop.
- MANDATORY: Use childBuilder to render the widget - NEVER use child directly.
- Add the widget(s) to the TPlayground's childBuilder, replacing the placeholder content.
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
                ShadTab(
                  value: 'solidify',
                  content: _SolidifyTabContent(
                    instructions: _effectiveSolidifyInstructions,
                  ),
                  child: const Text('Solidify'),
                ),
                ShadTab(
                  value: 'clear',
                  content: _ClearTabContent(
                    instructions: _effectiveClearCanvasInstructions,
                  ),
                  child: const Text('Clear'),
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
          selectedOptionBuilder: (context, value) =>
              Text('$value Variant${value == '1' ? '' : 's'}'),
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
  const _SolidifyTabContent({
    required this.instructions,
  });

  final String instructions;

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
          initialValue: instructions,
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
  const _ClearTabContent({
    required this.instructions,
  });

  final String instructions;

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
          initialValue: instructions,
          readOnly: true,
          minHeight: 280,
          maxHeight: 500,
          style: theme.textTheme.small.copyWith(fontFamily: 'monospace'),
        ),
      ],
    );
  }
}
