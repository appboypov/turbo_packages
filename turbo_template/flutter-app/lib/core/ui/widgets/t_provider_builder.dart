import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/config/t_breakpoint_config.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_device_type.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/widgets/box_constraints_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_target_platform_extension.dart';
import 'package:turbo_flutter_template/core/ui/models/t_data.dart';
import 'package:turbo_flutter_template/core/ui/utils/t_tools.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ux/enums/t_supported_language.dart';

export 't_provider_builder.dart';

class TProviderBuilder extends StatelessWidget {
  const TProviderBuilder({
    super.key,
    required this.builder,
    required this.tThemeMode,
    required this.tSupportedLanguage,
    this.tBreakpointConfig = const TBreakpointConfig(),
  });

  final TBreakpointConfig tBreakpointConfig;
  final TThemeMode tThemeMode;
  final TSupportedLanguage tSupportedLanguage;
  final Widget Function(
    TDeviceType deviceType,
    TThemeMode themeMode,
    TTools tools,
    TData data,
    TTexts texts,
    TColors colors,
    TSizes sizes,
    TDecorations decorations,
    BuildContext context,
  )
  builder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final deviceType = constraints.deviceType(breakpointConfig: tBreakpointConfig);
      final sizes = TSizes(context: context, deviceType: deviceType);
      final colors = TColors(context: context, themeMode: tThemeMode);
      final decorations = TDecorations(
        colors: colors,
        themeMode: tThemeMode,
        deviceType: deviceType,
      );
      final texts = TTexts(sizes: sizes, colors: colors, theme: context.theme);
      final tools = TTools(
        currentWidth: constraints.maxWidth,
        currentHeight: constraints.maxHeight,
        widthInDesign: defaultTargetPlatform.defaultHeightInDesign,
        heightInDesign: defaultTargetPlatform.defaultWidthInDesign,
      );
      final data = TData(
        currentWidth: constraints.maxWidth,
        currentHeight: constraints.maxHeight,
        orientation: constraints.orientation,
        deviceType: deviceType,
        media: context.media,
      );
      return TProvider(
        data: data,
        themeMode: tThemeMode,
        tools: tools,
        texts: texts,
        colors: colors,
        decorations: decorations,
        breakpointConfig: tBreakpointConfig,
        child: Builder(
          builder: (context) {
            return builder(
              deviceType,
              tThemeMode,
              tools,
              data,
              texts,
              colors,
              sizes,
              decorations,
              context,
            );
          },
        ),
        sizes: sizes,
      );
    },
  );
}
