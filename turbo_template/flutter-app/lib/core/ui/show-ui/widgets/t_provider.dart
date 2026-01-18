import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/config/turbo_breakpoint_config.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/text_style_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_data.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/utils/t_tools.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_gradient.dart';
import 'package:turbo_flutter_template/generated/fonts.gen.dart';

export 't_provider.dart';

part '../models/t_colors.dart';
part '../models/t_sizes.dart';
part '../models/t_texts.dart';
part 't_decorations.dart';

class TProvider extends InheritedWidget {
  const TProvider({
    super.key,
    required super.child,
    required this.colors,
    required this.data,
    required this.decorations,
    required this.texts,
    required this.themeMode,
    required this.tools,
    required this.breakpointConfig,
    required this.sizes,
  });

  final TColors colors;
  final TSizes sizes;
  final TDecorations decorations;
  final TTexts texts;
  final TData data;
  final TThemeMode themeMode;
  final TTools tools;
  final TBreakpointConfig breakpointConfig;

  static TProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TProvider>()!;
  @override
  bool updateShouldNotify(TProvider oldWidget) =>
      tools != oldWidget.tools ||
          data != oldWidget.data ||
          themeMode != oldWidget.themeMode ||
          colors != oldWidget.colors ||
          sizes != oldWidget.sizes ||
          decorations != oldWidget.decorations ||
          texts != oldWidget.texts ||
          breakpointConfig != oldWidget.breakpointConfig;
}
