import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/shared/extensions/num_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/color_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/generated/fonts.gen.dart';

enum TThemeMode {
  dark,
  light;

  ShadThemeData get themeData {
    final foregroundColor = (TThemeMode themeMode) => switch (themeMode) {
      TThemeMode.dark => TColors.backgroundDark.onColor,
      TThemeMode.light => TColors.backgroundLight.onColor,
    };
    final shadSheetTheme = (TThemeMode themeMode) => ShadSheetTheme(
      border: Border.all(width: 0, color: Colors.transparent),
      radius: const BorderRadius.only(
        topLeft: Radius.circular(TSizes.cardRadius),
        topRight: Radius.circular(TSizes.cardRadius),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      ),
      backgroundColor: switch (themeMode) {
        TThemeMode.dark => TColors.backgroundDark,
        TThemeMode.light => TColors.backgroundLight,
      },
    );
    final cardTheme = (TThemeMode themeMode) => ShadCardTheme(
      radius: BorderRadius.circular(16),
      backgroundColor: switch (themeMode) {
        TThemeMode.dark => TColors.cardDark,
        TThemeMode.light => TColors.cardLight,
      },
      border: ShadBorder.all(
        width: TSizes.borderWidth,
        color: switch (themeMode) {
          TThemeMode.dark => TColors.backgroundDark.darken(),
          TThemeMode.light => TColors.borderLight,
        },
      ),
      padding: const EdgeInsets.all(TSizes.cardPadding),
    );
    final buttonTheme = (TThemeMode themeMode) => ShadButtonTheme(
      decoration: ShadDecoration(
        border: ShadBorder(radius: BorderRadius.circular(12)),
        focusedBorder: ShadBorder(radius: BorderRadius.circular(TSizes.buttonBorderRadius.x(0.6))),
      ),
    );
    const h1LargeTheme = TextStyle(fontWeight: FontWeight.w900, fontFamily: FontFamily.nunito);

    final dialogTheme = (TThemeMode themeMode) => ShadDialogTheme(
      removeBorderRadiusWhenTiny: false,
      padding: const EdgeInsets.all(TSizes.cardPadding),
      border: Border.all(
        width: TSizes.borderWidth,
        color: switch (themeMode) {
          TThemeMode.dark => TColors.backgroundDark.darken(),
          TThemeMode.light => TColors.borderLight,
        },
      ),
      radius: BorderRadius.circular(TSizes.cardRadius),
      backgroundColor: switch (themeMode) {
        TThemeMode.dark => TColors.cardDark,
        TThemeMode.light => TColors.cardLight,
      },
    );

    const hTheme = TextStyle(letterSpacing: 2, fontFamily: FontFamily.nunito);
    const h34Theme = TextStyle(fontFamily: FontFamily.nunito, fontWeight: FontWeight.w800);
    final mutedTheme = (TThemeMode themeMode) => TextStyle(
      color: switch (themeMode) {
        TThemeMode.dark => TColors.subtitleDark,
        TThemeMode.light => TColors.subtitleLight,
      },
      fontWeight: FontWeight.w600,
      fontFamily: FontFamily.nunito,
    );

    final smallTheme = (TThemeMode themeMode) => TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
      color: switch (themeMode) {
        TThemeMode.dark => TColors.subtitleDark,
        TThemeMode.light => TColors.subLabelLight,
      },
    );

