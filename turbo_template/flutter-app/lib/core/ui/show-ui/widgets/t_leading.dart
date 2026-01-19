import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TLeading extends StatelessWidget {
  const TLeading._({
    super.key,
    required this.child,
    required this.leading,
    required this.direction,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.spacing,
  });

  const TLeading.horizontal({
    Key? key,
    required Widget child,
    required Widget leading,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = TSizes.appPaddingX0p5,
  }) : this._(
         key: key,
         child: child,
         leading: leading,
         direction: Axis.horizontal,
         crossAxisAlignment: crossAxisAlignment,
         mainAxisAlignment: mainAxisAlignment,
         mainAxisSize: mainAxisSize,
         spacing: spacing,
       );

  const TLeading.vertical({
    Key? key,
    required Widget child,
    required Widget leading,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = TSizes.appPaddingX0p5,
  }) : this._(
         key: key,
         child: child,
         leading: leading,
         direction: Axis.vertical,
         crossAxisAlignment: crossAxisAlignment,
         mainAxisAlignment: mainAxisAlignment,
         mainAxisSize: mainAxisSize,
         spacing: spacing,
       );

  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Widget child;
  final Widget leading;
  final double spacing;

  @override
  Widget build(BuildContext context) => Flex(
    crossAxisAlignment: crossAxisAlignment,
    direction: direction,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    spacing: spacing,
    children: [leading, child],
  );
}
