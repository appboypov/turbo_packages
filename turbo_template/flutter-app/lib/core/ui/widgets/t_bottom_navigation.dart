import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/shrinks.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_gradient.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_icon.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_margin.dart';

class TBottomNavigation extends StatelessWidget {
  const TBottomNavigation({
    Key? key,
    required this.currentNavigationTab,
    required this.navigationTabs,
    required this.onNavigationTap,
  }) : super(key: key);

  final NavigationTab currentNavigationTab;
  final List<NavigationTab> navigationTabs;
  final void Function(NavigationTab navigationTab, BuildContext context) onNavigationTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      backgroundBlendMode: BlendMode.srcIn,
      boxShadow: context.decorations.outerOnCardShadow,
      gradient: TGradient.topCenter(
        stops: const [0.0, 0.65],
        colors: [context.colors.cardMidground, context.colors.card.withValues(alpha: 0.75)],
      ),
      border: Border(top: BorderSide(color: context.colors.cardBorder, width: 1)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: Row(
      children: [
        for (final navigationTab in navigationTabs)
          Expanded(
            child: Builder(
              builder: (context) {
                final isActive = currentNavigationTab == navigationTab;
                return TButton(
                  onPressed: () => onNavigationTap(navigationTab, context),
                  hoverBuilder: (context, isHovered, child) => TMargin.button(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const TGap(16),
                        TIconSmall(
                          navigationTab.icon,
                          iconSize: IconSize.medium,
                          color: switch (context.themeMode) {
                            TThemeMode.dark =>
                              isActive || isHovered
                                  ? context.colors.primary.onColor
                                  : context.colors.card.onColor.withValues(alpha: 0.5),
                            TThemeMode.light => context.colors.primary,
                          },
                        ),
                        const TGap(6),
                        VerticalShrink(
                          alignment: Alignment.topCenter,
                          show: isActive || isHovered,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              navigationTab.label(strings: context.strings),
                              style: context.texts.small.copyWith(
                                color: switch (context.themeMode) {
                                  TThemeMode.dark =>
                                    isActive || isHovered
                                        ? context.colors.primary.onColor
                                        : context.colors.card.onColor.withValues(alpha: 0.5),
                                  TThemeMode.light => context.colors.primary,
                                },
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TGap(context.sizes.bottomSafeAreaWithMinimum),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    ),
  );
}
