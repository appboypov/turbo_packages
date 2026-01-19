import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';

class TButtonBox extends StatelessWidget {
  const TButtonBox({
    Key? key,
    required this.child,
    this.width = TSizes.minButtonHeight,
    this.height = TSizes.minButtonHeight,
  }) : super(key: key);

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: child, width: width, height: height);
  }
}
