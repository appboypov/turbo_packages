import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/models/navigation/t_button_config.dart';

/// A horizontal navigation bar intended for bottom placement.
///
/// Renders navigation buttons using a [Flex] layout.
/// Works seamlessly with [TContextualButtons] when placed in the bottom slot.
class TBottomNavigation extends StatelessWidget {
  const TBottomNavigation({
    required this.buttons,
    super.key,
    this.selectedKey,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// Navigation buttons keyed by identifier.
  final Map<String, TButtonConfig> buttons;

  /// The currently selected button key.
  final String? selectedKey;

  /// The direction of the flex layout.
  final Axis direction;

  /// How the children should be placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  final MainAxisSize mainAxisSize;

  /// How the children should be placed along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (final entry in buttons.entries)
          _TNavigationButton(
            config: entry.value,
            isSelected: entry.key == selectedKey,
          ),
      ],
    );
  }
}

class _TNavigationButton extends StatelessWidget {
  const _TNavigationButton({
    required this.config,
    required this.isSelected,
  });

  final TButtonConfig config;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (config.buttonBuilder != null) {
      return config.buttonBuilder!(
        config.icon,
        config.label,
        config.onPressed,
        isSelected,
      );
    }

    final hasIcon = config.icon != null;
    final hasLabel = config.label != null;

    return ShadButton.raw(
      variant: isSelected ? ShadButtonVariant.primary : ShadButtonVariant.ghost,
      size: ShadButtonSize.sm,
      onPressed: config.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon) Icon(config.icon, size: 20),
          if (hasIcon && hasLabel) const Gap(8),
          if (hasLabel) Text(config.label!),
        ],
      ),
    );
  }
}