    const largeTheme = TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.nunito);

    const listTheme = TextStyle(
      fontWeight: FontWeight.w800,
      fontFamily: FontFamily.nunito,
      fontSize: 16,
    );
    final textTheme = (TThemeMode themeMode) => ShadTextTheme(
      family: FontFamily.nunito,
      muted: mutedTheme(themeMode),
      small: smallTheme(themeMode),
      large: largeTheme,
      h1: hTheme,
      h1Large: h1LargeTheme,
      h2: hTheme,
      h3: h34Theme,
      list: listTheme,
      h4: h34Theme,
    );
    final checkboxTheme = ShadCheckboxTheme(
      size: 16,
      decoration: ShadDecoration(
        border: ShadBorder(radius: BorderRadius.circular(6)),
        secondaryFocusedBorder: ShadBorder(radius: BorderRadius.circular(10)),
      ),
    );
    final selectTheme = ShadSelectTheme(
      decoration: ShadDecoration(border: ShadBorder(radius: BorderRadius.circular(6))),
    );
    final optionTheme = (TThemeMode themeMode) => ShadOptionTheme(
      hoveredBackgroundColor: switch (themeMode) {
        TThemeMode.dark => TColors.backgroundDark.onHover,
        TThemeMode.light => TColors.backgroundLight.onHover,
      },
    );
    final shadInputTheme = (TThemeMode themeMode) => ShadInputTheme(
      placeholderStyle: mutedTheme(themeMode).copyWith(
        color: switch (themeMode) {
          TThemeMode.dark => TColors.focusDark.withAlpha(100),
          TThemeMode.light => TColors.focusLight.withAlpha(80),
        },
      ),
    );
    final backgroundColor = (TThemeMode themeMode) => switch (themeMode) {
      TThemeMode.dark => TColors.backgroundDark,
      TThemeMode.light => TColors.backgroundLight,
    };
    final toastTheme = (TThemeMode themeMode) => ShadToastTheme(
      radius: BorderRadius.circular(TSizes.buttonBorderRadius),
      backgroundColor: switch (themeMode) {
        TThemeMode.dark => TColors.cardDark,
        TThemeMode.light => TColors.cardLight,
      },
    );
    switch (this) {
      case TThemeMode.light:
        return ShadThemeData(
          colorScheme: const CustomColorScheme.light().copyWith(
            foreground: foregroundColor(TThemeMode.light),
            background: backgroundColor(TThemeMode.light),
          ),
          brightness: Brightness.light,
          disableSecondaryBorder: true,
          cardTheme: cardTheme(TThemeMode.light),
          checkboxTheme: checkboxTheme,
          selectTheme: selectTheme,
          optionTheme: optionTheme(TThemeMode.light),
          primaryDialogTheme: dialogTheme(TThemeMode.light),
          alertDialogTheme: dialogTheme(TThemeMode.light),
          sheetTheme: shadSheetTheme(TThemeMode.light),
          inputTheme: shadInputTheme(TThemeMode.light),
          destructiveButtonTheme: buttonTheme(TThemeMode.light),
          ghostButtonTheme: buttonTheme(TThemeMode.light),
          linkButtonTheme: buttonTheme(TThemeMode.light),
          outlineButtonTheme: buttonTheme(TThemeMode.light),
          primaryButtonTheme: buttonTheme(TThemeMode.light),
          radius: BorderRadius.circular(8),
          secondaryButtonTheme: buttonTheme(TThemeMode.light),
          textTheme: textTheme(TThemeMode.light),
          primaryToastTheme: toastTheme(TThemeMode.light),
        );
      case TThemeMode.dark:
        return ShadThemeData(
          inputTheme: shadInputTheme(TThemeMode.dark),
          sheetTheme: shadSheetTheme(TThemeMode.dark),
          selectTheme: selectTheme,
          optionTheme: optionTheme(TThemeMode.dark),
          primaryDialogTheme: dialogTheme(TThemeMode.dark),
          alertDialogTheme: dialogTheme(TThemeMode.dark),
          colorScheme: const CustomColorScheme.dark().copyWith(
            foreground: foregroundColor(TThemeMode.dark),
            background: backgroundColor(TThemeMode.dark),
          ),
          brightness: Brightness.dark,
          disableSecondaryBorder: true,
          popoverTheme: ShadPopoverTheme(
            decoration: ShadDecoration(border: ShadBorder.all(radius: BorderRadius.circular(16))),
          ),
          cardTheme: cardTheme(TThemeMode.dark),
          checkboxTheme: checkboxTheme,
          destructiveButtonTheme: buttonTheme(TThemeMode.dark),
          ghostButtonTheme: buttonTheme(TThemeMode.dark),
          linkButtonTheme: buttonTheme(TThemeMode.dark),
          outlineButtonTheme: buttonTheme(TThemeMode.dark),
          primaryButtonTheme: buttonTheme(TThemeMode.dark),
          radius: BorderRadius.circular(8),
          secondaryButtonTheme: buttonTheme(TThemeMode.dark),
          textTheme: textTheme(TThemeMode.dark),
          primaryToastTheme: toastTheme(TThemeMode.dark),
        );
    }
  }

  ThemeMode get materialThemeMode {
    switch (this) {
      case TThemeMode.light:
        return ThemeMode.light;
      case TThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  SystemUiOverlayStyle get systemUiOverlayStyle {
    switch (this) {
      case TThemeMode.light:
        return SystemUiOverlayStyle.dark;
      case TThemeMode.dark:
        return SystemUiOverlayStyle.light;
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case TThemeMode.light:
        return ThemeMode.light;
      case TThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  static const TThemeMode defaultValue = TThemeMode.dark;
}

@immutable
class CustomColorScheme extends ShadColorScheme {
  const CustomColorScheme({
    required super.background,
    required super.foreground,
    required super.card,
    required super.cardForeground,
    required super.popover,
    required super.popoverForeground,
    required super.primary,
    required super.primaryForeground,
    required super.secondary,
    required super.secondaryForeground,
    required super.muted,
    required super.mutedForeground,
    required super.accent,
    required super.accentForeground,
    required super.destructive,
    required super.destructiveForeground,
    required super.border,
    required super.input,
    required super.ring,
    required super.selection,
    required this.shell,
  });

  final Color shell;

  const CustomColorScheme.light()
      : shell = TColors.shellLight,
        super(
          background: TColors.backgroundLight,
          foreground: TColors.textPrimaryLight,
          card: TColors.cardLight,
          cardForeground: TColors.textPrimaryLight,
          popover: TColors.dialogLight,
          popoverForeground: TColors.textPrimaryLight,
          primary: TColors.primaryLight,
          primaryForeground: TColors.textPrimaryDark,
          secondary: TColors.secondaryLight,
          secondaryForeground: TColors.textPrimaryLight,
          muted: TColors.mutedLight,
          mutedForeground: TColors.textSecondaryLight,
          accent: TColors.accentLight,
          accentForeground: TColors.textPrimaryLight,
          destructive: TColors.destructiveLight,
          destructiveForeground: TColors.textPrimaryDark,
          border: TColors.borderLight,
          input: TColors.borderLight,
          ring: TColors.focusLight,
          selection: const Color(0xFFB4D7FF),
        );

  const CustomColorScheme.dark()
      : shell = TColors.shellDark,
        super(
          background: TColors.backgroundDark,
          foreground: TColors.textPrimaryDark,
          card: TColors.cardDark,
          cardForeground: TColors.textPrimaryDark,
          popover: TColors.dialogDark,
          popoverForeground: TColors.textPrimaryDark,
          primary: TColors.primaryDark,
          primaryForeground: TColors.textPrimaryLight,
          secondary: TColors.secondaryDark,
          secondaryForeground: TColors.textPrimaryDark,
          muted: TColors.mutedDark,
          mutedForeground: TColors.textSecondaryDark,
          accent: TColors.accentDark,
          accentForeground: TColors.textPrimaryDark,
          destructive: TColors.destructiveDark,
          destructiveForeground: TColors.textPrimaryDark,
          border: TColors.borderDark,
          input: TColors.borderDark,
          ring: TColors.focusDark,
          selection: const Color(0xFF355172),
        );

  @override
  CustomColorScheme copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? selection,
    Map<String, Color>? custom,
    Color? shell,
  }) {
    return CustomColorScheme(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground: destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      selection: selection ?? this.selection,
      shell: shell ?? this.shell,
    );
  }
}
