import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/enums/t_screen_type.dart';

class TPlaygroundScreenTypeSelector extends StatelessWidget {
  const TPlaygroundScreenTypeSelector({
    required this.currentType,
    required this.onTypeChange,
    required this.isGeneratorOpen,
    required this.onToggleGenerator,
    super.key,
  });

  final TScreenType currentType;
  final ValueChanged<TScreenType> onTypeChange;
  final bool isGeneratorOpen;
  final VoidCallback onToggleGenerator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShadButton.raw(
          variant: currentType == TScreenType.mobile
              ? ShadButtonVariant.primary
              : ShadButtonVariant.outline,
          size: ShadButtonSize.sm,
          width: 36,
          height: 36,
          padding: EdgeInsets.zero,
          onPressed: () => onTypeChange(TScreenType.mobile),
          child: const Icon(LucideIcons.smartphone, size: 16),
        ),
        const SizedBox(width: 8),
        ShadButton.raw(
          variant: currentType == TScreenType.tablet
              ? ShadButtonVariant.primary
              : ShadButtonVariant.outline,
          size: ShadButtonSize.sm,
          width: 36,
          height: 36,
          padding: EdgeInsets.zero,
          onPressed: () => onTypeChange(TScreenType.tablet),
          child: const Icon(LucideIcons.tablet, size: 16),
        ),
        const SizedBox(width: 8),
        ShadButton.raw(
          variant: currentType == TScreenType.desktop
              ? ShadButtonVariant.primary
              : ShadButtonVariant.outline,
          size: ShadButtonSize.sm,
          width: 36,
          height: 36,
          padding: EdgeInsets.zero,
          onPressed: () => onTypeChange(TScreenType.desktop),
          child: const Icon(LucideIcons.laptop, size: 16),
        ),
        const SizedBox(width: 8),
        const SizedBox(
          height: 24,
          child: ShadSeparator.vertical(
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        const SizedBox(width: 8),
        ShadButton.outline(
          size: ShadButtonSize.sm,
          width: 36,
          height: 36,
          padding: EdgeInsets.zero,
          onPressed: onToggleGenerator,
          child: Icon(
            isGeneratorOpen ? LucideIcons.chevronUp : LucideIcons.chevronDown,
            size: 16,
          ),
        ),
      ],
    );
  }
}
