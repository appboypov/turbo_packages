import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';

/// A theme model that provides access to both shadcn and material design themes.
///
/// Lazily initializes theme components when first accessed, using the provided
/// locator functions to resolve dependencies.
class TTheme {
  /// Creates a theme with the specified theme components.
  ///
  /// All parameters are required and should be functions that return the
  /// corresponding theme objects when called.
  TTheme({
    required LazyLocatorDef<ShadTextTheme> text,
    required LazyLocatorDef<ShadThemeData> data,
    required LazyLocatorDef<TThemeMode> mode,
    required LazyLocatorDef<TextTheme> materialText,
    required LazyLocatorDef<ThemeData> materialData,
  }) : _data = data,
       _materialData = materialData,
       _materialText = materialText,
       _mode = mode,
       _text = text;

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final LazyLocatorDef<ShadTextTheme> _text;
  final LazyLocatorDef<ShadThemeData> _data;
  final LazyLocatorDef<TThemeMode> _mode;
  final LazyLocatorDef<TextTheme> _materialText;
  final LazyLocatorDef<ThemeData> _materialData;

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  /// The shadcn text theme for typography styling.
  late final ShadTextTheme text = _text();

  /// The shadcn theme data containing colors and other visual properties.
  late final ShadThemeData data = _data();

  /// The current theme mode (light, dark, or system).
  late final TThemeMode mode = _mode();

  /// The Material Design text theme for typography styling.
  late final TextTheme materialText = _materialText();

  /// The Material Design theme data containing colors and other visual properties.
  late final ThemeData materialData = _materialData();
}
