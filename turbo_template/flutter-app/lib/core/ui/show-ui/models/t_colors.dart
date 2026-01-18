part of '../widgets/t_provider.dart';

class TColors {
  const TColors({required this.context, required this.themeMode});

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final BuildContext context;
  final TThemeMode themeMode;

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  static const primaryViolet = Color(0xFF8A2BE2);
  static const primaryRed = Color(0xFFDC2626);
  static const primaryOlive = Color(0xFFA8A03C);
  static const primaryBody = Color(0xFFC0B4D4);

  static final primaryDivider = const Color(0xFFBE34D5).withValues(alpha: 0.5);

  static const primaryLight = Colors.black;
  static const primaryDark = Color(0xFFB54FCA);

  static const secondaryLight = Color(0xFFA9A03D); // Mapped from secondaryDark in user schema
  static const secondaryDark = Color(0xFFA9A03D);

  static const accentLight = Color(0xFF00FFFF);
  static const accentDark = Color(0xFF4DEEEE);

  static const backgroundLight = Color(0xFFF5F5F5);
  static const backgroundDark = Color(0xFF1E1033);

  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF2A1640);

  static const textPrimaryLight = Color(0xFF111111);
  static const textPrimaryDark = Color(0xFFF8F8F8);

  static const textSecondaryLight = Color(0xFF6E6E6E);
  static const textSecondaryDark = Color(0xFFBDBDBD);

  static const borderLight = Color(0xFFEFE9E9);
  static const borderDark = Color(0xFF3D2A5E);

  static const destructiveLight = Color(0xFFDC2625);
  static const destructiveDark = Color(0xFFDC2625);

  static const focusLight = primaryLight;
  static const focusDark = Color(0xFFCE93D8);

  static const dialogLight = Color(0xFFF8F8F8);
  static const dialogDark = Color(0xFF342252);

  static const mutedLight = Color(0xFFBDBDBD);
  static const mutedDark = Color(0xFF666666);

  static const headingLight = Color(0xFF1A1A1A);
  static const headingDark = Color(0xFFFFFFFF);

  static const textHintLight = Color(0xFF9E9E9E);
  static const textHintDark = Color(0xFF757575);

  static const shellLight = Color(0xFFFFFFFF);
  static const shellDark = Color(0xFF2D1A4A);

  static const dividerLight = Color(0xFFEEEEEE);
  static const dividerDark = Color(0xFF413163);

  static const iconPrimaryLight = Color(0xFF411356);
  static const iconPrimaryDark = Color(0xFFA64FC9);

  static const iconPrimaryBgLight = Color(0xFF480D66);
  static const iconPrimaryBgDark = Color(0xFF2D0C3E);

  static const iconSecondaryLight = Color(0xFF9D65B2);
  static const iconSecondaryDark = Color(0xFF8A68A8);

  static const iconSecondaryBgLight = Color(0xFF583068);
  static const iconSecondaryBgDark = Color(0xFF271434);

  static const successLight = Color(0xFF22C55E);
  static const successDark = Color(0xFF4ADE80);

  static const warningLight = Color(0xFFF57C00);
  static const warningDark = Color(0xFFFFB74D);

  static const infoLight = Color(0xFF0288D1);
  static const infoDark = Color(0xFF4FC3F7);

  static const subtitleLight = Color(0xFF71717B);
  static const subtitleDark = Color(0xFFCE93D8);
  static const captionLight = Color(0xFF7B1FA2);
  static const captionDark = Color(0xFFAB47BC);
  static const listItemLight = Color(0xFF1F053D);
  static const listItemDark = Color(0xFFE1BEE7);
  static const subLabelLight = Color(0xB21F053D);
  static const subLabelDark = Color(0xFFB39DDB);

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\

  ShadColorScheme get colorScheme => context.theme.data.colorScheme;

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  Color get cardBorder => switch (themeMode) {
    TThemeMode.dark => TColors.backgroundDark.darken(),
    TThemeMode.light => TColors.borderLight,
  };

  Color get hover => switch (themeMode) {
    TThemeMode.light => card.onHover,
    TThemeMode.dark => card.onHover,
  };

  Color get secondary => colorScheme.secondary;
  Color get appBar => shell;
  Color get background => colorScheme.background;
  Color get border => colorScheme.border;
  Color get icon => colorScheme.ring;
  Color get input => colorScheme.input;
  Color get focus => colorScheme.selection;
  Color get primary => colorScheme.primary;
  Color get card => colorScheme.card;
  Color get destructive => colorScheme.destructive;

  Color get shell => switch (themeMode) {
    TThemeMode.light => shellLight,
    TThemeMode.dark => shellDark,
  };

  Color get cardMidground {
    switch (themeMode) {
      case TThemeMode.dark:
        return const Color(0xFF3C295A);
      case TThemeMode.light:
        return card.darken(3);
    }
  }

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

  Color get listItem => switch (themeMode) {
    TThemeMode.dark => listItemDark,
    TThemeMode.light => listItemLight,
  };

  Color get primaryText => switch (themeMode) {
    TThemeMode.light => textPrimaryLight,
    TThemeMode.dark => textPrimaryDark,
  };

  Color get filled => switch (themeMode) {
    TThemeMode.light => card.darken(4),
    TThemeMode.dark => card.darken(4),
  };

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

  Color get error => switch (themeMode) {
    TThemeMode.light => destructiveLight,
    TThemeMode.dark => destructiveDark,
  };

  Color get dialog => switch (themeMode) {
    TThemeMode.light => dialogLight,
    TThemeMode.dark => dialogDark,
  };

  Color get transparantLightCardBorder => border.withValues(alpha: 0.75);
  Color get transparantDarkCardBorder =>
      background.onColor.withValues(alpha: TSizes.opacityDisabled);
  Color get solidLightCardBorder => const Color(0xBF272727);

  // 🖼️ GRADIENTS ----------------------------------------------------------------------------- \\

  List<Color> get primaryButtonGradient => primaryGradient;
  List<Color> get secondaryButtonGradient => secondaryGradient;

  List<Color> get primaryGradient => [primary.lighten(10), primary];

  List<Color> get secondaryGradient => [secondary.lighten(10), secondary];

  List<Color> get transparantCardGradient => [
    Colors.transparent,
    switch (themeMode) {
      TThemeMode.dark => Colors.white.withValues(alpha: 0.03),
      TThemeMode.light => Colors.black.withValues(alpha: 0.03),
    },
  ];

  TGradient get topCenterTransparantCardGradient => TGradient.topCenter(
    colors: [
      Colors.transparent,
      switch (themeMode) {
        TThemeMode.dark => Colors.white.withValues(alpha: 0.03),
        TThemeMode.light => Colors.black.withValues(alpha: 0.03),
      },
    ],
  );

  List<Color> get colorCardGradient => [
    background,
    switch (themeMode) {
      TThemeMode.dark => Colors.white.withValues(alpha: 0.03),
      TThemeMode.light => Colors.black.withValues(alpha: 0.03),
    },
  ];
}
