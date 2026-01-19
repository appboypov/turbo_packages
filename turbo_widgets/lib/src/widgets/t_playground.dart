import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/enums/t_screen_type.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_component_wrapper.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_prompt_generator.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_screen_type_selector.dart';
import 'package:turbo_widgets/src/widgets/t_shrink.dart';

class TPlayground extends StatelessWidget {
  const TPlayground({
    required this.screenType,
    required this.onScreenTypeChanged,
    required this.isGeneratorOpen,
    required this.onToggleGenerator,
    required this.userRequest,
    required this.onUserRequestChanged,
    required this.variations,
    required this.onVariationsChanged,
    required this.activeTab,
    required this.onActiveTabChanged,
    required this.onCopyPrompt,
    super.key,
    this.child,
    this.instructions,
    this.onInstructionsChanged,
  });

  final TScreenType screenType;
  final ValueChanged<TScreenType> onScreenTypeChanged;
  final bool isGeneratorOpen;
  final VoidCallback onToggleGenerator;
  final String userRequest;
  final ValueChanged<String> onUserRequestChanged;
  final String variations;
  final ValueChanged<String> onVariationsChanged;
  final String activeTab;
  final ValueChanged<String> onActiveTabChanged;
  final VoidCallback onCopyPrompt;
  final Widget? child;
  final String? instructions;
  final ValueChanged<String>? onInstructionsChanged;

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
            child: TPlaygroundScreenTypeSelector(
              currentType: screenType,
              onTypeChange: onScreenTypeChanged,
              isGeneratorOpen: isGeneratorOpen,
              onToggleGenerator: onToggleGenerator,
            ),
          ),
          TVerticalShrink(
            show: isGeneratorOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TPlaygroundPromptGenerator(
                userRequest: userRequest,
                onUserRequestChanged: onUserRequestChanged,
                variations: variations,
                onVariationsChanged: onVariationsChanged,
                activeTab: activeTab,
                onActiveTabChanged: onActiveTabChanged,
                onCopyPrompt: onCopyPrompt,
                instructions: instructions,
                onInstructionsChanged: onInstructionsChanged,
              ),
            ),
          ),
          TPlaygroundComponentWrapper(
            screenType: screenType,
            child: child ??
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        'Component Testing Area',
                        style: theme.textTheme.large.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Use the prompt generator above to create new widgets, or add widgets here to test them.',
                        style: theme.textTheme.small.copyWith(
                          color: theme.colorScheme.mutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
