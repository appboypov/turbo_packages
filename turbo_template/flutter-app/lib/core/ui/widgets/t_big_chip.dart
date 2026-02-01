import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turbo_flutter_template/core/generated/assets.gen.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/shrinks.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_animated_enabled.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gap.dart';

class TBigChip extends StatelessWidget {
  const TBigChip({
    required this.text,
    required this.isActive,
    required this.onPressed,
    this.showIcon = true,
    this.inactiveColor,
    this.maxLines = 1,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.activeColor,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool isActive;
  final void Function(bool isActive) onPressed;
  final bool showIcon;
  final Color? inactiveColor;
  final Color? activeColor;
  final int maxLines;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    const iconHeight = 9.0;
    final color = isActive
        ? activeColor ?? context.colors.background
        : inactiveColor ?? context.colors.card;
    const height = 32.0;
    return TButton(
      scaleEnd: 1,
      onPressed: () => onPressed(isActive),
      child: TAnimatedEnabled(
        isEnabled: isActive,
        child: RepaintBoundary(
          child: AnimatedContainer(
            height: height,
            duration: TDurations.animationX0p5,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(width: 1, color: color.onColor),
              borderRadius: BorderRadius.circular(height / 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TGap(1),
                  if (showIcon)
                    HorizontalShrink(
                      alignment: Alignment.centerRight,
                      fadeDuration: TDurations.animationX0p5,
                      sizeDuration: TDurations.animationX0p5,
                      show: isActive,
                      height: iconHeight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: SvgPicture.asset(
                          height: iconHeight,
                          const $AssetsSvgsGen().check.path,
                          colorFilter: ColorFilter.mode(
                            color.onColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  Flexible(
                    child: Transform.translate(
                      offset: const Offset(0, -1),
                      child: AnimatedDefaultTextStyle(
                        style: context.texts.button.copyWith(
                          color: context.colors.background.onColor,
                        ),
                        duration: TDurations.animationX0p5,
                        child: Text(
                          text,
                          maxLines: maxLines,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          textWidthBasis: TextWidthBasis.longestLine,
                        ),
                      ),
                    ),
                  ),
                  const TGap(2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
