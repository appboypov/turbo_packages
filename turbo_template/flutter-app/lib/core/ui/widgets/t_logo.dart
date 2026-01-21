import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/generated/assets.gen.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/seals/t_image_seal.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_image.dart';

class TLogo extends StatelessWidget {
  const TLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => switch (context.themeMode) {
    TThemeMode.dark => TImage(
      image: TImagePng(
        imageLocation: const $AssetsPngsGen().logoDarkMode.path,
      ),
    ),
    TThemeMode.light => TImage(
      image: TImagePng(
        imageLocation: const $AssetsPngsGen().logoLightMode.path,
      ),
    ),
  };
}
