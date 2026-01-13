import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';

class TColors {
  const TColors({required this.context, required this.themeMode});

  final BuildContext context;
  final TThemeMode themeMode;

  Color get background => ShadTheme.of(context).colorScheme.background;
  Color get card => ShadTheme.of(context).colorScheme.card;
  Color get foreground => ShadTheme.of(context).colorScheme.foreground;
  Color get mutedForeground => ShadTheme.of(context).colorScheme.mutedForeground;
  Color get destructive => ShadTheme.of(context).colorScheme.destructive;

  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF161B22);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF21262D);
  static const Color subtitleDark = Color(0xFF8B949E);
  static const Color subLabelLight = Color(0xFF6B7280);
}
