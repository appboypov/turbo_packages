import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/seals/t_image_seal.dart';

class TImage extends StatelessWidget {
  const TImage({Key? key, required this.image}) : super(key: key);

  final TImageSeal image;

  @override
  Widget build(BuildContext context) => switch (image) {
    final TImagePng sImage => Image.asset(
      sImage.imageLocation,
      height: sImage.height,
      width: sImage.width,
    ),
    final TImageSvg sImage => SvgPicture.asset(
      sImage.imageLocation,
      height: sImage.height,
      width: sImage.width,
    ),
  };
}
