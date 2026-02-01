import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/constants/turbo_widgets_devices.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_preview_mode.dart';
import 'package:turbo_widgets/src/enums/turbo_widgets_screen_types.dart';

class TPlaygroundScreenTypeSelector extends StatelessWidget {
  const TPlaygroundScreenTypeSelector({
    required this.currentType,
    required this.onTypeChange,
    required this.isGeneratorOpen,
    required this.onToggleGenerator,
    required this.previewMode,
    required this.onPreviewModeChange,
    required this.selectedDevice,
    required this.onDeviceChange,
    required this.previewScale,
    required this.onPreviewScaleChange,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    required this.isSafeAreaEnabled,
    required this.onToggleSafeArea,
    super.key,
  });

  final TurboWidgetsScreenTypes currentType;
  final ValueChanged<TurboWidgetsScreenTypes> onTypeChange;
  final bool isGeneratorOpen;
  final VoidCallback onToggleGenerator;
  final TurboWidgetsPreviewMode previewMode;
  final ValueChanged<TurboWidgetsPreviewMode> onPreviewModeChange;
  final DeviceInfo? selectedDevice;
  final ValueChanged<DeviceInfo> onDeviceChange;
  final double previewScale;
  final ValueChanged<double> onPreviewScaleChange;
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  final bool isSafeAreaEnabled;
  final VoidCallback onToggleSafeArea;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final availableDevices = TurboWidgetsDevices.devicesForScreenType(
      currentType,
    );
    final isDeviceFrameMode =
        previewMode == TurboWidgetsPreviewMode.deviceFrame;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadButton.raw(
              variant: currentType == TurboWidgetsScreenTypes.mobile
                  ? ShadButtonVariant.primary
                  : ShadButtonVariant.outline,
              size: ShadButtonSize.sm,
              width: 36,
              height: 36,
              padding: EdgeInsets.zero,
              onPressed: () => onTypeChange(TurboWidgetsScreenTypes.mobile),
              child: const Icon(LucideIcons.smartphone, size: 16),
            ),
            const SizedBox(width: 8),
            ShadButton.raw(
              variant: currentType == TurboWidgetsScreenTypes.tablet
                  ? ShadButtonVariant.primary
                  : ShadButtonVariant.outline,
              size: ShadButtonSize.sm,
              width: 36,
              height: 36,
              padding: EdgeInsets.zero,
              onPressed: () => onTypeChange(TurboWidgetsScreenTypes.tablet),
              child: const Icon(LucideIcons.tablet, size: 16),
            ),
            const SizedBox(width: 8),
            ShadButton.raw(
              variant: currentType == TurboWidgetsScreenTypes.desktop
                  ? ShadButtonVariant.primary
                  : ShadButtonVariant.outline,
              size: ShadButtonSize.sm,
              width: 36,
              height: 36,
              padding: EdgeInsets.zero,
              onPressed: () => onTypeChange(TurboWidgetsScreenTypes.desktop),
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
            ShadButton.raw(
              variant: isDeviceFrameMode
                  ? ShadButtonVariant.primary
                  : ShadButtonVariant.outline,
              size: ShadButtonSize.sm,
              width: 36,
              height: 36,
              padding: EdgeInsets.zero,
              onPressed: () => onPreviewModeChange(
                isDeviceFrameMode
                    ? TurboWidgetsPreviewMode.none
                    : TurboWidgetsPreviewMode.deviceFrame,
              ),
              child: const Icon(LucideIcons.frame, size: 16),
            ),
            const SizedBox(width: 8),
            ShadButton.raw(
              variant: isDarkMode
                  ? ShadButtonVariant.primary
                  : ShadButtonVariant.outline,
              size: ShadButtonSize.sm,
              width: 36,
              height: 36,
              padding: EdgeInsets.zero,
              onPressed: onToggleDarkMode,
              child: Icon(
                isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            ShadButton.raw(
              variant: isSafeAreaEnabled
                  ? ShadButtonVariant.primary
                  : ShadButtonVariant.outline,
              size: ShadButtonSize.sm,
              width: 36,
              height: 36,
              padding: EdgeInsets.zero,
              onPressed: onToggleSafeArea,
              child: Icon(
                isSafeAreaEnabled ? LucideIcons.shield : LucideIcons.shieldOff,
                size: 16,
              ),
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
                isGeneratorOpen
                    ? LucideIcons.chevronUp
                    : LucideIcons.chevronDown,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              LucideIcons.minimize2,
              size: 14,
              color: theme.colorScheme.mutedForeground,
            ),
            Expanded(
              child: ShadSlider(
                min: 0.5,
                max: isDeviceFrameMode ? 1.0 : 1.5,
                initialValue: previewScale.clamp(
                  0.5,
                  isDeviceFrameMode ? 1.0 : 1.5,
                ),
                onChanged: onPreviewScaleChange,
              ),
            ),
            Icon(
              LucideIcons.maximize2,
              size: 14,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: Text(
                '${(previewScale * 100).round()}%',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        if (isDeviceFrameMode && availableDevices.isNotEmpty) ...[
          const SizedBox(height: 12),
          ShadSelect<DeviceInfo>(
            placeholder: Text(
              'Select device',
              style: theme.textTheme.muted,
            ),
            initialValue: selectedDevice ?? availableDevices.first,
            options: availableDevices
                .map(
                  (device) => ShadOption(
                    value: device,
                    child: Text(device.name),
                  ),
                )
                .toList(),
            selectedOptionBuilder: (context, value) => Text(value.name),
            onChanged: (device) {
              if (device != null) {
                onDeviceChange(device);
              }
            },
          ),
        ],
      ],
    );
  }
}
