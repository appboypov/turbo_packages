import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/enums/t_screen_type.dart';

class TPlaygroundComponentWrapper extends StatelessWidget {
  const TPlaygroundComponentWrapper({
    required this.screenType,
    required this.child,
    super.key,
  });

  final TScreenType screenType;
  final Widget child;

  static const double _mobileWidth = 375;
  static const double _tabletWidth = 768;
  static const double _desktopFallbackWidth = 1920;

  double _getMaxWidth(double availableWidth) {
    switch (screenType) {
      case TScreenType.mobile:
        return _mobileWidth;
      case TScreenType.tablet:
        return _tabletWidth;
      case TScreenType.desktop:
        return availableWidth.isFinite ? availableWidth : _desktopFallbackWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 500),
      decoration: BoxDecoration(
        color: theme.colorScheme.muted.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = _getMaxWidth(constraints.maxWidth);

          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minHeight: screenType != TScreenType.desktop ? 600 : 0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                border: Border.all(color: theme.colorScheme.border),
                boxShadow: ShadShadows.sm,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
