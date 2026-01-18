part of '../widgets/t_provider.dart';

class TColors {
  const TColors({required this.context, required this.themeMode});

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final BuildContext context;
  final TThemeMode themeMode;

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // New York theme (Zinc color scheme)

  static const primaryLight = Color(0xff18181b);
  static const primaryDark = Color(0xfffafafa);

  static const secondaryLight = Color(0xfff4f4f5);
  static const secondaryDark = Color(0xff27272a);

  static const accentLight = Color(0xfff4f4f5);
  static const accentDark = Color(0xff27272a);

  static const backgroundLight = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xff09090b);

  static const cardLight = Color(0xffffffff);
  static const cardDark = Color(0xff09090b);

  static const textPrimaryLight = Color(0xff09090b);
  static const textPrimaryDark = Color(0xfffafafa);

  static const textSecondaryLight = Color(0xff71717a);
  static const textSecondaryDark = Color(0xffa1a1aa);

  static const borderLight = Color(0xffe4e4e7);
  static const borderDark = Color(0xff27272a);

  static const destructiveLight = Color(0xffef4444);
  static const destructiveDark = Color(0xffef4444);

  static const focusLight = Color(0xff18181b);
  static const focusDark = Color(0xffd4d4d8);

  static const dialogLight = Color(0xffffffff);
  static const dialogDark = Color(0xff09090b);

  static const mutedLight = Color(0xfff4f4f5);
  static const mutedDark = Color(0xff27272a);

  static const headingLight = Color(0xff09090b);
  static const headingDark = Color(0xfffafafa);

  static const textHintLight = Color(0xff71717a);
  static const textHintDark = Color(0xffa1a1aa);

  static const shellLight = Color(0xfffafafa);
  static const shellDark = Color(0xff09090b);

  static const dividerLight = Color(0xffe4e4e7);
  static const dividerDark = Color(0xff27272a);

  static const iconPrimaryLight = Color(0xff18181b);
  static const iconPrimaryDark = Color(0xfffafafa);

  static const iconPrimaryBgLight = Color(0xfff4f4f5);
  static const iconPrimaryBgDark = Color(0xff27272a);

  static const iconSecondaryLight = Color(0xff71717a);
  static const iconSecondaryDark = Color(0xffa1a1aa);

  static const iconSecondaryBgLight = Color(0xffe4e4e7);
  static const iconSecondaryBgDark = Color(0xff3f3f46);

  static const successLight = Color(0xFF22C55E);
  static const successDark = Color(0xFF4ADE80);

  static const warningLight = Color(0xFFF57C00);
  static const warningDark = Color(0xFFFFB74D);

  static const infoLight = Color(0xFF0288D1);
  static const infoDark = Color(0xFF4FC3F7);

  static const subtitleLight = Color(0xff71717a);
  static const subtitleDark = Color(0xffa1a1aa);
  static const captionLight = Color(0xff71717a);
  static const captionDark = Color(0xffa1a1aa);
  static const listItemLight = Color(0xff09090b);
  static const listItemDark = Color(0xfffafafa);
  static const subLabelLight = Color(0xff71717a);
  static const subLabelDark = Color(0xffa1a1aa);

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
