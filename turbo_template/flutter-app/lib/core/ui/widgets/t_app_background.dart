import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/color_extension.dart';

class TAppBackground extends StatelessWidget {
  const TAppBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final color = context.colors.background.onBackground;

    // Reserve padding from top and bottom
    const topPadding = 132.0;
    const bottomPadding = 80.0;
    final availableHeight = height - topPadding - bottomPadding;

    // Define anchor points and sizes (as fractions of width/height)
    final anchors = [
      Offset(
        width * 0.08,
        topPadding + availableHeight * 0.10,
      ), // House 1: topLeft
      Offset(
        width * 0.50,
        topPadding + availableHeight * 0.13,
      ), // House 2: topCenter
      Offset(
        width * 0.85,
        topPadding + availableHeight * 0.08,
      ), // House 3: topRight
      Offset(
        width * 0.50,
        topPadding + availableHeight * 0.55,
      ), // House 4: center
      Offset(
        width * 0.15,
        topPadding + availableHeight * 0.80,
      ), // House 5: bottomLeft
      Offset(
        width * 0.50,
        topPadding + availableHeight * 0.90,
      ), // House 6: bottomCenter
      Offset(
        width * 0.85,
        topPadding + availableHeight * 0.80,
      ), // House 7: bottomRight
    ];
    final heights = [
      availableHeight * 0.18, // House 1
      availableHeight * 0.10, // House 2
      availableHeight * 0.20, // House 3
      availableHeight * 0.30, // House 4
      availableHeight * 0.18, // House 5
      availableHeight * 0.08, // House 6
      availableHeight * 0.18, // House 7
    ];
    final assets = [
      // kSvgsHouse1,
      // kSvgsHouse2,
      // kSvgsHouse3,
      // kSvgsHouse4,
      // kSvgsHouse5,
      // kSvgsHouse6,
      // kSvgsHouse7,
    ];

    return Stack(
      fit: StackFit.expand,
      children: List.generate(assets.length, (i) {
        return Positioned(
          left: anchors[i].dx - heights[i] / 2,
          top: anchors[i].dy - heights[i] / 2,
          child: SvgPicture.asset(
            assets[i],
            height: heights[i],
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        );
      }),
    );
  }
}
