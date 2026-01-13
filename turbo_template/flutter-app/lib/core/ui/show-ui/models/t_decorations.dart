import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_device_type.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_colors.dart';

class TDecorations {
  const TDecorations({
    required this.colors,
    required this.themeMode,
    required this.deviceType,
  });

  final TColors colors;
  final TThemeMode themeMode;
  final TDeviceType deviceType;
}

