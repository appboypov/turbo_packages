import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_selected_state.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_gradient.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/generated/assets.gen.dart';

class TCheckBox extends StatelessWidget {
  const TCheckBox({
    required this.selectedState,
    this.onPressed,
    this.animationDuration = TDurations.animationX0p5,
    this.borderRadius,
    this.checkedCurve = Curves.easeInOut,
    this.hitBoxPadding,
    this.innerPadding,
    this.size = TSizes.iconButtonSize,
    this.uncheckedCurve = Curves.easeInOut,
    this.color,
    this.iconBuilder,
    this.forceIcon = false,
    Key? key,
  }) : super(key: key);

  final BorderRadius? borderRadius;
  final Curve checkedCurve;
  final Curve uncheckedCurve;
  final Duration animationDuration;
  final EdgeInsets? hitBoxPadding;
  final EdgeInsets? innerPadding;
  final void Function(SelectedState selectedState, BuildContext context)? onPressed;
  final SelectedState selectedState;
  final double size;
  final Color? color;
  final Widget Function(SelectedState selectedState)? iconBuilder;
  final bool forceIcon;

  @override
  Widget build(BuildContext context) {
    final selectedColor = selectedState.color(context: context);
    final isActive = selectedState.isActive;
    final animatedContainer =
        AnimatedContainer(
              curve: isActive ? checkedCurve : uncheckedCurve,
              duration: animationDuration,
              height: size,
              padding: innerPadding ?? const EdgeInsets.all(8),
              width: size,
              decoration: BoxDecoration(
                border: isActive
                    ? Border.all(color: context.colors.border, width: TSizes.borderWidth)
                    : Border.all(
                        color: context.colors.primary.butWhenLightMode(
                          context,
                          (cValue) => context.colors.border.darken(),
                        ),
                        width: TSizes.borderWidth,
                      ),
                color: isActive ? null : context.colors.cardMidground,
                gradient: isActive
                    ? TGradient.topCenter(
                        colors:
                            (color ??
                                    context.colors.primary.butWhenLightMode(
                                      context,
                                      (cValue) => Colors.blue,
                                    ))
                                .asGradient(),
                      )
                    : null,
                borderRadius: borderRadius ?? BorderRadius.circular(12),
                boxShadow: context.decorations.shadow,
              ),
              child: AnimatedScale(
                curve: isActive || forceIcon ? checkedCurve : uncheckedCurve,
                duration: animationDuration,
                scale: isActive || forceIcon ? 1 : 0,
                child: AnimatedOpacity(
                  child:
                      iconBuilder?.call(selectedState) ??
                      switch (selectedState) {
                        SelectedState.deselected => null,
                        SelectedState.selected => SvgPicture.asset(
                          Assets.svgs.check.path,
                          colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                        ),
                        SelectedState.excluded => SvgPicture.asset(
                          Assets.svgs.hyphen.path,
                          colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                        ),
                      },
                  curve: isActive ? checkedCurve : uncheckedCurve,
                  duration: animationDuration,
                  opacity: isActive || forceIcon ? 1 : 0,
                ),
              ),
            )
            .animate(key: ValueKey(selectedState), target: isActive ? 1 : 0)
            .shake(duration: TDurations.animation);
    return TButton(
      onPressed: () => onPressed?.call(selectedState, context),
      height: size,
      width: size,
      child: animatedContainer,
    );
  }
}
