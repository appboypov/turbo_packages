import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/theme/turbo_color_scheme.dart';

enum TThemeMode {
  dark,
  light;

  static const TThemeMode defaultValue = TThemeMode.light;

  ShadThemeData get themeData {
    const buttonRadius = 8.0;
    final borderRadius = BorderRadius.circular(buttonRadius);

    final cardTheme = (TThemeMode mode) {
      switch (mode) {
        case TThemeMode.dark:
          return ShadCardTheme(
            radius: BorderRadius.circular(buttonRadius * 2.5),
          );
        case TThemeMode.light:
          return ShadCardTheme(
            radius: BorderRadius.circular(buttonRadius * 2.5),
          );
      }
    };

    final buttonTheme = ShadButtonTheme(
      height: 37,
      decoration: ShadDecoration(
        focusedBorder: ShadBorder(
          radius: BorderRadius.circular(buttonRadius * 1.5),
        ),
        border: ShadBorder(
          radius: BorderRadius.circular(buttonRadius * 1.5),
        ),
      ),
    );

    const h1LargeTheme = TextStyle(
      fontWeight: FontWeight.w900,
    );
    const hTheme = TextStyle(
      fontWeight: FontWeight.w800,
    );
    const mutedTheme = TextStyle(
      fontWeight: FontWeight.w600,
    );
    const smallTheme = TextStyle(
      fontWeight: FontWeight.w700,
    );

    final textTheme = ShadTextTheme(
      family: null,
      muted: mutedTheme,
      small: smallTheme,
      h1: hTheme,
      h1Large: h1LargeTheme,
      h2: hTheme,
      h3: hTheme,
      h4: hTheme,
    );

    final checkboxTheme = ShadCheckboxTheme(
      size: 16,
      decoration: ShadDecoration(
        border: ShadBorder(
          radius: BorderRadius.circular(buttonRadius * 1.5),
        ),
        secondaryFocusedBorder: ShadBorder(
          radius: BorderRadius.circular(buttonRadius * 1.5),
        ),
      ),
    );

    final tabsTheme = ShadTabsTheme(
      tabDecoration: ShadDecoration(
        border: ShadBorder(
          radius: BorderRadius.circular(buttonRadius / 1.5),
        ),
      ),
      decoration: ShadDecoration(
        border: ShadBorder(
          radius: BorderRadius.circular(buttonRadius),
        ),
      ),
    );

    final inputTheme = ShadInputTheme(
      decoration: ShadDecoration(
        focusedBorder: ShadBorder(
          radius: BorderRadius.circular(buttonRadius * 1.5),
        ),
        border: ShadBorder(
          radius: BorderRadius.circular(buttonRadius * 1.5),
        ),
      ),
    );

    final shadSheetTheme = ShadSheetTheme(
      radius: BorderRadius.circular(buttonRadius),
      removeBorderRadiusWhenTiny: false,
    );

    final decoration = ShadDecoration(
      focusedBorder: ShadBorder(
        radius: BorderRadius.circular(buttonRadius * 1.5),
      ),
    );

    final dialogTheme = (TThemeMode mode) => ShadDialogTheme(
          removeBorderRadiusWhenTiny: false,
          padding: const EdgeInsets.all(20),
          border: Border.all(
            width: 1.0,
            color: switch (mode) {
              TThemeMode.dark => const Color(0xFF21262D),
              TThemeMode.light => const Color(0xFFE5E7EB),
            },
          ),
          radius: BorderRadius.circular(buttonRadius * 2.5),
          backgroundColor: switch (mode) {
            TThemeMode.dark => const Color(0xFF161B22),
            TThemeMode.light => const Color(0xFFFFFFFF),
          },
        );

    final optionTheme = (TThemeMode mode) => ShadOptionTheme(
          hoveredBackgroundColor: switch (mode) {
            TThemeMode.dark => const Color(0xFF21262D),
            TThemeMode.light => const Color(0xFFF3F4F6),
          },
        );

    final toastTheme = (TThemeMode mode) => ShadToastTheme(
          radius: BorderRadius.circular(buttonRadius * 1.5),
          backgroundColor: switch (mode) {
            TThemeMode.dark => const Color(0xFF161B22),
            TThemeMode.light => const Color(0xFFFFFFFF),
          },
        );

    switch (this) {
      case TThemeMode.light:
        return ShadThemeData(
          tabsTheme: tabsTheme,
          decoration: decoration,
          colorScheme: const TurboColorScheme.light(),
          brightness: Brightness.light,
          disableSecondaryBorder: true,
          cardTheme: cardTheme(TThemeMode.light),
          checkboxTheme: checkboxTheme,
          destructiveButtonTheme: buttonTheme,
          ghostButtonTheme: buttonTheme,
          linkButtonTheme: buttonTheme,
          outlineButtonTheme: buttonTheme,
          primaryButtonTheme: buttonTheme,
          radius: borderRadius,
          sheetTheme: shadSheetTheme,
          secondaryButtonTheme: buttonTheme,
          textTheme: textTheme,
          primaryDialogTheme: dialogTheme(TThemeMode.light),
          alertDialogTheme: dialogTheme(TThemeMode.light),
          optionTheme: optionTheme(TThemeMode.light),
          inputTheme: inputTheme,
          primaryToastTheme: toastTheme(TThemeMode.light),
        );
      case TThemeMode.dark:
        return ShadThemeData(
          tabsTheme: tabsTheme,
          decoration: decoration,
          colorScheme: const TurboColorScheme.dark(),
          sheetTheme: shadSheetTheme,
          disableSecondaryBorder: true,
          brightness: Brightness.dark,
          cardTheme: cardTheme(TThemeMode.dark),
          checkboxTheme: checkboxTheme,
          destructiveButtonTheme: buttonTheme,
          ghostButtonTheme: buttonTheme,
          linkButtonTheme: buttonTheme,
          outlineButtonTheme: buttonTheme,
          inputTheme: inputTheme,
          primaryButtonTheme: buttonTheme,
          radius: borderRadius,
          secondaryButtonTheme: buttonTheme,
          textTheme: textTheme,
          primaryDialogTheme: dialogTheme(TThemeMode.dark),
          alertDialogTheme: dialogTheme(TThemeMode.dark),
          optionTheme: optionTheme(TThemeMode.dark),
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

}
