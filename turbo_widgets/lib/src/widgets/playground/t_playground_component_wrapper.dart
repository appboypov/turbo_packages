import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_preview_mode.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_screen_types.dart';

class TPlaygroundComponentWrapper extends StatelessWidget {
  const TPlaygroundComponentWrapper({
    required this.screenType,
    required this.previewMode,
    required this.previewScale,
    required this.child,
    required this.isDarkMode,
    required this.isSafeAreaEnabled,
    this.selectedDevice,
    super.key,
  });

  final TurboWidgetsScreenTypes screenType;
  final TurboWidgetsPreviewMode previewMode;
  final double previewScale;
  final DeviceInfo? selectedDevice;
  final bool isDarkMode;
  final bool isSafeAreaEnabled;
  final Widget child;

  static const double _mobileWidth = 375;
  static const double _tabletWidth = 768;
  static const double _desktopFallbackWidth = 1920;

  double _getMaxWidth(double availableWidth) {
    final baseWidth = switch (screenType) {
      TurboWidgetsScreenTypes.mobile => _mobileWidth,
      TurboWidgetsScreenTypes.tablet => _tabletWidth,
      TurboWidgetsScreenTypes.desktop =>
        availableWidth.isFinite ? availableWidth : _desktopFallbackWidth,
    };
    final scaledWidth = baseWidth * previewScale;
    return availableWidth.isFinite
        ? scaledWidth.clamp(0, availableWidth)
        : scaledWidth;
  }

  double _getMinHeight(double availableHeight) {
    if (screenType == TurboWidgetsScreenTypes.desktop) {
      return 0;
    }
    const baseMinHeight = 600.0;
    final scaledHeight = baseMinHeight * previewScale;
    return availableHeight.isFinite
        ? scaledHeight.clamp(0, availableHeight)
        : scaledHeight;
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
          if (previewMode == TurboWidgetsPreviewMode.deviceFrame &&
              selectedDevice != null) {
            return Center(
              child: Transform.scale(
                scale: previewScale,
                child: DeviceFrame(
                  device: selectedDevice!,
                  screen: _TPlaygroundPreviewContent(
                    isDarkMode: isDarkMode,
                    isSafeAreaEnabled: isSafeAreaEnabled,
                    child: child,
                  ),
                ),
              ),
            );
          }

          final maxWidth = _getMaxWidth(constraints.maxWidth);
          final minHeight = _getMinHeight(constraints.maxHeight);
          final previewThemeData = isDarkMode
              ? ShadThemeData(
                  brightness: Brightness.dark,
                  colorScheme: const ShadSlateColorScheme.dark(),
                )
              : ShadThemeData(
                  brightness: Brightness.light,
                  colorScheme: const ShadSlateColorScheme.light(),
                );

          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minHeight: minHeight,
              ),
              decoration: BoxDecoration(
                color: previewThemeData.colorScheme.background,
                border: Border.all(color: previewThemeData.colorScheme.border),
                boxShadow: ShadShadows.sm,
              ),
              child: _TPlaygroundPreviewContent(
                isDarkMode: isDarkMode,
                isSafeAreaEnabled: isSafeAreaEnabled,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TPlaygroundPreviewContent extends StatelessWidget {
  const _TPlaygroundPreviewContent({
    required this.isDarkMode,
    required this.isSafeAreaEnabled,
    required this.child,
  });

  final bool isDarkMode;
  final bool isSafeAreaEnabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeData = isDarkMode
        ? ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadSlateColorScheme.dark(),
          )
        : ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadSlateColorScheme.light(),
          );

    return ShadTheme(
      data: themeData,
      child: isSafeAreaEnabled ? SafeArea(child: child) : child,
    );
  }
}
