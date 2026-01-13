import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/config/turbo_breakpoint_config.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/box_constraints_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_colors.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_data.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_decorations.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_sizes.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_texts.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/utils/t_tools.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/enums/t_supported_language.dart';

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
      final deviceType = constraints.turboDeviceType(breakpointConfig: tBreakpointConfig);
      final sizes = TSizes(context: context, deviceType: deviceType);
      final colors = TColors(context: context, themeMode: tThemeMode);
      final decorations = TDecorations(
        colors: colors,
        themeMode: tThemeMode,
        deviceType: deviceType,
      );
      final texts = TTexts(sizes: sizes, colors: colors);
      final tools = TTools(
        currentWidth: constraints.maxWidth,
        currentHeight: constraints.maxHeight,
        widthInDesign: 720,
        heightInDesign: 1440,
      );
      final data = TData(
        currentWidth: constraints.maxWidth,
        currentHeight: constraints.maxHeight,
        orientation: constraints.turboOrientation,
        deviceType: deviceType,
        media: MediaQuery.of(context),
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
