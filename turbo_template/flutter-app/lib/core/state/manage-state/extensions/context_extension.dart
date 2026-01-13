import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_colors.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_data.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_decorations.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_sizes.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_texts.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/utils/t_tools.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

extension ContextExtension on BuildContext {
  TProvider get turboProvider => TProvider.of(this);
  TTexts get texts => turboProvider.texts;
  TColors get colors => turboProvider.colors;
  TTools get tools => turboProvider.tools;
  TSizes get sizes => turboProvider.sizes;
  TDecorations get decorations => turboProvider.decorations;
  TData get data => turboProvider.data;
  TThemeMode get themeMode => turboProvider.themeMode;
  MediaQueryData get media => MediaQuery.of(this);
  OverlayState get overlayState => Overlay.of(this, rootOverlay: true);
}
