import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/seals/t_image_seal.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_image.dart';
import 'package:turbo_flutter_template/generated/assets.gen.dart';

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
