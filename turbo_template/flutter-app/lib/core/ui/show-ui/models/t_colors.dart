import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/spacings.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';

class TColors {
  const TColors({required this.context, required this.themeMode});

  final BuildContext context;
  final TThemeMode themeMode;

  ShadColorScheme get colorScheme => ShadTheme.of(context).colorScheme;

  // ---------------------------------------------------------------------------
  // Shadcn / existing getters
  // ---------------------------------------------------------------------------

  Color get background => colorScheme.background;
  Color get card => colorScheme.card;
  Color get foreground => colorScheme.foreground;
  Color get mutedForeground => colorScheme.mutedForeground;
  Color get destructive => colorScheme.destructive;

  // ---------------------------------------------------------------------------
  // Primary, secondary, border, input, focus, icon, appBar
  // ---------------------------------------------------------------------------

  Color get primary => colorScheme.primary;
  Color get secondary => colorScheme.secondary;
  Color get border => colorScheme.border;
  Color get input => colorScheme.input;
  Color get focus => colorScheme.selection;
  Color get icon => colorScheme.ring;
  Color get appBar => shell;

  // ---------------------------------------------------------------------------
  // Static colors – primary & accent
  // ---------------------------------------------------------------------------

  static const Color primaryViolet = Color(0xFF8A2BE2);
  static const Color primaryRed = Color(0xFFDC2626);
  static const Color primaryOlive = Color(0xFFA8A03C);
  static const Color primaryBody = Color(0xFFC0B4D4);
  static final Color primaryDivider = const Color(0xFFBE34D5).withValues(alpha: 0.5);
  static const Color primaryLight = Colors.black;
  static const Color primaryDark = Color(0xFFB54FCA);
  static const Color secondaryLight = Color(0xFFA9A03D);
  static const Color secondaryDark = Color(0xFFA9A03D);
  static const Color accentLight = Color(0xFF00FFFF);
  static const Color accentDark = Color(0xFF4DEEEE);

