import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/generated/l10n.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

extension ContextExtension on BuildContext {
  RenderBox? get renderBox {
    final renderBox = findRenderObject() as RenderBox?;
    return renderBox;
  }

  TTexts get texts => turboProvider.texts;
  TColors get colors => turboProvider.colors;
  TTools get tools => turboProvider.tools;
  TSizes get sizes => turboProvider.sizes;
  TDecorations get decorations => turboProvider.decorations;
  TData get data => turboProvider.data;
  double extendRatio(double width) => width / maxWidth;
  TThemeMode get themeMode => turboProvider.themeMode;

  TTheme get theme => TTheme(
    data: () => _shadTheme,
    materialData: () => _materialTheme,
    mode: () => _themeMode,
    text: () => _shadTextTheme,
    materialText: () => _materialTextTheme,
  );

  Strings get strings => Strings.of(this);
  ShadTextTheme get _shadTextTheme => _shadTheme.textTheme;
  ShadThemeData get _shadTheme => ShadTheme.of(this);
  TThemeMode get _themeMode => turboProvider.themeMode;
  TextTheme get _materialTextTheme => _materialTheme.textTheme;
  ThemeData get _materialTheme => Theme.of(this);

  TBreakpointConfig get breakpointConfig => turboProvider.breakpointConfig;
  TDeviceType get deviceType => turboProvider.data.deviceType;
  bool get hasKeyboard => sizes.keyboardInsets > 0;
  OverlayState get overlayState => Overlay.of(this, rootOverlay: true);
  ThemeData get themeData => Theme.of(this);
  TProvider get turboProvider => TProvider.of(this);
  MediaQueryData get media => MediaQuery.of(this);
  NavigatorState get navigation => Navigator.of(this);
  OverlayState get overlay => Overlay.of(this, rootOverlay: true);
  TickerProviderStateMixin get vsync => navigation;
  TextScaler get textScaler => TextScaler.linear(turboProvider.tools.scaledPerWidth(1));
  NavigatorState get navigator => Navigator.of(this);
  StatefulNavigationShell? get shell => StatefulNavigationShell.maybeOf(this)?.widget;
  double get maxWidth => media.size.width;
  double get maxHeight => media.size.height;

  void popNavigator<T>([T? result]) => navigator.pop(result);

  void tryPop<T>({T? result, VoidCallback? onFail}) {
    if (mounted && canPop()) {
      pop(result);
    } else {
      onFail?.call();
    }
  }

  void unfocus() => FocusScope.of(this).unfocus();
}