  // ---------------------------------------------------------------------------
  // Static colors – background & card
  // ---------------------------------------------------------------------------

  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1E1033);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A1640);

  // ---------------------------------------------------------------------------
  // Static colors – text
  // ---------------------------------------------------------------------------

  static const Color textPrimaryLight = Color(0xFF111111);
  static const Color textPrimaryDark = Color(0xFFF8F8F8);
  static const Color textSecondaryLight = Color(0xFF6E6E6E);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  static const Color headingLight = Color(0xFF1A1A1A);
  static const Color headingDark = Color(0xFFFFFFFF);
  static const Color textHintLight = Color(0xFF9E9E9E);
  static const Color textHintDark = Color(0xFF757575);

  // ---------------------------------------------------------------------------
  // Static colors – border, focus, dialog, muted, shell, divider
  // ---------------------------------------------------------------------------

  static const Color borderLight = Color(0xFFEFE9E9);
  static const Color borderDark = Color(0xFF3D2A5E);
  static const Color focusLight = primaryLight;
  static const Color focusDark = Color(0xFFCE93D8);
  static const Color dialogLight = Color(0xFFF8F8F8);
  static const Color dialogDark = Color(0xFF342252);
  static const Color mutedLight = Color(0xFFBDBDBD);
  static const Color mutedDark = Color(0xFF666666);
  static const Color shellLight = Color(0xFFFFFFFF);
  static const Color shellDark = Color(0xFF2D1A4A);
  static const Color dividerLight = Color(0xFFEEEEEE);
  static const Color dividerDark = Color(0xFF413163);

  // ---------------------------------------------------------------------------
  // Static colors – destructive, icons, semantic, list/caption
  // ---------------------------------------------------------------------------

  static const Color destructiveLight = Color(0xFFDC2625);
  static const Color destructiveDark = Color(0xFFDC2625);
  static const Color iconPrimaryLight = Color(0xFF411356);
  static const Color iconPrimaryDark = Color(0xFFA64FC9);
  static const Color iconPrimaryBgLight = Color(0xFF480D66);
  static const Color iconPrimaryBgDark = Color(0xFF2D0C3E);
  static const Color iconSecondaryLight = Color(0xFF9D65B2);
  static const Color iconSecondaryDark = Color(0xFF8A68A8);
  static const Color iconSecondaryBgLight = Color(0xFF583068);
  static const Color iconSecondaryBgDark = Color(0xFF271434);
  static const Color successLight = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF4ADE80);
  static const Color warningLight = Color(0xFFF57C00);
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color infoLight = Color(0xFF0288D1);
  static const Color infoDark = Color(0xFF4FC3F7);
  static const Color subtitleLight = Color(0xFF71717B);
  static const Color subtitleDark = Color(0xFFCE93D8);
  static const Color captionLight = Color(0xFF7B1FA2);
  static const Color captionDark = Color(0xFFAB47BC);
  static const Color listItemLight = Color(0xFF1F053D);
  static const Color listItemDark = Color(0xFFE1BEE7);
  static const Color subLabelLight = Color(0xB21F053D);
  static const Color subLabelDark = Color(0xFFB39DDB);

  // ---------------------------------------------------------------------------
  // Computed getters – shell, dialog, card, border, hover
  // ---------------------------------------------------------------------------

  Color get shell => switch (themeMode) {
        TThemeMode.light => shellLight,
        TThemeMode.dark => shellDark,
      };

  Color get dialog => switch (themeMode) {
        TThemeMode.light => dialogLight,
        TThemeMode.dark => dialogDark,
      };

  Color get cardMidground => switch (themeMode) {
        TThemeMode.dark => const Color(0xFF3C295A),
        TThemeMode.light => Color.lerp(card, Colors.black, 0.03)!,
      };

  Color get cardBorder => switch (themeMode) {
        TThemeMode.dark => Color.lerp(backgroundDark, Colors.black, 0.05)!,
        TThemeMode.light => borderLight,
      };

  Color get hover => Color.lerp(card, Colors.white, 0.05)!;

  // ---------------------------------------------------------------------------
  // Computed getters – filled, softBorder, caption, subLabel, divider, listItem
  // ---------------------------------------------------------------------------

  Color get filled => Color.lerp(card, Colors.black, 0.04)!;

  Color get softBorder => switch (themeMode) {
        TThemeMode.light => borderLight,
        TThemeMode.dark => borderDark,
      };

  Color get caption => switch (themeMode) {
        TThemeMode.light => captionLight,
        TThemeMode.dark => captionDark,
      };

  Color get subLabel => switch (themeMode) {
        TThemeMode.light => subLabelLight,
        TThemeMode.dark => subLabelDark,
      };

  Color get divider => switch (themeMode) {
        TThemeMode.light => dividerLight,
        TThemeMode.dark => dividerDark,
      };

  Color get listItem => switch (themeMode) {
        TThemeMode.dark => listItemDark,
        TThemeMode.light => listItemLight,
      };

  // ---------------------------------------------------------------------------
  // Computed getters – success, warning, info, error, primaryText
  // ---------------------------------------------------------------------------

  Color get success => switch (themeMode) {
        TThemeMode.dark => successDark,
        TThemeMode.light => successLight,
      };

  Color get warning => switch (themeMode) {
        TThemeMode.dark => warningDark,
        TThemeMode.light => warningLight,
      };

  Color get info => switch (themeMode) {
        TThemeMode.dark => infoDark,
        TThemeMode.light => infoLight,
      };

  Color get error => switch (themeMode) {
        TThemeMode.light => destructiveLight,
        TThemeMode.dark => destructiveDark,
      };

  Color get primaryText => switch (themeMode) {
        TThemeMode.light => textPrimaryLight,
        TThemeMode.dark => textPrimaryDark,
      };

  // ---------------------------------------------------------------------------
  // Transparent / solid borders
  // ---------------------------------------------------------------------------

  Color get transparantLightCardBorder => border.withValues(alpha: 0.75);

  Color get transparantDarkCardBorder =>
      colorScheme.foreground.withValues(alpha: Spacings.opacityDisabled);

  static const Color solidLightCardBorder = Color(0xBF272727);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  List<Color> get primaryGradient => [Color.lerp(primary, Colors.white, 0.1)!, primary];

  List<Color> get secondaryGradient => [Color.lerp(secondary, Colors.white, 0.1)!, secondary];

  List<Color> get primaryButtonGradient => primaryGradient;
  List<Color> get secondaryButtonGradient => secondaryGradient;

  List<Color> get transparantCardGradient => [
        Colors.transparent,
        switch (themeMode) {
          TThemeMode.dark => Colors.white.withValues(alpha: 0.03),
          TThemeMode.light => Colors.black.withValues(alpha: 0.03),
        },
      ];

  List<Color> get colorCardGradient => [
        background,
        switch (themeMode) {
          TThemeMode.dark => Colors.white.withValues(alpha: 0.03),
          TThemeMode.light => Colors.black.withValues(alpha: 0.03),
        },
      ];
}
